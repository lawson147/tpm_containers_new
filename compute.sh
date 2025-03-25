a=$(date +%s)
tpm2_hash -o hash.bin -t ticket.bin 1g_file.bin
b=$(date +%s)
echo starttime: $a > speedlog.txt
echo endtime: $b >> speedlog.txt
echo total: $(( a - b)) >> speedlog.txt
