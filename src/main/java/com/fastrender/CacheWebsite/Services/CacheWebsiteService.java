package com.fastrender.CacheWebsite.Services;

import org.openqa.selenium.WebDriver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class CacheWebsiteService {

    @Autowired
    private WebDriver webDriver;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    public void cacheWebsite(String url) {
        long startTime = System.nanoTime(); // Record start time

        webDriver.get(url);
        String pageSource = webDriver.getPageSource();
        redisTemplate.opsForValue().set(url, pageSource);
        webDriver.quit();
        long endTime = System.nanoTime(); // Record end time

        // Calculate the elapsed time
        long durationInNano = endTime - startTime; // Execution time in nanoseconds
        long durationInMillis = durationInNano / 1_000_000; // Convert to milliseconds

        System.out.println("Execution time in milliseconds: " + durationInMillis);
    }
}
