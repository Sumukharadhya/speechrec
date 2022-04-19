#!/bin/sh

#########################################
#		USAGE			#
#	./sortD first_word.txt		#
# $1 is a argument that has to called	#
# while running the script.		#
#########################################

#Separating the two columns into single files.
diffRen(){
	cat res/all.tsv | head -n17835 | awk '{print $1;}' > first_word.txt #Prints only the first column into a text file
#	cat res/all.tsv | head -n17835 | awk '{$1=""; print $0}' > second_rest.txt #Prints only the second column into a text file
}

#Separating English and Devanagari.
awkkDE(){
	awk -F"[अ-ह]*" '{print $1}' $1 > onlyE_fw.txt && #Printing only English to a separate text file
	awk -F"[A-z!@#$%^&*(){}<>,.=+-_:/–…°×πωº0-9]*" '{print $1,$2}' $1 > onlyD_fw.txt #Printing only Devanagari to a separate text file
}

#Sort and Unique using awk.
uniqawK(){
	awk '!a[$0]++' onlyE_fw.txt onlyD_fw.txt > EDuniqK.txt #Getting a combined output from sorting and unique of both only English and Devanagari text files using awk
}

#Sort and Unique.
uniqSU() {
	sort onlyE_fw.txt onlyD_fw.txt | uniq > ENuniqSU.txt #Getting a combined output from sorting and unique of both only English and Devanagari text files
}

#Phonic.
phonic(){
	cat res/temp.txt | perl -CSD -Mutf8 -pe 's/(?<=[अ-ह\p{M}])(?=[^अ-ह\p{M}])|(?<=[^अ-ह\p{M}])(?=[अ-ह])/ /g' > phonic.txt #Using Perl with a regex expression to leave space for before and after of Devanagari text
#p{M} ->char other than devanagari give space.	
}

#Combining all the text files in a CSV file.
fpaste(){
	paste first_word.txt res/second_rest.txt onlyE_fw.txt onlyD_fw.txt ENuniqSU.txt phonic.txt > all.csv #Pasting the single files together to get one CSV file
}

printf "separate files exists? (Y/n): " && read yorno
if [ "$yorno" = n ] ; then #If loop in case there are different files or if they are not, by default it sees that there exists different files.
	diffRen && #This function is called only if there no separate files of two main columns.
	awkkDE $1 && #This function is called to separating English and Devanagari.
#	uniqawK $1 && #This function is called to sort and unique using awk.
	uniqSU $1 && #This function is called to Sort and unique.
	phonic $1 && #This function is called to get phonic.
	fpaste #And finally this function helps in get a single CSV file with all columns.
else
	awkkDE $1 && #This function is called to separating English and Devanagari.
#	uniqawK $1 && #This function is called to sort and unique using awk.
	uniqSU $1 && #This function is called to Sort and unique.
	phonic $1 && #This function is called to get phonic.
	fpaste #And finally this function helps in get a single CSV file with all columns.
fi

exit 0

#This script only helps in separating the columns, English, Devanagari. There requires a manual edit to detect the English words with are in Hindi and needs to be changed. So that sort, unique and phonic are as expected.
