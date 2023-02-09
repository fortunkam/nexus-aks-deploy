FILE=/mnt/nexus-data/nexus_initialized

if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist.  Starting initialization procedure"

    echo "Waiting for Nexus startup on $SERVICE_URI/service/rest/v1/status"
    # Wait for api to be ready
    while [ $(curl --insecure -o /dev/null -s -w "%{http_code}\n" "$SERVICE_URI/service/rest/v1/status") -ne 200 ]
    do 
        echo "Waiting for Nexus startup (sleeping)"         
        sleep 10                  
    done

    old_admin_password=$(cat /mnt/nexus-data/admin.password)

    echo "setting new admin password"

    curl -i --insecure -u $ADMIN_USERNAME:$old_admin_password -H "Content-Type: text/plain" -X PUT "$SERVICE_URI/service/rest/v1/security/users/admin/change-password" -d "$ADMIN_PASSWORD"

    # Remove the default repos in nexus
    echo "getting list of default repos"
    defaultRepos=$(curl --insecure -s -u $ADMIN_USERNAME:$ADMIN_PASSWORD -X GET $SERVICE_URI/service/rest/v1/repositorySettings | jq 'map({name:.name})')

    for row in $(echo $defaultRepos | jq -r '.[].name' ); do
        echo "deleting repository $row"
        curl --insecure -i -u $ADMIN_USERNAME:$ADMIN_PASSWORD -X DELETE "$SERVICE_URI/service/rest/v1/repositories/$row"
    done

    touch /mnt/nexus-data/nexus_initialized
else
    echo "$FILE exists.  Skipping initialization"
fi