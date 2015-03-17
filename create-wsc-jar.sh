#!/bin/bash
# ------------------------------------------------------------------
# RJ Palombo
# This script will download necessary dependencies, create your salesforce wsc jar and create a WSC directory containing all files.
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=create-wsc-jar
WSCVERSION=32.0.0
USAGE="Usage: ./create-wsc-jar.sh -w partner.wsdl"

echo;
echo "##########################################################################";
echo "#   WARNING - this script requires a mac computer with JDK 6 installed   #";
echo "##########################################################################";
echo;

JAVA_HOME=$(/usr/libexec/java_home -v 1.6)

# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi
WSDL=""
while getopts ":w:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "w")
        echo "-w argument: $OPTARG"
        WSDL=$OPTARG
        ;;
      "h")
        echo $USAGE
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

# --- Body --------------------------------------------------------
#  SCRIPT LOGIC GOES HERE
echo Using WSDL: $WSDL;
echo creating directory WSC;

mkdir WSC;
cd WSC;

curl http://central.maven.org/maven2/com/force/api/force-wsc/$WSCVERSION/force-wsc-$WSCVERSION.jar -o force-wsc-$WSCVERSION.jar;
curl http://central.maven.org/maven2/rhino/js/1.7R2/js-1.7R2.jar -o js-1.7R2.jar;
curl http://central.maven.org/maven2/org/antlr/ST4/4.0.7/ST4-4.0.7.jar -o ST4-4.0.7.jar;
curl http://central.maven.org/maven2/org/antlr/antlr-runtime/3.5/antlr-runtime-3.5.jar -o antlr-runtime-3.5.jar;

CMD="$JAVA_HOME/bin/java -classpath force-wsc-$WSCVERSION.jar:js-1.7R2.jar:ST4-4.0.7.jar:antlr-runtime-3.5.jar com.sforce.ws.tools.wsdlc ../$WSDL ./$WSDL.jar;"
echo "Running command: " $CMD;
eval $CMD;

echo "Created $WSDL.jar"

exit;
# -----------------------------------------------------------------