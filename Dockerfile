# Base image with OpenJDK for Spring Boot
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
# Install a specific version of Google Chrome
RUN wget -q https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.90-1_amd64.deb && \
    apt-get install -y ./google-chrome-stable_114.0.5735.90-1_amd64.deb && \
    rm google-chrome-stable_114.0.5735.90-1_amd64.deb

# Install ChromeDriver for version 114
RUN wget -q https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip


# Install Selenium Server
RUN wget -q https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.14.0/selenium-server-4.14.0.jar -O selenium-server.jar

# Copy Spring Boot application JAR to container
COPY target/cachewebsite.jar /app/app.jar

# Expose ports for Selenium (4444) and Spring Boot application (8080)
EXPOSE 4444 8080

# Start Selenium Server and Spring Boot application
CMD ["sh", "-c", "java -jar selenium-server.jar standalone & java -jar app.jar"]
