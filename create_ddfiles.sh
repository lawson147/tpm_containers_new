if [ ! -f /data/1g_file.bin ]; then
	dd if=/dev/zero of=/data/1g_file.bin bs=1G count=1
fi
if [ ! -f /data/1m_file.bin ]; then
	dd if=/dev/zero of=/data/1m_file.bin bs=1M count=1
fi
if [ ! -f /data/100m_file.bin ]; then
	dd if=/dev/zero of=/data/100m_file.bin bs=1M count=100
fi
if [ ! -f /data/10m_file.bin ]; then
	dd if=/dev/zero of=/data/10m_file.bin bs=1M count=10
fi
