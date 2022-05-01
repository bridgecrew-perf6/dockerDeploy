#Get app name from config
imageUrl=$(cat version)
appName=${imageUrl##*/}
appName=${appName%%:*}
echo "Current Processing is:"$appName

#Delete all images according this app
echo "Delete images"
#docker rm --force `docker ps | grep $appName | awk '{print $1}'`
docker rmi --force `docker images | grep $appName | awk '{print $3}'`

#Build image
#echo "begin build new image。。。"
bs=$(docker build . )
imageId=${bs: 0-12}
echo "build finish，imagegID is:"$imageId

#echo "set image version"
oldVersion=${imageUrl##*.}
newVersion=$[$oldVersion + 1]

echo "old image version is:"$imageUrl
sed -i s/$oldVersion/$newVersion/g version
newImageUrl=$(cat version)
echo "new image version is:"$newImageUrl
#echo "set image version OK"

#set tag for image
echo "docker tag $imageId $newImageUrl"
docker tag $imageId $newImageUrl
echo "set tag OK"

#push image to library
echo "docker push $newImageUrl"
docker push $newImageUrl
echo "push OK, task finished!"

