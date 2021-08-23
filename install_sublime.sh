if [ "$EUID" -ne 0 ]
  then echo "Run as sudo"
  exit
fi

read -p "Make sure, Sublime Text is installed.\nPress enter to continue"

if ! which patchelf
then
	if ! apt install patchelf
	then
		echo "Failed to install patchelf. Exiting."
		exit 1
	fi
fi

if ! which wget
then
	if ! apt install wget
	then
		echo "Failed to install wget. Exiting."
		exit 1
	fi
fi

if ! which tar
then
	if ! apt install tar
	then
		echo "Failed to install tar. Exiting."
		exit 1
	fi
fi

if ! wget -O /tmp/glibc2.28.tar.gz https://github.com/lulle2007200/sublime_on_arm64_bionic/raw/master/glibc2.28.tar.gz
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

if ! tar -zxvf /tmp/glibc2.28.tar.gz -C /opt/glibc2.28
then
	echo "Failed to extract glibc2.28. Exiting."
	rm /tmp/glibc2.28.tar.gz
	exit 1
fi

if ! (patchelf --remove-rpath /opt/sublime_text/sublime_text && \
      patchelf --remove-rpath /opt/sublime_text/plugin_host-3.3 && \
      patchelf --remove-rpath /opt/sublime_text/plugin_host-3.8 && \
      patchelf --remove-rpath /opt/sublime_text/crash_reporter && \
      patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/sublime_text && \
      patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.3 && \
      patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.8 && \
      patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/crash_reporter)
then
	echo "Failed to patch Sublime Text binaries. Exiting."
	rm /tmp/glibc2.28.tar.gz
	exit 1
fi

echo "Successfully installed Sublime Text."
exit 0