#!/bin/bash
# by wei wang
# V1.1
# History
# V1.1 Multi day support
# know issue: can't support end smaller than start day
 
if [ $# -ne 5 ]; then
  echo Usage: $0 [server] [start_day] [start time] [end_day] [end time] 
  echo "Output base: /drives/c/Temp/${odir}"
  echo "Sample usage: ./psar.sh eilabr7204 06 10:48 07 11:55" 
  exit 1
fi

server=$1
sa=$2
st=$3
ea=$4
et=$5
 
KSAR="~/Apps/kSar-5.0.6/kSar.jar"
base="/drives/c/Temp"
odir="/drives/c/Temp"
idir="c:/temp"
 
file="${odir}/${server}.txt"

ifile="${idir}/${server}.txt"

rm -f $file 

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
  echo  ${server} "LANG=C sar -A -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" to ${file} 
  ssh ${server} "sar -A -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" >> ${file} 2> /dev/null
  
done

echo "- Calling ksar" 

#echo java -jar ksar.jar -input file://${ifile1} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 400 -outputJPG ${idir}/${server1}
java -jar ksar.jar -input file://${ifile} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 400
 

rm $file

echo Done
