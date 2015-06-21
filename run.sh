#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

echo "starting sshd..."
exec /usr/sbin/sshd -D
echo "starting tomcat..."
exec /opt/tomcat/current/bin/catalina.sh run
