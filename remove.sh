if [ $1x=x ]; then
	sudo docker rm $(sudo docker ps -q)
elif [ $1=f ]; then
	sudo docker stop $(sudo docker ps -q)
	sudo docker rm -f $(sudo docker ps -q)
fi
