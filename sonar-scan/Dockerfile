# Base image
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget unzip openjdk-17-jdk curl python3-pip pkg-config python2 && \
    apt-get clean \
    zip apt-utils build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev awscli && \
    rm -rf /var/lib/apt/lists/*

# Set Java environment variables necessary to sonar
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install Node.js using NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && npm install --global yarn

# Configure shell Environment
ENV PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Install SonarQube Scan, if you want to change the version, navigate to binaries.sonarsource.com
# and check other versions
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip && \
    unzip sonar-scanner-cli-5.0.1.3006-linux.zip -d /opt && \
    ls /opt && \
    mv /opt/sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner && \
    rm -f sonar-scanner-cli-5.0.1.3006-linux.zip

# Configure shell Environment
ENV PATH="/opt/sonar-scanner/bin:$PATH"

# Install OWASP Dependency Check
ENV owasp_dep_api=""
RUN export VERSION=$(curl -s https://jeremylong.github.io/DependencyCheck/current.txt) && \
        curl -Ls "https://github.com/jeremylong/DependencyCheck/releases/download/v$VERSION/dependency-check-$VERSION-release.zip" --output dependency-check.zip  && \
        unzip dependency-check.zip && \
        rm -f dependency-check.zip && \
        mv dependency-check /opt && \
        mv /opt/dependency-check/bin/dependency-check.sh /opt/dependency-check/bin/dependency-check
RUN chmod +x /opt/dependency-check/bin/dependency-check
RUN sh /opt/dependency-check/bin/dependency-check --updateonly --nvdApiKey "$owasp_dep_api"
ENV PATH="/opt/dependency-check/bin:$PATH"

# Install Trivy
RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.50.1/trivy_0.50.1_Linux-64bit.tar.gz && \
    tar zxvf trivy_0.50.1_Linux-64bit.tar.gz && \
    mv trivy /usr/local/bin && \
    rm trivy_0.50.1_Linux-64bit.tar.gz

# Install TFLint
RUN wget https://github.com/terraform-linters/tflint/releases/download/v0.50.3/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && \
    mv tflint /usr/local/bin && \
    rm tflint_linux_amd64.zip

# Install Checkov
RUN pip3 install checkov


# Set the working directory
WORKDIR /app

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint to run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Define the command to run when the container starts
CMD ["/bin/bash"]