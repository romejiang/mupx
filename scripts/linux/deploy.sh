#!/bin/bash

revert_app (){
  if [[ -d old_app ]]; then
    sudo rm -rf app
    sudo mv old_app app
    sudo stop <%= appName %> || :
    sudo start <%= appName %> || :

    echo "Latest deployment failed! Reverted back to the previous version." 1>&2
    exit 1
  else
    echo "App did not pick up! Please check app logs." 1>&2
    exit 1
  fi
}

set -e

APP_DIR=/opt/<%=appName %>
DATE=`date '+%Y%m%d%H%M%S'`

# save the last known version
cd $APP_DIR
if [[ -d current ]]; then
  if [[ -d last ]]; then
    sudo mv last last$DATE
  fi
  sudo mv current last
fi

# setup the new version
sudo mkdir current
if [[ -d last/cfs ]]; then
  sudo mv last/cfs current/
fi
sudo cp tmp/bundle.tar.gz current/

tar zxvf /opt/fibers-1.0.10.tar.gz -C /opt/<%= appName %>/current/
cp -Rf /opt/run_app.sh /opt/<%= appName %>/current/
# We temporarly stopped the binary building
# Instead we are building for linux 64 from locally
# That's just like what meteor do
# We can have option to turn binary building later on, 
# but not now

# # rebuild binary module
# cd current
# sudo tar xzf bundle.tar.gz

# docker run \
#   --rm \
#   --volume=$APP_DIR/current/bundle/programs/server:/bundle \
#   --entrypoint="/bin/bash" \
#   meteorhacks/meteord:binbuild -c \
#     "cd /bundle && bash /opt/meteord/rebuild_npm_modules.sh"

# sudo rm bundle.tar.gz
# sudo tar czf bundle.tar.gz bundle
# sudo rm -rf bundle
# cd ..

# start app
sudo bash config/start.sh