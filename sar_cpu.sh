#!/bin/bash
file=$1

cat $file | sed -n /sys/,/Aver/p | sed -e '/sys/d' -e '/^$/d' -e '/Aver/d' > cpu.out

