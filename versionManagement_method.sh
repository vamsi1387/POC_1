set -ex

addVersion()
{
  i=VERSION
  val=`cat VERSION`
  dotCount=`grep '\.' -o $i | wc -l`
  # if there is no version tag yet, let's start at 0.0.0
  if [ -z "$val" ]; then
     echo "No existing version, starting at 0.0.0"
     echo "0.0.0" > VERSION
     exit 1
  fi
  if [ $dotCount -eq 0 ]
  then
      val=`expr $val + 1`
  else
      val=`echo $val | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}'`
  fi
  echo $val > VERSION
}

containerid=`docker container ls -n 1 -q`
echo $containerid
da=`docker diff $containerid`
IMAGE=`docker ps --format='{{.Image}}' -n 1`
USERNAME=vamsi1387

if [ -z "$da" ]
then
	git pull
	# bump version
	IMAGE=helloworld
	#docker run -v $(pwd):/home/ec2-user/ vamsi1387/helloworld bash
	addVersion
	version=`cat VERSION`
	echo "version: $version"
	# building the image
	docker build -t $USERNAME/$IMAGE:latest .
	# tag it
	git add -A
	git commit -m "version $version"
	git tag -a "$version" -m "version $version"
	git push
	#git push --tags
	docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version
	# push it
	docker rmi -f $USERNAME/$IMAGE:latest
	docker push $USERNAME/$IMAGE:$version

else
      addVersion //calling addVersion method for incrementing the image version
      VERSION=`cat VERSION`
      docker commit $containerid $USERNAME/$IMAGE:$VERSION
fi
