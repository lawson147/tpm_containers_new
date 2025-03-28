LOG_FILE=/data/speedlog_${HOSTNAME}.log

echo current date: $(date) >> $LOG_FILE

echo 10m======= >> $LOG_FILE
a=$(date +%s)
tpm2_hash -o hash.bin -t ticket.bin /data/10m_file.bin
b=$(date +%s)
echo starttime: $a >> $LOG_FILE
echo endtime: $b >> $LOG_FILE
echo total: $(( b - a )) >> $LOG_FILE
echo -e '\n' >> $LOG_FILE



echo 100m======= >> $LOG_FILE
a=$(date +%s)
# tpm2_hash -o hash.bin -t ticket.bin /data/100m_file.bin
b=$(date +%s)
echo starttime: $a >> $LOG_FILE
echo endtime: $b >> $LOG_FILE
echo total: $(( b - a )) >> $LOG_FILE
echo -e '\n' >> $LOG_FILE



echo 1g======= >> $LOG_FILE
a=$(date +%s)
# tpm2_hash -o hash.bin -t ticket.bin /data/1g_file.bin
b=$(date +%s)
echo starttime: $a >> $LOG_FILE
echo endtime: $b >> $LOG_FILE
echo total: $(( b - a )) >> $LOG_FILE
echo -e '\n' >> $LOG_FILE
