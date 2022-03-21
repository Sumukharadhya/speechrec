#!/bin/sh

diffRen(){
	cat res/all.tsv | head -n17835 | awk '{print $1;}' > first_word.txt
#	cat res/all.tsv | head -n17835 | awk '{$1=""; print $0}' > second_rest.txt
}

awkkDE(){
	awk -F"[अ-ह]*" '{print $1}' $1 > onlyE_fw.txt &&
	awk -F"[A-z!@#$%^&*(){}<>,.=+-_:/–…°×πωº0-9]*" '{print $1,$2}' $1 > onlyD_fw.txt
}

uniqawK(){
	awk '!a[$0]++' onlyE_fw.txt onlyD_fw.txt > EDuniqK.txt
}

uniqSU() {
	sort onlyE_fw.txt onlyD_fw.txt | uniq > ENuniqSU.txt
}

phonic(){
	cat $1 | perl -CSD -Mutf8 -pe 's/(?<=[अ-ह\p{M}])(?=[^अ-ह\p{M}])|(?<=[^अ-ह\p{M}])(?=[अ-ह])/ /g' > phonic.txt
#	cat $1 | sed 's/[अ-ह].*/ &/g' > phonic.txt
}

fpaste(){
	paste first_word.txt res/second_rest.txt onlyE_fw.txt onlyD_fw.txt ENuniqSU.txt phonic.txt > all.csv
}

printf "separate files exists? (Y/n): " && read yorno
if [ "$yorno" = n ] ; then
	diffRen &&
	awkkDE $1 &&
#	uniqawK $1 &&
	uniqSU $1 &&
	phonic $1 &&
	fpaste
else
	awkkDE $1 &&
#	uniqawK $1 &&
	uniqSU $1 &&
	phonic $1 &&
	fpaste
fi

exit 0
