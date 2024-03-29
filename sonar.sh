docker run \
    --rm \
    -e SONAR_HOST_URL="http://${SONARQUBE_URL}" \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${YOUR_PROJECT_KEY}" \
    -e SONAR_LOGIN="myAuthenticationToken" \
    -v "${YOUR_REPO}:/usr/src" \
    sonarsource/sonar-scanner-cli

docker build --platform linux/x86_64 -t sonarcli .


sonar-scanner \
  -Dsonar.projectKey=local-doc \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=sqp_5955c8a0aab2cf39582b591a4051d74dd5b1ed13