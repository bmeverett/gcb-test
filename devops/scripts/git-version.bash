#!/bin/bash
#apt-get update
#apt-get install jq -y
if [ -z "$TAG_NAME"]
then
    echo here
    TAG_NAME=$(curl -X "POST" "https://api.github.com/graphql" \
     -H "Authorization: Bearer $_FLO_NPM_TOKEN" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
	"query": "query{repository(name:\\"experience-service\\",owner:\\"flocasts\\"){releases(last:1){nodes{tagName}}}}",
	"variables": {}
}')
fi
TAG_NAME=$(sed 's/^v//' <<< $TAG_NAME)
#echo $TAG_NAME >> /workspace/version.txt
#echo -e "\n" >> /workspace/.env
#echo _EXP_VERSION=$TAG_NAME >> /workspace/.env
echo $TAG_NAME
#cat /workspace/.env