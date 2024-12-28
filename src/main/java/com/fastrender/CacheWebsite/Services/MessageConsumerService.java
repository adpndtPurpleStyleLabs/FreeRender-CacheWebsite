package com.fastrender.CacheWebsite.Services;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageConsumerService {

    @Autowired
    private CacheWebsiteService cacheWebsiteService;

    @RabbitListener(queues = "sitemap-links-queue")
    public void receiveMessage(String message) {
        cacheWebsiteService.cacheWebsite(message);
    }
}
