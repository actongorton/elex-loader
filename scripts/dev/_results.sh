function get_results {
    curl -o /tmp/results_$RACEDATE.json "http://api.ap.org/v2/elections/$RACEDATE?apiKey=$AP_API_KEY&format=json&level=ru&test=true&setzerocounts=true"
}

function load_results {
    cat fields/results.txt | psql elex_$RACEDATE 
    elex results $RACEDATE -t -d /tmp/results_$RACEDATE.json | psql elex_$RACEDATE -c "COPY results FROM stdin DELIMITER ',' CSV HEADER;"
}

function results {
    if get_results; then
        load_results
    else
        echo "ERROR | RESULTS | Bad response. Did not load $RACEDATE."
    fi
}