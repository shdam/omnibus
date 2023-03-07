#!/bin/bash
#
# Template for setting up a full benchmark
# Author: Søren Helweg Dam


usage(){
    echo ""
    echo "Usage: bash ""$(basename "$0")"" -o -p -c CONFIGFILE"
    echo ""
    echo "Params"
    echo " -c   	config file"
    echo " -p   	Create parameters project"
    echo " -o   	Create Orchestrator"
    echo " -t		Personal Access Token with API permissions (overwrites the config token, if one was given there)"
    echo " -r		Name of single repository to create"
    echo " -k		Name of keyword for single repository"
    echo " -tp		Name of template to use for single repository"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        -c)           			shift
                               	CONFIG="$1"
                               	;;
        -o) ORCHESTRATOR=true
                               	;;
        -p) PARAMETERS=true
                              	;;
        -op) ORCHESTRATOR=true
			 PARAMETERS=true
                              	;;
		-t)           			shift
                               	TOKEN="$1"
                               	;;
		-r)           			shift
                               	REPO="$1"
                               	;;
		-k)           			shift
                               	KEY="$1"
                               	;;
		-tp)           			shift
                               	TEMP="$1"
                               	;;
        -h | --help )          	usage
                               	exit
                               	;;
        * )                    	usage
                               	exit 1
    esac
    shift
done

# Load configuration settings
source $CONFIG

# Overwrite config vars for those given as input
token=${TOKEN:-token}
REPONAMES=(${REPO:-${REPONAMES[@]}})
PTITLES=(${REPO:-${REPONAMES[@]}})
KEYWORDS=(${KEY:-${KEYWORDS[@]}})
TEMPLATES=(${TEMP:-${TEMPLATES[@]}})

# Error checks

if [ "${#REPONAMES[@]}" -ne "${#TEMPLATES[@]}" ] || [ "${#TEMPLATES[@]}" -ne "${#KEYWORDS[@]}" ] || [ "${#KEYWORDS[@]}" -ne "${#PTITLES[@]}" ]; then
	echo "Please make sure all lists have the same lengths."
	echo "KEYWORDS: ${KEYWORDS[@]}"
	echo "REPONAMES: ${REPONAMES[@]}"
	echo "TEMPLATES: ${TEMPLATES[@]}"
	echo "PTITLES: ${PTITLES[@]}"
	exit 1
fi


# Build Orchestrator

if [ $ORCHESTRATOR ]; then
	omnicast \
		-r "orchestrator" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "orchestrator" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_dev" \
		-k "orchestrator" \
		-pt "orchestrator"
fi

# Build Parameters

if [ $PARAMETERS ]; then
	omnicast \
		-r "parameters" \
		-bm "${BENCHMARK}" \
		-d "${DIR}" \
		-ns "${NAMESPACE_ID}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "omni-param-py" \
		-ts "${TEMSOURCE}" \
		-tb "CLI_main" \
		-k "parameters" \
		-pt "parameters"
fi

# Build manually defined projects

for (( i = 0; i <${#REPONAMES[@]}; i++ )); do
	omnicast \
		-r "${REPONAMES[$i]}" \
		-bm "${BENCHMARK}" \
		-ns "${NAMESPACE_ID}" \
		-d "${DIR}" \
		-gu "${GLUSERNAME}" \
		-ge "${USEREMAIL}" \
		-v "${VISIBILITY}" \
		-g "${GROUPNAME}" \
		-t "${token}" \
		-ti "${TEMPLATES[$i]}" \
		-ts "${TEMSOURCE}" \
		-tb "${TEMREF}" \
		-k "${KEYWORDS[$i]}" \
		-pt "${PTITLES[$i]}"
done
