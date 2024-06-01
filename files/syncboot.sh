#!/usr/bin/env sh

rsync -avxHAX --delete-before --progress /boot/ /boot2/
rsync -avxHAX --delete-before --progress /boot/ /boot3/
rsync -avxHAX --delete-before --progress /boot/ /boot4/
