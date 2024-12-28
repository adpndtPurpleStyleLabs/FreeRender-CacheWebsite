# Use an OpenJDK base image for Spring Boot
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (latest stable version)
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN wget -q https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Download Selenium Hub jar (standalone version)
RUN wget -q https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.14.0/selenium-server-4.14.0.jar -O /app/selenium-server.jar

# Copy Spring Boot application JAR to container
COPY target/cachewebsite.jar /app/app.jar

# Expose Selenium Hub port (4444) and Spring Boot port (8080)
EXPOSE 4444 8080

# Add a script to start Selenium Hub and Spring Boot application after Selenium is ready
RUN echo '#!/bin/bash \n\
# Start Selenium Hub \n\
java -jar /app/selenium-server.jar hub & \n\
# Wait for Selenium Hub to be ready \n\
while ! curl --silent --fail http://localhost:4444/status; do \n\
    echo "Waiting for Selenium Hub to start..."; \n\
    sleep 5; \n\
done; \n\
echo "Selenium Hub is ready. Starting Spring Boot application..."; \n\
# Start Spring Boot Application \n\
java -jar /app/app.jar' > /app/start.sh

# Make the script executable
RUN chmod +x /app/start.sh

# Start the Selenium Hub and Spring Boot Application
CMD ["/app/start.sh"]
