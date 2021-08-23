if [ "$EUID" -ne 0 ]
  then echo "Run as sudo"
  exit
fi

if ! which subl
then
	read -p "Sublime Text not installed. Install Sublime Text and continue? [yY/nN]: " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if ! apt -qq -y install wget apt-transport-https software-properties-common
		then
			echo "Failed to install dependencies. Exiting."
			exit 1
		fi
	    if ! wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	    then
	    	echo "Failed to install Sublime GPG key. Exiting."
	    	exit 1
	    fi
	    if ! add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
	    then
	    	echo "Failed to add Sublime Text apt repository. Exiting"
	    	exit 1
	    fi
	    if ! apt -qq update
	    then
	    	echo "apt update failed. Exiting."
	    	exit 1
	    fi
	    if ! apt -qq -y install sublime-text
	    then
	    	echo "Failed to install Sublime Text. Exiting."
	    	exit 1
	    fi
	else
		echo "Exiting."
		exit 1
	fi
fi

if ! apt -qq -y install patchelf wget tar
then
	echo "Failed to install dependencies. Exiting."
	exit 1
fi

if ! wget -qO /tmp/glibc2.28.tar.gz https://github.com/lulle2007200/sublime_on_arm64_bionic/raw/master/glibc2.28.tar.gz
then
	echo "Failed to download glibc2.27.tar.gz. Exiting."
	exit 1
fi

if ! mkdir /opt/glibc2.28
then
	echo "Failed to create glibc2.28 directory. Exiting."
	rm /tmp/glibc2.28.tar.gz
	exit 1
fi

if ! tar -zxf /tmp/glibc2.28.tar.gz -C /opt/glibc2.28
then
	echo "Failed to extract glibc2.28. Exiting."
	rm /tmp/glibc2.28.tar.gz
	exit 1
fi

if ! patchelf --remove-rpath /opt/sublime_text/sublime_text || \
   ! patchelf --remove-rpath /opt/sublime_text/plugin_host-3.3 || \
   ! patchelf --remove-rpath /opt/sublime_text/plugin_host-3.8 || \
   ! patchelf --remove-rpath /opt/sublime_text/crash_reporter || \
   ! patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/sublime_text || \
   ! patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.3 || \
   ! patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.8 || \
   ! patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/crash_reporter
then
	echo "Failed to patch Sublime Text binaries. Exiting."
	rm /tmp/glibc2.28.tar.gz
	exit 1
fi

echo "Successfully installed Sublime Text."
exit 0