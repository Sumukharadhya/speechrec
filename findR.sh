#!/bin/bash

while read p q
do
	echo "P is: " $p
	echo "Q is: " $q
	sed -i "s/\<$p\>/$q/g" $2
done < $1
