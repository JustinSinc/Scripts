#!/bin/bash
# A very basic script for rebuilding the musicbot config tarball after making changes

cd /var/www/html/musicbot
tar -cvf musicbot_config.tar ./config/
tar --exclude='./config/' -cvf musicbotv3.tar ./*
mv musicbotv3.tar ../
