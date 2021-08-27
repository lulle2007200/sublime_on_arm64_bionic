Sublime Text does not work out of the box on arm64 Ubuntu 18.04 Bionic machines since it required glibc2.28.  
Trying to run Sublime Text anyway results in `plugin_host-3.3` and `plugin_host-3.8 crashing`, which results in the vast majority of Sublime Text functions not working at all.

To make it work, just run `sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/lulle2007200/sublime_on_arm64_bionic/master/install_sublime.sh)"`.  

If Sublime Text is not already installed, it gives you the option to automatically install the latest stable release from the apt repository.  

If you run the script while Sublime Text is running, changes will take effect after you close and fully restart Sublime Text the next time.  

This script will download and install glibc2.28 to `/opt` and patch the Sublime Text binaries so that they load the right glibc2.28 libraries. This *only* affects Sublime Text. Other programs will continue to use the system provided glibc version (in this case glibc2.27). The script does *not* replace the system provided glibc version.
