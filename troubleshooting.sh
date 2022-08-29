R='\033[0;31m'
S=$(tput bold)
N=$(tput sgr0)
b=$(printf "%s\n\n")

echo -e "${R}${S}Installing Net-tools and nano{N}"
sudo apt update
sudo apt install net-tools nano -y

echo -e "${R}${S}OS:${N}"
cat /etc/lsb-release
echo ""

echo -e "${R}${S}"Processors"${N}"
cat /proc/cpuinfo |grep "processor"
echo $b

echo -e "${R}${S}"RAM"${N}"
grep MemTotal /proc/meminfo
echo $b

echo -e "${R}${S}Hostname:${N}"
cat /etc/hostname
echo $b

echo -e "${R}${S}"Public IP:"${N}"
curl ifconfig.io
echo $b

echo -e "${R}${S}Username:${N}"
cat /etc/passwd|grep /home|grep /bin/bash
#printf "%s\n\n"
echo $b

echo -e "${R}${S}"Listening Ports"${N}"
netstat -antp|grep LISTEN
