apt install patchelf
#wget
patchelf --remove-rpath /opt/sublime_text/sublime_text
patchelf --remove-rpath /opt/sublime_text/plugin_host-3.3
patchelf --remove-rpath /opt/sublime_text/plugin_host-3.8
patchelf --remove-rpath /opt/sublime_text/crash_reporter

patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/sublime_text
patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.3
patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/plugin_host-3.8
patchelf --force-rpath --set-rpath "/opt/glibc2.28/lib:/usr/lib/aarch64-linux-gnu:/lib/aarch64-linux-gnu:\$ORIGIN" --set-interpreter /opt/glibc2.28/lib/ld-linux-aarch64.so.1 /opt/sublime_text/crash_reporter