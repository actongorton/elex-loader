#!/bin/bash
if [[ ! -z $1 ]] ; then
    RACEDATE=$1
fi

if [[ -z $RACEDATE ]] ; then
    echo 'Provide a race date, such as 2016-02-01'
    exit 1
fi

if [[ -z "$AP_API_KEY" ]] ; then
    echo "Missing environmental variable AP_API_KEY. Try 'export AP_API_KEY=MY_API_KEY_GOES_HERE'."
    exit 1
fi

date "+STARTED: %H:%M:%S"
echo "------------------------------"

function drop_table { 
    cat node_modules/fields/results.txt | psql elex_$RACEDATE 
}

function get_results {
    elex results $RACEDATE -t > results.csv
}

function load_results {
    cat results.csv | psql elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function replace_views {
    cat node_modules/fields/elex_races.txt | psql elex_$RACEDATE
    cat node_modules/fields/elex_candidates.txt | psql elex_$RACEDATE
    cat node_modules/fields/elex_results.txt | psql elex_$RACEDATE
}

if get_results; then
    drop_table
    load_results
    replace_views
    rm -rf results.csv
else
    echo "ERROR: Bad response from AP. No results loaded."
    rm -rf results.csv
fi

echo "------------------------------"
date "+ENDED: %H:%M:%S"