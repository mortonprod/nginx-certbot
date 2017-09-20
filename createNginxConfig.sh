#!/usr/bin/env bash
INSERTHERE="#INSERTHERE"
INPUTFILEUNSECURE=./configs/nginx.conf
INPUTFILESECURE=./configs/nginx-secure.conf
OUTPUTFILEUNSECURE=./nginx-image/nginx-test.conf
OUTPUTFILESECURE=./nginx-image/nginx-secure-test.conf
#UNSERVER="./configs/nonSecureServer.txt"
UNSERVERSTRING=$(<./configs/nonSecureServer.txt)
SERVERSTRING=$(<./configs/secureServer.txt)
#Get domain,network,port
while getopts i: option
do
 case "${option}"
 in
 i) DOMAINSNETWORKSPORTS=${OPTARG};;
 esac
done

if [ -z "$DOMAINSNETWORKSPORTS" ];
then
    echo "Need an domain and port string"
    error=true
else
    echo "Domain and port string: " $DOMAINSNETWORKSPORTS
fi

rm $OUTPUTFILEUNSECURE
rm $OUTPUTFILESECURE
FULLSERVERSTRING=()
for EL in $DOMAINSNETWORKSPORTS
do
 echo $EL
 IFS=: read -r var1 var2 var3 <<< "$EL"
 echo $var1 $var2 $var3
 FULLSERVERSTRING+=$(echo "$UNSERVERSTRING" | sed "s/DOMAIN/$var1/" | sed "s/NETWORK/$var2/" | sed "s/PORT/$var3/") 
 echo "part: " $FULLSERVERSTRING 
done
echo "Output"
echo $FULLSERVERSTRING
while read -r line
do
 echo " " $line
 if [[ $line == *$INSERTHERE* ]]; then
        for i in "$FULLSERVERSTRING"
         do
            echo "$i"
         done
 fi
done < $INPUTFILEUNSECURE >  $OUTPUTFILEUNSECURE
sed -i "s/$INSERTHERE//" $OUTPUTFILEUNSECURE



#Now the secure file
FULLSERVERSTRING=()
for EL in $DOMAINSNETWORKSPORTS
do
 echo $EL
 IFS=: read -r var1 var2 var3 <<< "$EL"
 echo $var1 $var2 $var3
 FULLSERVERSTRING+=$(echo "$SERVERSTRING" | sed "s/DOMAIN/$var1/" | sed "s/NETWORK/$var2/" | sed "s/PORT/$var3/") 
 echo "part: " $FULLSERVERSTRING 
done
echo "Output"
echo $FULLSERVERSTRING
while read -r line
do
 echo " " $line
 if [[ $line == *$INSERTHERE* ]]; then
        for i in "$FULLSERVERSTRING"
         do
            echo "$i"
         done
 fi
done < $INPUTFILESECURE >  $OUTPUTFILESECURE
sed -i "s/$INSERTHERE//" $OUTPUTFILESECURE






