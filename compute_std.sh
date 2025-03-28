LOG_FILE=/data/speedlog_${HOSTNAME}.log

echo current date: $(date) 
echo 10m======= 
a=$(date +%s)
tpm2_hash -o hash.bin -t ticket.bin /data/10m_file.bin
b=$(date +%s)
echo starttime: $a
echo endtime: $b
echo total: $(( b - a )) 

# echo 100m======= 
# a=$(date +%s)
# tpm2_hash -o hash.bin -t ticket.bin /data/100m_file.bin
# b=$(date +%s)
# echo starttime: $a 
# echo endtime: $b 
# echo total: $(( b - a )) 
# echo -e '\n' 


# echo 1g======= 
# a=$(date +%s)
# tpm2_hash -o hash.bin -t ticket.bin /data/1g_file.bin
# b=$(date +%s)
# echo starttime: $a 
# echo endtime: $b 
# echo total: $(( b - a )) 
# echo -e '\n' 
