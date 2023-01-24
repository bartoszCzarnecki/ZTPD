import java.io.IOException;
import java.util.ArrayList;

import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPRuntimeProvider;
import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

public class Main 
{
    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) 
    {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();
        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try 
        {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } 
        catch (EPCompileException e) 
        {
            throw new RuntimeException(e);
        } 
        catch (EPDeployException e) 
        {
            throw new RuntimeException(e);
        }
        return deployment;
    }


    public static void main(String[] args) throws IOException 
    {

        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);

        ArrayList<String> zadania = new ArrayList<String>();

        EPDeployment deployment = compileAndDeploy(epRuntime,
            "select istream data, spolka, obrot" +
            "from KursAkcji(market='NYSE').win:ext_timed_batch(data.getTime(), 7 days)" +
            "order by obrot desc" +
            "limit 1 offset 2");
        
/* Zadania

// zadanie 5
select istream data, kursZamkniecia, spolka, max(kursZamkniecia) - kursZamkniecia roznica
from KursAkcji.win:ext_timed_batch(data.getTime(), 1 days)

// zadanie 6
select istream data, kursZamkniecia, spolka, max(kursZamkniecia) - kursZamkniecia roznica
from KursAkcji.win:ext_timed_batch(data.getTime(), 1 days)
where spolka IN ('IBM', 'Honda', 'Microsoft')

// zadanie 7a
select istream data, kursZamkniecia, spolka, kursOtwarcia
from KursAkcji.win:length(1)
where kursOtwarcia < kursZamkniecia

// zadanie 7b
select istream data, kursZamkniecia, spolka, kursOtwarcia
from KursAkcji(KursAkcji.hadIncrease(kursOtwarcia, kursZamkniecia)).win:length(1)

// zadanie 8
select istream data, kursZamkniecia, spolka, max(kursZamkniecia) - kursZamkniecia roznica
from KursAkcji(spolka IN ('PepsiCo', 'CocaCola')).win:ext_timed(data.getTime(), 7 days)

// zadanie 9
select istream data, kursZamkniecia, spolka
from KursAkcji(spolka IN ('PepsiCo', 'CocaCola')).win:ext_timed_batch(data.getTime(), 1 days)
having kursZamkniecia = max(kursZamkniecia)

// zadanie 10
select istream max(kursZamkniecia) maksimum
from KursAkcji().win:ext_timed_batch(data.getTime(), 7 days)

// zadanie 11
select istream p.data, c.kursZamkniecia kursCoc, p.kursZamkniecia kursPep
from KursAkcji(spolka='PepsiCo').win:ext_timed(data.getTime(), 1 days) as p,
KursAkcji(spolka='CocaCola').win:ext_timed(data.getTime(), 1 days) as c
WHERE p.kursZamkniecia > c.kursZamkniecia
and p.data = c.data

// zadanie 12
select istream k.data, k.kursZamkniecia kursBiezacy, k.spolka, k.kursZamkniecia - u.kursZamkniecia roznica
from KursAkcji(spolka IN ('PepsiCo', 'CocaCola')).win:length(1) as k,
KursAkcji().std:firstunique(spolka) u
WHERE k.spolka = u.spolka

// zadanie 13
select istream k.data, k.kursZamkniecia kursBiezacy, k.spolka, k.kursZamkniecia - u.kursZamkniecia roznica
from KursAkcji().win:length(1) as k,
KursAkcji().std:firstunique(spolka) u
WHERE k.spolka = u.spolka and k.kursZamkniecia - u.kursZamkniecia > 0

// zadanie 14
select istream a.data aData, b.data bData, b.spolka, a.kursZamkniecia aKurs, b.kursZamkniecia bKurs
from KursAkcji().win:ext_timed_batch(data.getTime(), 7 days) as a,
KursAkcji().win:ext_timed_batch(data.getTime(), 7 days) b
WHERE a.spolka = b.spolka and a.kursZamkniecia - b.kursZamkniecia > 3

// zadanie 15
select istream data, spolka, obrot
from KursAkcji(market='NYSE').win:ext_timed_batch(data.getTime(), 7 days)
order by obrot desc
limit 3

// zadanie 16
select istream data, spolka, obrot
from KursAkcji(market='NYSE').win:ext_timed_batch(data.getTime(), 7 days)
order by obrot desc
limit 1 offset 2
*/

        ProstyListener prostyListener = new ProstyListener();
        for (EPStatement statement : deployment.getStatements()) 
        {
            statement.addListener(prostyListener);
        }

        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());
    }
}
