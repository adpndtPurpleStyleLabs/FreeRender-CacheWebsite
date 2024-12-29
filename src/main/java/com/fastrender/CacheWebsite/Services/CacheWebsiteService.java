package com.fastrender.CacheWebsite.Services;

import org.openqa.selenium.WebDriver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
@Scope(value="prototype")
public class CacheWebsiteService {

    @Autowired
    private SeleniumService seleniumService;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    private WebDriver driver;

    public void cacheWebsite(String url) {
        try {
            driver = seleniumService.getWebDriver();
            long startTime = System.nanoTime();
            driver.get(url);
            String pageSource = driver.getPageSource();
            redisTemplate.opsForValue().set(url, pageSource);
            long endTime = System.nanoTime();
            long durationInNano = endTime - startTime;
            long durationInMillis = durationInNano / 1_000_000;
            System.out.println("Execution time in milliseconds: " + durationInMillis);

        } catch (Exception exception) {
            if (null != driver) {
                seleniumService.killWebDriver();
            }
            throw new RuntimeException("ERROR " + exception.getMessage() + exception.getStackTrace());

        } finally {
            if (null != driver) {
                seleniumService.killWebDriver();
            }
        }
    }
}
