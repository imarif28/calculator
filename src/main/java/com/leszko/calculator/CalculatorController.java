package com.leszko.calculator; 
import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.web.bind.annotation.RequestMapping; 
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.bind.annotation.RestController; 
 
@RestController 
class CalculatorController { 
     @Autowired 
     private Calculator calculator; 
 
     @RequestMapping("/sum") 
     String sum(@RequestParam("a") Integer a,  
                @RequestParam("b") Integer b) { 
          return String.valueOf(calculator.sum(a, b)); 
     } 
     
     @RequestMapping("/")
     String welcome() {
          return "<h1>Selamat Datang di Calculator API v2!</h1><p>Versi ini baru saja di-deploy otomatis oleh Jenkins CI/CD.</p>";
     }
} 
