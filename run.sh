name=$(sudo docker run --privileged -d sd5 | awk '{print $1}')
echo $name
sudo docker exec -it $name /bin/bash
