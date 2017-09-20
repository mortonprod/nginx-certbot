#!/usr/bin/env bash
#Names given in docker file
CERTBOTSTRING="sleep 6 && certbot certonly  --standalone -d DOMAIN --text --agree-tos --email EMAIL --server https://acme-v01.api.letsencrypt.org/directory --rsa-key-size 4096 --verbose --renew-by-default --standalone-supported-challenges http-01"
NETWORK="#INSERTNGINXNETWORK"
DOCKERNETWORK="#INSERTDOCKERNETWORK"
CERTBOT="#INSERTCERT"
#Get inputs and test them.
while getopts i:o:n:e: option
do
 case "${option}"
 in
 i) INPUTFILE=${OPTARG};;
 o) OUTPUTFILE=${OPTARG};;
 n) NETWORKSTRING=$OPTARG;;
 e) EMAIL=$OPTARG;;
 esac
done
error=false;
if [ -z $INPUTFILE ];
then
    echo "Need an input file"
    error=true
else
    echo "Input file: " $INPUTFILE
fi
if [ -z $OUTPUTFILE ];
then
    echo "Need an output file"
    error=true
else
    echo "Output file: " $OUTPUTFILE
fi

if [ -z "$NETWORKSTRING" ];
then
    echo "Need an network string"
    error=true
else
    echo "Network String: " $NETWORKSTRING
fi
if [ -z "$EMAIL" ];
then
    echo "Need an email string"
    error=true
else
    echo "Email String: " $EMAIL
fi
if $error;
then
  echo "Do it like this: bash createDockerCompose.sh -i docker-compose-default.yml  -o docker-compose-test.yml -n "one:domain1.co.uk two:domain2.co.uk" -e test@gmail.com "
  exit 2
fi

#Copy over default file to new outputed file.
if [ -f $OUTPUTFILE ]
then
  rm $OUTPUTFILE
fi
cp $INPUTFILE $OUTPUTFILE



#Add networks to docker file general network. 
for EL in $NETWORKSTRING
do
 IFS=: read -r var1 var2 <<< "$EL";
 var1=`echo " "$var1`
 echo $var1
 sed -i  "/$DOCKERNETWORK/ a \ \ \ \ \ \ name:$var1" $OUTPUTFILE
 sed -i  "/$DOCKERNETWORK/ a \ \ \ \ external:" $OUTPUTFILE
 sed -i  "/$DOCKERNETWORK/ a \ \ $var1:" $OUTPUTFILE
done


#Add networks to docker file nginx networks. 
for EL in $NETWORKSTRING
do
 IFS=: read -r var1 var2 <<< "$EL"
 sed -i  "/$NETWORK/ a \ \ \ \ \ \ - $var1" $OUTPUTFILE
done
sed -i "/$NETWORK/ a \ \ \ \ networks:" $OUTPUTFILE


#Add networks to docker file nginx networks. 
CERTSTRING=()
for EL in $NETWORKSTRING
do
 IFS=: read -r var1 var2  <<< "$EL"
 CERTSTRING+=$(echo $CERTBOTSTRING | sed "s/EMAIL/$EMAIL/" | sed "s/DOMAIN/$var2/") 
 CERTSTRING+=$(echo " && ")
done
sed -i  "/$CERTBOT/ a \ \ \ \ command: bash -c '$CERTSTRING'" $OUTPUTFILE


