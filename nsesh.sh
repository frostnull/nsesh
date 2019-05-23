#!/bin/bash

function banner {
    cat << EOF
    
    author: fr0stNuLL
    version: v01

███╗   ██╗███████╗███████╗███████╗██╗  ██╗
████╗  ██║██╔════╝██╔════╝██╔════╝██║  ██║
██╔██╗ ██║███████╗█████╗  ███████╗███████║
██║╚██╗██║╚════██║██╔══╝  ╚════██║██╔══██║
██║ ╚████║███████║███████╗███████║██║  ██║
╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
                                          
usage: ./nsesh -d example.com
usage2: ./nsesh --domain example.com
usage4: ./nsesh --d 127.0.0.1


EOF
}


DEFAULTCOLOR="\033[0m"
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
WHITE="\033[1;37m"
MAGENTA="\033[1;35m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NMAP=$(whereis nmap | awk '{print $2}')


if [ "$1" == "-h" -o "$1" == "--help" -o -z "$1" ]; then 
    banner
    exit
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--domain)
    DOMAIN="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi


function dependencies {
    EXIT=0
    if ! [[ ${NMAP: -9} =~ "nmap" ]] ; then
        echo -e "\n$RED [!] Dependecies error, you need to install$YELLOW nmap$RED package $DEFAULTCOLOR\n"
        EXIT=1
    fi    
}

function dns-brute {
    echo -e "$GREEN[*] Starting DNS BRUTE SCRIPT $WHITE\n"
    nmap -p 80,443 --script dns-brute.nse -v $DOMAIN
    echo -e "$GREEN[*] Finished DNS BRUTE SCRIPT $WHITE\n"
}

function https-enums {
    echo -e "$GREEN[*] Starting HTTP-ENUM SCRIPT $WHITE\n"
    nmap --script http-enum -v $DOMAIN
    echo -e "$GREEN[*] Finished HTTP-ENUM SCRIPT $WHITE\n"
}

function banner-plus {
    echo -e "$GREEN[*] Starting BANNER-PLUS SCRIPT $WHITE\n"
    nmap $DOMAIN --script=banner-plus -v
    echo -e "$GREEN[*] Finished BANNER-PLUS SCRIPT $WHITE\n"
}

function vuln-scan-vulners {
    echo -e "$GREEN[*] Starting VULNERS SCRIPT $WHITE\n"
    nmap -sV --script=vulscan/vulscan.nse -v $DOMAIN
    echo -e "$GREEN[*] Finished VULNERS SCRIPT $WHITE\n"
}

function main {
    banner
    dns-brute
    https-enums
    banner-plus
    vuln-scan-vulners
}


#------#
# main #
#------#

dependencies
#echo DOMAIN  = "${DOMAIN}"
#echo DEFAULT  = "${DEFAULT}"

echo -e "\n[*] Starting scan at $GREEN $DOMAIN $WHITE \n\n"
main