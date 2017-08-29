#!/bin/bash
REQUEST_BODY=$(cat <<EOF
{
    "commands": [
        {
            "create-container": {
                "container": {
                    "status": null,
                    "messages": [],
                    "container-id": "br.gov.ancine:sin-bpm-process:0.0.3",
                    "release-id": {
                        "version": "0.0.3",
                        "group-id": "br.gov.ancine",
                        "artifact-id": "sin-bpm-process"
                    },
                    "config-items": [
                        {
                            "itemName": "KBase",
                            "itemValue": "",
                            "itemType": "BPM"
                        },
                        {
                            "itemName": "KSession",
                            "itemValue": "",
                            "itemType": "BPM"
                        },
                        {
                            "itemName": "MergeMode",
                            "itemValue": "MERGE_COLLECTIONS",
                            "itemType": "BPM"
                        },
                        {
                            "itemName": "RuntimeStrategy",
                            "itemValue": "PER_PROCESS_INSTANCE",
                            "itemType": "BPM"
                        }
                    ]
                }
            }
        }
    ]
}
EOF
)


MAX_WAIT=180
DELAY=5
TOTAL_WAIT=0

until [ $TOTAL_WAIT -gt $MAX_WAIT ]
do
    if $EAP_HOME/bin/jboss-cli.sh -c --command="deployment-info --name=kie-server.war" | grep -q "OK"
    then 
        curl -X POST -u 'kiecontrolleruser:kiecontrolleruser1!' -H 'Content-type: application/json' -H 'X-KIE-ContentType: JSON' --data "$REQUEST_BODY" 'http://localhost:8080/kie-server/services/rest/server/config'
        break
    fi
    sleep $DELAY
    let TOTAL_WAIT=$TOTAL_WAIT+$DELAY;
done




