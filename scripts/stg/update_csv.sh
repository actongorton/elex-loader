#!/bin/bash
. /home/ubuntu/elex-loader/scripts/stg/_pre.sh
. /home/ubuntu/elex-loader/scripts/stg/_results.sh
. /etc/environment

if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $AP_API_BASE_URL ]] ; then
    AP_API_BASE_URL="http://api.ap.org/v2/"
fi

echo "----------- UPDATE CSV -----------"

TIMESTAMP=$(date +"%s")

pre
# set_temp_tables

echo "0" > /tmp/elex_error.txt

echo $AP_API_BASE_URL"/elections/$RACEDATE?apiKey=$AP_NAT_KEY&format=json&level=ru"

results_csv & PIDRESULTS=$!
wait $PIDRESULTS

while read p; do
    if [ $p == "0" ] ; then
        # copy_results
        # views

        echo "Results time elapsed:" $SECONDS"s"

        echo "Total time elapsed (A):" $SECONDS"s"
    fi
done </tmp/elex_error.txt

echo "0" > /tmp/elex_error.txt
