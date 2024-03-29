FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=/opt/sonar-scanner/bin:$PATH

# Install dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends curl unzip openjdk-17-jdk && \
    rm -rf /var/lib/apt/lists/*

# Install NVM and node version LTS
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && npm install --global yarn

# Install SonarQube Scan
RUN curl -OL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip 
RUN unzip sonar-scanner-cli-5.0.1.3006-linux.zip -d /opt
RUN mv /opt/sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner
RUN rm -f sonar-scanner-cli-5.0.1.3006-linux.zip

WORKDIR /sec

# Copy application code
COPY . .

# CMD directive
CMD ["/bin/bash"]
