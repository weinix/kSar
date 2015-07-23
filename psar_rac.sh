#!/bin/bash
# by wei wang
# V1.1 support multiple days
 
if [ $# -ne 8 ]; then
  echo Usage: $0 [server1] [server2] [start_day] [start time] [end_day] [end time] [odir] [label]
  echo "Sample usage: ./psar.sh 06 10:48 07 11:55 test \"12/6: 9K Hugepages; 5000 Users +200 very 10min\""
  exit 1
fi
server1=$1 
server2=$2 
sa=$3
st=$4
ea=$5
et=$6
dir=$5
label=$6 
old_pwd=`pwd`

KSAR="/drives/c/Users/a512873/Documents/Apps/kSar-5.0.6/"
#server1=eng300
#server2=eng301
base="/drives/c/Temp"
odir=${base}/${dir}
idir="c:/temp/${dir}"
 
file1="${odir}/${server1}.txt"
file2="${odir}/${server2}.txt"

ifile1="${idir}/${server1}.txt"
ifile2="${idir}/${server2}.txt"

 
mkdir -p $odir
rm -rf ${odir}/*

echo "- ssh get sar data" 
for i in `seq $sa $ea`;do
  echo $i
  if [ $i -lt 10 ]; then
    i="0$i"
  fi
  if [ "$i" != "$ea" ]; then
    et1="23:59"
  else
    et1="$et"
  fi

  if [ "$i" != "$sa" ]; then
    st1="00:00"
  else
    st1="$st"

  fi

  echo ssh a512873@${server1} sar -uqrRWB -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59 file: $file1
#  ssh a512873@${server1} "sar -A -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" >> ${file1} 2> /dev/null
  ssh a512873@${server1} "sar -A" >> ${file1} 2> /dev/null
  echo ssh a512873@${server2} sar -uqrRWB -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59 file: $file2 
#ssh a512873@${server2} "sar -uqrRWB -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" >> ${file2} 2> /dev/null
  ssh a512873@${server2} "sar -A " >> ${file2} 2> /dev/null
done

echo "- Calling ksar" 
cd "$KSAR"
java -jar ./ksar.jar -input file://${ifile1} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 300 -outputPNG ${idir}/${server1} && rm $file1
java -jar ./ksar.jar  -input file://${ifile2} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 300 -outputPNG  ${idir}/${server2}&& rm $file2

echo "- Adding label"
cd ${odir}
pwd

for i in $(ls -ltr| awk '{print $NF}'| grep "_" | cut -d"_" -f2|sort |uniq); do
  echo file: $i
  convert.exe ${server1}_${i} ${server2}_${i} -append $i
  rm ${server1}_${i} ${server2}_${i}
done

for i in *.png; do 
 eval `echo "~/apps/ImageMagick-6.8.7-8/convert.exe ${idir}/$i   -background YellowGreen   label:'${label}'   +swap -gravity Center -append _${i}"`
 rm -rf $i
 mv _${i} ${dir}_${i}
done

cd $old_pwd
echo Done
