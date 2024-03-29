docker run -d --name sonarqube \
    -p 9000:9000 \
    -e SONAR_JDBC_URL=jdbc:postgresql://172.17.0.2:5432/sonarqube \
    -e SONAR_JDBC_USERNAME=postgres \
    -e SONAR_JDBC_PASSWORD=postgres \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
    sonarqube:lts-community