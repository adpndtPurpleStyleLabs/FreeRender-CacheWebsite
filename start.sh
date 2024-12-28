#!/bin/bash

# Start Selenium server in the background
java -jar /opt/selenium/selenium-server-standalone-3.5.3.jar &

# Start the Spring Boot application
java -jar /app/app.jar
