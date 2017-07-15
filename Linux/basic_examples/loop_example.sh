#!/bin/sh
#	Find how many lines we have in our
m=$(wc -l "tmp.txt" | cut -c 1-2)

echo "Loop"
for i in $(seq 0 ${m})
do
	archDate=$(echo "${fList[$i]}" | cut -c 31-40)
	echo "Timestamp"
#	echo ${archDate}
	good=$(date "--date=+ -${n} day" +%m-%d-%Y)
	echo ${good}
done

