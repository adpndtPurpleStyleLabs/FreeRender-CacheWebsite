package com.fastrender.CacheWebsite.Config;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

import java.net.MalformedURLException;
import java.net.URL;
import java.time.Duration;

@Configuration
public class Selenium {
//    private static final String SELENIUM_HUB_URL = "http://139.99.9.42:4490/wd/hub";

    @Value("${SELENIUM_HUB_URL}")
    private String SELENIUM_HUB_URL;

    @Bean
//    @Scope("prototype")
    public WebDriver getWebDriver() throws MalformedURLException {
        // Selenium Hub URL (in this case, it runs in the same container)
        String hubUrl = "http://localhost:4444/wd/hub"; // Hub URL

        // ChromeOptions configuration
        ChromeOptions options = new ChromeOptions();
        // Add any desired options here
        options.addArguments("--headless");  // Run Chrome in headless mode (optional)
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");

        // Initialize RemoteWebDriver with the Hub URL and ChromeOptions
        return new RemoteWebDriver(new URL(hubUrl), options);
    }
}
