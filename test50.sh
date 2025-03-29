# init tpm_num(based on flock)
TPM_NUM="/var/lib/docker/volumes/ddfiles/_data/tpm.num"
COUNT=50
echo 0 | sudo tee $TPM_NUM

declare -a name

for n in {1..50}
do
  name[$n]=$(sudo docker run --privileged -v ddfiles:/data -d sd5 | awk '{print $1}')
  echo ${name[$n]}
done

# waiting for abrmd booting
while number=$(sudo flock -s $TPM_NUM -c "sudo head $TPM_NUM"); do
    if [[ "$number" -ge $COUNT ]]; then
        break
    fi
done

for n in {1..50}
do
  sudo docker exec -d ${name[$n]} /bin/bash -c "./compute.sh"
  echo -e "$n\n"
done
