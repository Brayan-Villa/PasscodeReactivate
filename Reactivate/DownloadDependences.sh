if test -z $(find /usr/bin -iname "LibimobiledeviceEXE");
	then
		git clone https://github.com/Brayan-Villa/LibimobiledeviceEXE;
		mv LibimobiledeviceEXE /usr/bin/;
		mv /usr/bin/LibimobiledeviceEXE/* /usr/bin/;
		idevicepair pair;
	else
		idevicepair pair;
		echo '';
		clear
fi
if test -z $(find ~/.ssh -iname "known_hosts");
	then
		echo '';
		clear;
	else
		rm ~/.ssh/known_hosts;
fi
iproxy 22 44 &>/dev/nul&