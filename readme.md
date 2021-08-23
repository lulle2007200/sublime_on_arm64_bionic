Sublime Text does not work out of the box on arm64 Ubuntu 18.04 Bionic machines, because it requires glibc2.28.  
To make it work, run `sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/lulle2007200/sublime_on_arm64_bionic/master/install_sublime.sh)"`.  
If not installed already, the script will install Sublime Text from the stable channel, install glibc2.28 and do the necessary changes to make Sublime Text work.
