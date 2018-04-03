#!/bin/bash

url=http://blog.kbresearch.nl
domains=blog.kbresearch.nl,wp.com,researchkb.files.wordpress.com,googleapis.com,gstatic.com

logFile=wget.log
wget --mirror --page-requisites --span-hosts --convert-links --backup-converted --adjust-extension -w 5 --random-wait --domains=$domains $url >>$logFile 2>&1

# Power off the machine
#poweroff


