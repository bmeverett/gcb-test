if [ -z "$TAG_NAME"]
then
    echo here
    TAG_NAME=$(git describe --abbrev=0 --tags)
    TAG_NAME=$(sed 's/^v//' <<< $TAG_NAME)
    echo $TAG_NAME > /workspace/version.txt
    echo $TAG_NAME
else
    TAG_NAME=$(sed 's/^v//' <<< $TAG_NAME)
    echo $TAG_NAME > /workspace/version.txt
    echo $TAG_NAME
fi