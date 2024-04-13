#!/bin/bash

# configure the sonarExecution limit memory
export SONAR_SCANNER_OPTS="-Xmx6048m"

# Check if exist in root a file called sonar-pre-execute
# if it does, then execute.
file=sonar-pre-execute.sh
if [ -e $file ]; then
bash "$file"
else
echo "No PRE .sh file found in the root folder."
fi

# If its a terraform directory, it's necessary run some steps earlier,
# Its all described in Medium (link in README).
# Basically you need to run terraform plan -out tf.plan and save the 
# tf.plan or anything.plan in root
# run checkout and generate the sarif files
find "." -type f -name "*.plan" | while IFS= read -r file; do
filename=$(basename -- "$file")
filename_no_ext="${filename%.*}"
terraform show -json "$file" > "$filename_no_ext.json"
checkov -f "$filename_no_ext.json" -o "$filename_no_ext.sarif"
done

#Trivy / Tfsec
# If in root has a file trivy.config, it will run the trivy analysis.
local filename="trivy.config"
if [ -f "$filename" ]; then
while IFS= read -r line; do
trivy config "$line" --format sarif > "${$line}/ouput_trivy.sarif"
done < "$filename"
fi

# tflint
# If in root has a file tflint.config, it will run the tflint analysis.
local filename="tflint.config"
if [ -f "$filename" ]; then
while IFS= read -r line; do
tflint --format=sarif > "${$line}/ouput_tflint.sarif"
done < "$filename"
fi


# Run dependency check analyzes
# It has some languages suport you can check here 
# - https://jeremylong.github.io/DependencyCheck/analyzers/index.html
dependency-check --out . -f HTML -f JSON --disableOssIndex true

# Processa os dados e envia para o sonar
# Remember that in root folder need to exist the sonar-project.properties file
sonar-scanner -Dsonar.token=$SONAR_TOKEN -Dsonar.host.url=$SONAR_HOST_URL
    -Dsonar.projectVersion=$SONAR_PROJECT_VERSION

# Check if exist in root a file called sonar-pos-execute
# if it does, then execute.
file=sonar-pos-execute.sh
if [ -e $file ]; then
bash "$file"
else
echo "No POS .sh file found in the root folder."
fi
