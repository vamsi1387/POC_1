set -ex

containerid=`docker container ls -n 1 -q`
echo $containerid
da=`docker diff $containerid`
IMAGE=`docker ps --format='{{.Image}}' -n 1`
USERNAME=vamsi1387

if [ -z "$da" ]
then
	git pull
	# bump version
	#docker run --rm -v "$PWD":/app treeder/bump patch
	#docker run -v $(pwd):/home/ec2-user/ vamsi1387/helloworld bash
	./addVersion.sh
	version=`cat VERSION`
	echo "version: $version"
	# run build
	./build.sh
	# tag it
	git add -A
	git commit -m "version $version"
	git tag -a "$version" -m "version $version"
	git push
	git push --tags
	docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version
	# push it
	docker rmi -f $USERNAME/$IMAGE:latest
	docker push $USERNAME/$IMAGE:$version

else
      ./addVersion.sh //script for version
      VERSION=`cat VERSION`
      docker commit $containerid $USERNAME/$IMAGE:$VERSION
fi
