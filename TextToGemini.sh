#Get file name from first argumnet
FILE="$1";
DIR="$2";
mkdir $DIR
#Get numver of total lines
a=($(wc -l $FILE))
declare -i LINES=${a[0]}
declare -i CURRENT_LINE=0
#Test print
#Logic loop
declare -i GETLINES=0;
declare -i PAGENUMBER=0;
declare -i NEXTPAGE=0;
declare -i PREVIOUSPAGE=0;
#Create Index Page:
echo  >> $DIR"/0_Page.gmi"
echo -e "\n=> 1_Page.gmi Next page" >> $DIR/$PAGENUMBER"_Page.gmi"
#Creat remaining pages
while [ $LINES -gt $CURRENT_LINE ]
do
	declare -i STARTLINE=`expr $LINES-$CURRENT_LINE`
	STRING=$(tail -n $STARTLINE $FILE | head -n $GETLINES)
	declare -i WORDS=$(echo "$STRING" | wc -w)
	if [ $WORDS -lt 250 ]
	then
		GETLINES=($GETLINES+1)	
		if [ `expr $CURRENT_LINE + $GETLINES` -gt $LINES ]
		then
			#WRITE TO FILE:
			PAGENUMBER=`expr $PAGENUMBER+1`
			NEXTPAGE=`expr $PAGENUMBER+1` 
			PREVIOUSPAGE=`expr $PAGENUMBER-1`
			#Page Number:
			echo -e "\n##Page $PAGENUMBER \n" >> $DIR/$PAGENUMBER"_Page.gmi"
			echo "$STRING" >> $DIR/$PAGENUMBER"_Page.gmi"
			#Add navigation links:
			echo -e "=>\n${PREVIOUSPAGE}_Page.gmi Previous page" >> $DIR/$PAGENUMBER"_Page.gmi"
			break;
		fi
		GETLINES=`expr $GETLINES+1`;
	else
		CURRENT_LINE=($CURRENT_LINE+$GETLINES)
		GETLINES=1;

		#WRITE TO FILE:
		PAGENUMBER=`expr $PAGENUMBER+1`
		NEXTPAGE=`expr $PAGENUMBER+1` 
		PREVIOUSPAGE=`expr $PAGENUMBER-1`
		#Page Number:
		echo -e "\n##Page $PAGENUMBER \n" >> $DIR/$PAGENUMBER"_Page.gmi"
		echo "$STRING" >> $DIR/$PAGENUMBER"_Page.gmi"
		#Add navigation links:
		echo -e "\n=> ${NEXTPAGE}_Page.gmi Next page" >> $DIR/$PAGENUMBER"_Page.gmi"
		echo -e "=> ${PREVIOUSPAGE}_Page.gmi Previous page" >> $DIR/$PAGENUMBER"_Page.gmi"
	fi
done
