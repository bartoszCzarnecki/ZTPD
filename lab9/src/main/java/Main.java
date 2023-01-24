import java.io.IOException;

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

        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, ((2*kursOtwarcia)-sum(kursOtwarcia)) as roznica, spolka " +
                "from KursAkcji(spolka='Oracle').win:length(2) " +
                "having ((2*kursOtwarcia)-sum(kursOtwarcia))>0 AND sum(kursOtwarcia)!=kursOtwarcia");

        /* zadanie 24
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream spolka as X, kursOtwarcia as Y " +
                        "from KursAkcji.win:length(3) where spolka = 'Oracle'");
         */
        /* zadanie 25
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream data, spolka, kursOtwarcia " +
                        "from KursAkcji.win:length(3) where spolka = 'Oracle'");
         */

        /* zadanie 26
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select irstream data, spolka, kursOtwarcia " +
                        "from KursAkcji(spolka = 'Oracle').win:length(3)");
         */

        /* zadanie 27
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia " +
                        "from KursAkcji(spolka = 'Oracle').win:length(3)");
         */

        /* zadanie 28
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, max(kursOtwarcia) " +
                        "from KursAkcji(spolka = 'Oracle').win:length(5)");
         */

        /* zadanie 29
        EPDeployment deployment = compileAndDeploy(epRuntime,
                "select istream data, spolka, kursOtwarcia-max(kursOtwarcia) as roznica " +
                        "from KursAkcji(spolka = 'Oracle').win:length(5)");
         */

        /* zadanie 30
        "select istream data, ((2*kursOtwarcia)-sum(kursOtwarcia)) as roznica, spolka " +
        "from KursAkcji(spolka='Oracle').win:length(2) " +
        "having ((2*kursOtwarcia)-sum(kursOtwarcia))>0 AND sum(kursOtwarcia)!=kursOtwarcia"
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
