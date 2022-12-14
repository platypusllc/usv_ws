echo "This script will start up the docker image, with your current source directory mounted under /ws"
docker run -it --mount type=bind,source="$(pwd)",target=/ws usv
