#!/bin/bash
#
# Title:      PlexGuide (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################

# FUNCTIONS START ##############################################################

# FIRST FUNCTION
nzbt () {
if [ "$typed" == "nzbthrottle" ]; then ptoken=$(cat /var/plexguide/plex.token);
 if [ "$ptoken" == "" ]; then
   bash /opt/plexguide/menu/plex/token.sh
   ptoken=$(cat /var/plexguide/plex.token)
   if [ "$ptoken" == "" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Failed to Generate a Valid Plex Token! Exiting Deployment!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    exit; fi; fi; fi
}
# FUNCTIONS END ################################################################

num=0
echo " " > /var/plexguide/programs.temp

# Ensure Variable Exist for Plex Token Detection
touch /var/plexguide/plex.token

bash /opt/plexguide/containers/_appsgen.sh

while read p; do
  echo -n $p >> /var/plexguide/programs.temp
  echo -n " " >> /var/plexguide/programs.temp

  num=$[num+1]
  if [ $num == 7 ]; then
    num=0
    echo " " >> /var/plexguide/programs.temp
  fi

done </var/plexguide/app.list

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
♻️  INSTALLER: PG Applications Suite
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 Visit http://newshosting.plexguide.com - 58% NZB Hosting Discount!
EOF
cat /var/plexguide/programs.temp
echo && echo
# Standby
echo "FINSIHED? Type > exit"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '🌎 TYPE App Name | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The App Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /opt/plexguide/install/serverid.sh
exit
elif [ "$typed" == "exit" ]; then
  exit
else

  # Recalls for to check existance
  rcheck=$(cat /var/plexguide/programs.temp | grep -c "\<$typed\>")
  if [ "$rcheck" == "0" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - App Does Not Exist! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 4
  bash /opt/plexguide/menu/appsv2/appsv2.sh
  exit
  fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: $typed - Now Installing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
# Prevents From Repeating
#echo "$typed" > /var/plexguide/restore.id

sleep 1.5

if [ "$typed" == "plex" ]; then bash /opt/plexguide/menu/plex/plex.sh;
elif [ "$typed" == "nzbthrottle" ]; then nzbt; fi

# Store Used Program
echo $typed > /tmp/program_var
# Image Selector
bash /opt/plexguide/containers/image/_image.sh
# Execute Main Program
ansible-playbook /opt/plexguide/containers/$typed.yml
# Cron Execution
edition=$( cat /var/plexguide/pg.edition )
if [[ "$edition" == "PG Edition - HD Multi" || "$edition" == "PG Edition - HD Solo" ]]; then a=b
else
  croncheck=$(cat /opt/plexguide/containers/_cron.list | grep -c "\<$typed\>")
  if [ "$croncheck" == "0" ]; then bash /opt/plexguide/menu/cron/cron.sh; fi
fi

# End Banner
bash /opt/plexguide/menu/endbanner/endbanner.sh

read -n 1 -s -r -p "Press [ANY] Key to Continue "
fi

bash /opt/plexguide/menu/appsv2/appsv2.sh
exit
