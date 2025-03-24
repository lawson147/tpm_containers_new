a=$(date +%s)
tpm2_hash -H e -g sha1 -o hash.bin -t ticket.bin 5gfile.bin
b=$(date +%s)
echo starttime: $a > speedlog.txt
echo endtime: $b >> speedlog.txt
echo total: $(( a - b)) >> speedlog.txt
