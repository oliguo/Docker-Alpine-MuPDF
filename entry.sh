#!/bin/sh

##Start crond
/usr/sbin/crond start
/usr/bin/crontab /opt/crontab.conf

##Shell
/bin/sh
