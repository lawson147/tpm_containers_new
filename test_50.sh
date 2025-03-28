declare -a name

for n in {1..50}
do
  name[$n]=$(sudo docker run --privileged -v ddfiles:/data -d sd5 | awk '{print $1}')
  echo ${name[$n]}
done

# waiting for abrmd booting
sleep 50

for n in {1..50}
do
  sudo docker exec -d ${name[$n]} /bin/bash -c "./compute.sh"
  echo -e "$n\n"
done
