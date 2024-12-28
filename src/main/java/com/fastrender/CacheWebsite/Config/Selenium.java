package com.fastrender.CacheWebsite.Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

@Configuration
public class Selenium {
//    private static final String SELENIUM_HUB_URL = "http://139.99.9.42:4490/wd/hub";
    private static final String SELENIUM_HUB_URL = "http://localhost:4444/wd/hub";

    @Bean
//    @Scope("prototype")
    public WebDriver getWebDriver() throws MalformedURLException {
        ChromeOptions options = new ChromeOptions();
//        options.addArguments("--headless"); // Optional: Run in headless mode
        options.addArguments("--no-sandbox"); // Recommended for Docker
        options.addArguments("--disable-dev-shm-usage"); // Recommended for Docker

        WebDriver driver = new RemoteWebDriver(new URL(SELENIUM_HUB_URL), options);
        driver.manage().window().maximize();
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(60));
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

        return driver;
    }
}
