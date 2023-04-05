#!/bin/sh

cd /www/SSPanel-Uim
php xcat Migration new
php xcat Tool importAllSettings
php xcat Tool createAdmin
php xcat ClientDownload
echo "1" > /www/SSPanel-Uim/config/.started
