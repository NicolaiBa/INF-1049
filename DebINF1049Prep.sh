#!/usr/bin/env bash
# Written by Nicolai Bakkeli for the course INF-1049
#
#                       #################################
#                       #       READ BEFORE USE         #
#                       #         LES FØR BRUK          #
#                       #################################
#
################
#   English:   #
################            #####################
#                           #    Description    #
#                           #####################
#
#       This is a script used to help install necessary software for INF-1049.
#       It is primarily designed to be used on debian-based linux machines.
#       Find other ways to install the required software if you use another OS.
#       Responsibility for use of this script is on you.
#       Google the entries in the list below called "InstallList" for instructions on how
#       to install the packages if script doesn't help you out.
#
#
#                           #####################
#                           #    How to run     #
#                           #####################
#
#       Run these lines (without the quotes) in your terminal with this files folder
#       as current working directory:
#
#           "chmod 755 ProgramPrep.sh"
#           "sudo bash ProgramPrep.sh"
#
#
#
#############
#   Norsk:  #
#############               #####################
#                           #    Beskrivelse    #
#                           #####################
#
#       Dette er et skript som er ment hjelpe for å installere programvare nødvendig for 
#       kurset "Introduksjon til beregningsorientert programmering" (INF-1049)
#       Skriptet er designet for bruk på Debian baserte linux maskiner.
#       Unngå å kjøre skriptet på andre operativsystem.
#       Alt ansvar for bruk av skriptet skjer på egen kappe.
#       Skulle skriptet feile kan du ta google til bruk.
#       Da vil det være nyttig å søke opp søkeordene som er listet opp i 
#       "InstallList" som er ført opp nedenfor.
#       
#
#
#                           #####################
#                           #   Bruksanvisning  #
#                           #####################
#
#       Kjør disse linjene (uten anførselstegn) i et terminalvindu hvor fokuset er på
#       en mappe som inneholder dette skriptet:
#
#           "chmod 755 ProgramPrep.sh"
#           "sudo bash ProgramPrep.sh"
#
#

# List of sortware to install
InstallList=(
    "python3 3.5.0"
    "pip3 9.0.1"
    "easy_install3 20.7.0"
    "yolk 0.9"
    "matplotlib 2.0.2"
    "numpy 1.13.0rc2"
    "ipython 6.1.0"
    "scitools 0.8"
    "cython 0.25.2"
    "nose 1.3.7"
    "sympy 1.0"
)

digitsCompare () {
    # Compares version numbers from version strings.
    # $1 current installed version, $2 desired installed version.
    # CurNum - The current version number.
    # DesNum - The desired version number.
    
    CurNum=$(echo $(echo $1| cut -d'.' -f $3) | tr -dc '0-9')
    DesNum=$(echo $(echo $2| cut -d'.' -f $3) | tr -dc '0-9')
    if [ $CurNum -lt $DesNum ]
    then
        echo 1
    else
        echo 0
    fi
}

versionControl () {
    #

    currentver=""
    # Finds version number of target software
    case $1 in
        "python3"|"pip3"|"easy_install3"|"yolk")
        currentver="$(echo $($1 --version) | cut -d' ' -f 2)";;
        "matplotlib"|"numpy"|"ipython"|"scitools"|"cython"|"nose"|"sympy")
        currentver="$(echo $(yolk -V $1) | cut -d' ' -f 2)";;
        *) echo "Program not accounted for"
    esac

    # Finds number of sequence identifiers
    sequences=$(echo $currentver | tr -cd '.' | wc -c)
    sequences=$((sequences+1))
    COUNTER=1
    Upgraded=0


    while [ $COUNTER -le $sequences ]; do
    # Iterates software version sequence-bases etc. (software -v x.y.z).

        # Calles the comparison between current and desired version.
        doUpgrade=$( digitsCompare $currentver $2 $COUNTER )
        if [ "$doUpgrade" == "1" ]
        then
            # An upgrade is required
            Upgraded=$((1))

            # Tries to upgrade old or install non-existing software
            echo "$1: unacceptable version, initiates update"
            case $1 in
                "python3") sudo apt-get install python3;;
                "pip3") sudo apt-get install python3-pip
                        sudo apt-get install python3-setuptools
                        sudo easy_install3 pip;;
                "easy_install3") sudo apt-get install python3-setuptools;;
                "yolk") sudo pip install yolk
                        sudo pip install --upgrade yolk3k;;
                "matplotlib") sudo apt-get install python3-matplotlib;;
                "numpy") sudo apt-get install python3-numpy;;
                "ipython") sudo apt-get install python3-ipython;;
                "scitools") sudo apt-get install python3-scitools;;
                "cython") sudo apt-get install python3-cython
                          sudo pip install Cython;;
                "nose") sudo easy_install nose;;
                "sympy") sudo pip3 install sympy;;
                *) echo "Installation command not pressent";;
            esac

            # Reports new version string.
            case $1 in
                "python3"|"pip3"|"easy_install3"|"yolk")
                currentver="$(echo $($1 --version) | cut -d' ' -f 2)";;
                "matplotlib"|"numpy"|"ipython"|"scitools"|"cython")
                currentver="$(echo $(yolk -V $1) | cut -d' ' -f 2)";;
                *) echo "Program not accounted for"
            esac
            echo "New version: $currentver"
            #sudo apt-get update
        fi
        COUNTER=$((COUNTER+1))
    done

    # Reports acceptable finds.
    if [ "$Upgraded" == "0" ]
    then
        if [ $(echo -n $1 | wc -c) -gt 6 ]
        then
            printf "$1:\tacceptable version: $2\n"
        else
            printf "$1:\t\tacceptable version: $2\n"
        fi
    fi
}

count=0
# Goes through list of software to install
while [ "x${InstallList[count]}" != "x" ]
do
    versionControl ${InstallList[count]}
    count=$(( $count + 1 ))
done
