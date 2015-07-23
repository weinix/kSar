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
KSAR="C:/Users/a512873/Documents/Apps/kSar-5.0.6/kSar.jar"
base="/drives/c/Temp/c2c"
odir="/drives/c/Temp/c2c"

mkdir -p $odir ${odir}/${server}
idir="c:/temp/c2c"
 
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
  echo  ssh -i ~/.ssh/c2cvm.priv.new root@${server} "LANG=C sar -A -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" to ${file} 
  ssh -i ~/.ssh/c2cvm.priv.new root@${server} "LANG=C sar -A -f /var/log/sa/sa${i} -s ${st1}:00 -e ${et1}:59" >> ${file} 2> /dev/null
  
done

echo "- Calling ksar" 

#java -jar $KSAR -input file://${ifile} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 400 -outputJPG ${idir}/${server}/${server}
#echo "Output files: ${idir}\\${server}"
java -jar ksar.jar -input file://${ifile} -showCPUstacked -showMEMstacked -cpuFixedAxis -height 400
 


echo Done
