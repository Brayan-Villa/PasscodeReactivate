#!/bin/bash
UDID=$(ideviceinfo | grep -w UniqueDeviceID | awk '{printf $NF}');
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'mount -o rw,union,update /';
sshpass -p 'alpine' scp -p $UDID/chflags root@localhost:"/./bin/";
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chmod 755 /bin/chflags; mkdir -p /./boot';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chflags -R nouchg /private/var/containers/Data/System';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'rm -rf /private/var/containers/Data/System/*';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'killall fairplayd.H2';
sleep 1;
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'ls /private/var/containers/Data/System/ &>/./guid';
sshpass -p 'alpine' scp -rp $UDID/Media root@localhost:"/./";
sshpass -p 'alpine' scp -rp $UDID/Library root@localhost:"/./boot/";
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'key=$(cat /./guid); cp -rp /./Media /private/var/containers/Data/System/$guid/Documents/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'key=$(cat /./guid); cp -rp /./boot/Library /private/var/containers/Data/System/$guid/Documents/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chown -R mobile.nobody /private/var/containers/Data/System/$guid/Documents/*';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chmod -R 00755 /private/var/containers/Data/System/$guid/Documents/*';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'key=$(find /private/var/containers/Data/System -iname IC-Info*); chmod -R 00644 $key';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./Media /private/var/mobile/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./boot/Library /private/var/mobile/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'killall -9 SpringBoard mobileactivationd';
sleep 5;
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'launchctl unload /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist';
sshpass -p 'alpine' scp -p $UDID/activation_record.plist root@localhost:"/./";
sshpass -p 'alpine' scp -p $UDID/data_ark.plist root@localhost:"/./";
sshpass -p 'alpine' scp -p $UDID/com.apple.commcenter.device_specific_nobackup.plist root@localhost:"/./";
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chflags -R nouchg /private/var/wireless';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./com.apple.commcenter.device_specific_nobackup.plist /private/var/wireless/Library/Preferences/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'chflags uchg /private/var/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./data_ark.plist /private/var/containers/Data/System/*/Library/internal/';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /private/var/containers/Data/System/*/Library/internal /private/var/containers/Data/System/*/Library/internal/../activation_records';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'mv /private/var/containers/Data/System/*/Library/internal/../activation_records/data_ark.plist /private/var/containers/Data/System/*/Library/internal/../activation_records/activation_record.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./activation_record.plist /private/var/containers/Data/System/*/Library/internal/../activation_records/';
CheckMEID=$(ideviceinfo | grep -w MobileEquipmentIdentifier | awk '{printf $NF}');
if test -z "$CheckMEID";
	then
		sshpass -p 'alpine' scp -p $UDID/cacert.crt root@localhost:"/./System/Library/PrivateFrameworks/MobileActivation.framework/Support/";
		sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./System/Library/PrivateFrameworks/MobileActivation.framework/Support/cacert.crt /./System/Library/PrivateFrameworks/MobileActivation.framework/Support/Certificates/RaptorActivation.pem';
	else
		sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cp -rp /./System/Library/PrivateFrameworks/MobileActivation.framework/Support/Certificates/FactoryActivation.pem /./System/Library/PrivateFrameworks/MobileActivation.framework/Support/Certificates/RaptorActivation.pem';
fi
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'uicache --all';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'launchctl load /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist';
clear;
read -p "Check";