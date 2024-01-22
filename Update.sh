old_build=`steamcmd +login anonymous +app_status 2394010 +quit | grep -e "BuildID" | awk '{print $8}'`
new_build=``

if [ "$old_build" -gt "$new_build"]
    steamcmd +login anonymous +app_update 2394010 validate +quit
fi
exec "$@"