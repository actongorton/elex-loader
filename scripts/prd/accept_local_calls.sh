#!/bin/bash

. scripts/stg/_racecalls.sh


if [[ ! -z $1 ]] ; then 
    RACEDATE=$1 
fi

accept_local_ap_calls