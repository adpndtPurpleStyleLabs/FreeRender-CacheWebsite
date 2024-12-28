# Use an OpenJDK base image for Spring Boot
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install dependencies: curl, wget, unzip, etc.
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip && \
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

# Download Selenium Server (Standalone) JAR
RUN wget -q https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.14.0/selenium-server-4.14.0.jar -O /app/selenium-server.jar

# Copy Spring Boot application JAR to container
COPY target/cachewebsite.jar /app/app.jar

# Expose Selenium Hub port (4444) and Spring Boot port (8080)
EXPOSE 4444 8080

# Start Selenium server and Spring Boot application
CMD ["sh", "-c", "java -jar /app/selenium-server.jar hub"]
