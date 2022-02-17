#!/bin/sh

invoke_vegeta(){
    i=$1
    speed=$2
    currtime=$(date)
    stamp=${1:-$(date +%s)_$i}
    title="${currtime} - ${i}RPS"
    ##echo $title
    ##Authentication
    ##authentication=$(curl -d "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&grant_type=client_credentials" -X POST "$AUTHENTICATION_URL" | jq '.AccessToken' | tr -d '"')
    #echo "Authorization: Bearer ${authentication}"
    ##vegeta attack -header "Authorization: Bearer ${authentication}" -format=json -targets="./vegeta/${REQUESTFILE}"   -redirects=0 -duration=${speed}m    -rate ${i}/1s | tee vegeta/data/report/${assignedfolder}/results_$stamp.bin | vegeta report  -type=json  -buckets="[0,250ms,500ms,1000ms,2000ms]" | tee vegeta/data/report/${assignedfolder}/report_$stamp.json
    ##Kicks off vegeta
    vegeta attack -targets="${REQUESTFILE}"   -redirects=0 -duration=${speed}m    -rate ${i}/1s | tee vegeta/data/report/${assignedfolder}/results_$stamp.bin | vegeta report  -type=json  -buckets="[0,250ms,500ms,1000ms,2000ms]" | tee vegeta/data/report/${assignedfolder}/report_$stamp.json
    finishtime=$(date)
    csvval=$(cat vegeta/data/report/${assignedfolder}/report_${stamp}.json | jq -r '"\(.latencies.min/1000000),\(.latencies.max/1000000),\(.latencies.mean/1000000),\(.latencies."50th"/1000000),\(.latencies."90th"/1000000),\(.latencies."95th"/1000000),\(.latencies."99th"/1000000),\(.buckets["0"]),\(.buckets["250000000"]),\(.buckets["500000000"]),\(.buckets["1000000000"]),\(.status_codes | tostring | gsub(","; "|")),\(.requests)"')
    stringtoappend="${currtime},${finishtime},${i},${csvval}"
    echo $stringtoappend >> $filename
    cat $filename
    cat vegeta/data/report/${assignedfolder}/report_$stamp.json

    #Removes json and bin files
    find . -name "vegeta/data/report/${assignedfolder}/*.json" -o -name "vegeta/data/report/${assignedfolder}/*.bin"
    find . -name "vegeta/data/report/${assignedfolder}/*.json" -o -name "vegeta/data/report/${assignedfolder}/*.bin" | xargs rm -f
}

echo "Duration $RAMPUPSPEED, RATE: $TARGETRATE, authentication: $AUTHENTICATION_URL, SECRET:$CLIENT_ID"

urltoreplace="http://localhost:5000"
sed -i.bak 's,'"${urltoreplace}","${ENVIRONMENT_URL}"',g' ${REQUESTFILE}
assignedfolder="$(date '+%Y-%m-%d-%H%M')"

if [ ! -d $(pwd)/vegeta/data ]; then
    mkdir vegeta
    mkdir vegeta/data
    mkdir vegeta/data/report
fi
mkdir vegeta/data/report/$assignedfolder

numberofruns=0
filename="vegeta/data/report/$assignedfolder/$(date +"%m_%d_%I_%M_%p%s").csv"
echo "StartTime,FinishTime,RPS,Min(ms),Max(ms),Mean(ms),Latencies 50%(ms),Latencies 90%(ms),Latencies 95%(ms),Latencies 99%(ms),Request duration > 0ms, Request duration >250ms Sla,Request duration > 500ms,Request duration > 1000ms,Status Code,TotalRequests" > $filename
for i in `seq  $STARTPOINT $STEPCOUNT $TARGETRATE`; do
    rateaim=$(($i * 60))
    if [ ${i} -lt ${RATETOSCALERAPIDLY} ]; then
        echo "running warmup at ${rateaim}rpm for ${SLOWSPEED} minutes"
        invoke_vegeta $i $SLOWSPEED $filename
    elif [ `expr $numberofruns % $MODULUS` -eq 0 ]; then
        echo "running extended step at ${rateaim}rpm for ${SLOWSPEED} minutes"
        invoke_vegeta $i $SLOWSPEED $filename
    else
        echo "running normal step at ${rateaim}rpm for ${RAMPUPSPEED} minutes"
        invoke_vegeta $i $RAMPUPSPEED $filename
    fi
    numberofruns=$((numberofruns+1))

    echo $numberofruns
done