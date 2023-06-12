#!/bin/bash
#set -x 
# check te difference between published artifacts in 2 branches/situations  generated by the toolchain 

echo " arg1 = the directory containing the branch 1"
echo " arg2 = the directory containing the branch 2"

PRODUCTION=$1
TEST=$2
DETAIL=$3
DETAIL=${DETAIL:-"global"}


if [ $DETAIL == "global" ] ; then
echo "global compare "
 diff -r -q -x .git -x .gitkeep $PRODUCTION $TEST

fi

if [ $DETAIL == "rdf" ] ; then
echo "compare RDF"

PRODUCTIONFILES=`find $PRODUCTION/ns/*.ttl -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   diff $PRODUCTION/ns/$i $TEST/ns/$i
done

fi

if [ $DETAIL == "nt" ] ; then
echo "compare RDF-ntriples"

PRODUCTIONFILES=`find $PRODUCTION/ns/*.nt -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   sort $PRODUCTION/ns/$i > /tmp/prod.nt
   sort $TEST/ns/$i > /tmp/test.nt
   diff /tmp/prod.nt /tmp/test.nt
done

fi

if [ $DETAIL == "ntblank" ] ; then
echo "compare RDF-ntriples"

PRODUCTIONFILES=`find $PRODUCTION/ns/*.nt -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   cp $PRODUCTION/ns/$i /tmp/prod.nt
   sed -i -e "s/_:.[[:digit:]]* /_:BLANK /g" /tmp/prod.nt
   sort /tmp/prod.nt > /tmp/prod1.nt
   cp $TEST/ns/$i /tmp/test.nt
   sed -i -e "s/_:.[[:digit:]]* /_:BLANK /g" /tmp/test.nt
   sort /tmp/test.nt > /tmp/test1.nt
   diff /tmp/prod1.nt /tmp/test1.nt
done

fi


if [ $DETAIL == "context" ] ; then
echo "compare context"

PRODUCTIONFILES=`find $PRODUCTION/context/*.jsonld -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   if [ -f "$PRODUCTION/context/$i" ] && [ -f "$TEST/context/$i" ]  ; then
   jq -S . $PRODUCTION/context/$i > /tmp/$i.prod.jsonld
   jq -S . $TEST/context/$i > /tmp/$i.test.jsonld
   diff /tmp/$i.prod.jsonld /tmp/$i.test.jsonld
   else 
	   echo "one of the files $i does not exist"
   fi
done

fi

if [ $DETAIL == "shaclnt" ] ; then
echo "compare shacl"

PRODUCTIONFILES=`find $PRODUCTION/shacl/*.ttl -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   if [ -e $TEST/shacl/$i ] ; then
   rapper -i turtle $PRODUCTION/shacl/$i > /tmp/$i.prod.nt
   rapper -i turtle $TEST/shacl/$i > /tmp/$i.test.nt
   sed -i "s/_:genid[0-9]* /_:genidxxx /" /tmp/$i.prod.nt
   sed -i "s/_:genid[0-9]* /_:genidxxx /" /tmp/$i.test.nt
   sort /tmp/$i.prod.nt > /tmp/$i.prod.sorted
   sort /tmp/$i.test.nt > /tmp/$i.test.sorted
   diff /tmp/$i.prod.sorted /tmp/$i.test.sorted
   fi
done

fi

if [ $DETAIL == "ap" ] ; then
echo "compare applicationprofiles"

PRODUCTIONFILES=`find $PRODUCTION/doc/applicatieprofiel/ -type d -printf "%f " `
PRODUCTIONFILES=`ls -1 $PRODUCTION/doc/applicatieprofiel`
echo $PRODUCTIONFILES

for i in $PRODUCTIONFILES ; do 
   echo $i
   if [ -d "$PRODUCTION/doc/applicatieprofiel/$i" ] && [ -d "$TEST/doc/applicatieprofiel/$i" ]  ; then
   	diff $4 $PRODUCTION/doc/applicatieprofiel/$i $TEST/doc/applicatieprofiel/$i
   else 
	   echo "one of the files $i does not exist"
   fi
done

fi


if [ $DETAIL == "voc" ] ; then
echo "compare vocabularies"

PRODUCTIONFILES=`find $PRODUCTION/ns -type d -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   diff $PRODUCTION/ns/$i $TEST/ns/$i
done

fi


if [ $DETAIL == "aps" ] ; then
echo "compare applicationprofiles"

PRODUCTIONFILES=`find $PRODUCTION/doc/applicatieprofiel/ -type d -printf "%f " `
for i in $PRODUCTIONFILES ; do 
   echo $i
   lines=`diff -c 0 -w $PRODUCTION/doc/applicatieprofiel/$i $TEST/doc/applicatieprofiel/$i |wc -l`
   echo "  has differences: " $lines
done

fi