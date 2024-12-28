# Base image with OpenJDK for Spring Boot
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl gnupg unzip --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Fetch ChromeDriver version compatible with installed Chrome
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1) && \
    echo "Detected Chrome major version: $CHROME_VERSION" && \
    CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    wget -q https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/ && chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Install Selenium Server
RUN wget -q https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.14.0/selenium-server-4.14.0.jar -O selenium-server.jar

# Copy Spring Boot application JAR
COPY target/cachewebsite.jar /app/app.jar

# Expose necessary ports
EXPOSE 4444 8080

# Start Selenium Hub and Spring Boot application
CMD ["sh", "-c", "java -jar selenium-server.jar standalone & java -jar app.jar"]
