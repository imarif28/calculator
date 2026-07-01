package com.leszko.calculator; 
import org.junit.Test; 
import static org.junit.Assert.assertEquals; 
 
public class CalculatorControllerTest { 
     private CalculatorController controller = new CalculatorController(); 
 
     @Test 
     public void testWelcome() { 
          assertEquals("<h1>Selamat Datang di Calculator API v1!</h1><p>Versi ini baru saja di-deploy otomatis oleh Jenkins CI/CD.</p>", controller.welcome()); 
     } 
}
