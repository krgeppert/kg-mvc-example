import org.junit.After;
import org.junit.Before;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

import java.util.concurrent.TimeUnit;
import java.util.Date;
import java.io.File;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.*;
import static org.openqa.selenium.OutputType.*;

public class Testing {
    FirefoxDriver wd;
    
    @Before
    public void setUp() throws Exception {
        wd = new FirefoxDriver();
        wd.manage().timeouts().implicitlyWait(60, TimeUnit.SECONDS);
    }
    
    @Test
    public void Testing() {
        wd.get("http://localhost:5050/");
        wd.findElement(By.cssSelector("h1.text-center")).click();
        wd.findElement(By.cssSelector("html")).click();
        new Actions(wd).doubleClick(wd.findElement(By.cssSelector("html"))).build().perform();
        wd.findElement(By.cssSelector("html")).click();
        wd.findElement(By.cssSelector("html")).click();
        if (!wd.findElement(By.tagName("html")).getText().contains("Welcome to ultiAnalytics team hey there")) {
            System.out.println("verifyTextPresent failed");
        }
        wd.findElement(By.cssSelector("h1.text-center")).click();
        new Actions(wd).doubleClick(wd.findElement(By.cssSelector("html"))).build().perform();
        new Actions(wd).doubleClick(wd.findElement(By.cssSelector("html"))).build().perform();
        wd.findElement(By.cssSelector("html")).click();
    }
    
    @After
    public void tearDown() {
        wd.quit();
    }
    
    public static boolean isAlertPresent(FirefoxDriver wd) {
        try {
            wd.switchTo().alert();
            return true;
        } catch (NoAlertPresentException e) {
            return false;
        }
    }
}
