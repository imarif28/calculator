package smoke; 
 
import io.cucumber.junit.CucumberOptions; 
import io.cucumber.junit.Cucumber; 
import org.junit.runner.RunWith; 

/** Smoke Test */ 
@RunWith(Cucumber.class) 
@CucumberOptions(features = "classpath:smoke", glue = "acceptance") 
public class SmokeTest { }
