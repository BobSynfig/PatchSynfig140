#/bin/bash

# Patch for Synfig 1.4.4
# Remove libstdc++.so.6, some unneeded locale, repairs some symlinks (spares 12Mb)
# Converts from AppImage v1 to v2 with compression (112 -> 73mb)
# Requires sudo rights

# 2022-12-30 Update for 1.4.4
# 2020-11-15 BobSynfig
# License: Avoid to catch and transmit the COVID and do what you want with this script :)

#----------------------------------------------------------------
# Basic configuration
#----------------------------------------------------------------

# 32 or 64
ARCH=64
# Name it as you wish :)
AI_DST="SynfigStudio-1.4.4-2022.12.25-linux${ARCH}-b8d62-Patched.appimage"
# Rewrite wrong symlinks
LINKS=all
# List of locales to delete
# "en" is already preserved, don't forget to remove your own language to preserve it!
#DELETE_LOCALE=""
DELETE_LOCALE="
aa_DJ af am an ang ar ar_EG as ast az az_IR be be@latin bg bn bn_IN br bs ca ca@valencia
crh cs csb cs_CZ cy da de dz el el_GR    en_CA en_CZ en_GB en@shaw eo es es_AR es_PY
et eu eu_ES fa fa_IR fi fr fur fy ga gd gl gu he hi hi_IN hr hu hy ia id io is it ja
ja_JP ka kab kg kk km kn ko ko_KR ku ky lg li ln lt lv mai mg mi mk ml mn mr ms my nb nds
ne nl nn nso oc or pa pl pl_PL ps pt pt_BR ro ru rw si sk sk_SK sl sq sr sr@ije
sr@latin sr_RS sv sv_SE ta te tg th tk tl tr tt ug uk ur uz uz@cyrillic uz@Latn vi
wa xh yi zh_CN zh-Hant zh_HK zh_TW zh_TW.Big5 zu"

#----------------------------------------------------------------
# Don't modify below
#----------------------------------------------------------------
if [ $ARCH = 64 ];
then
ARCH2=x86_64
else
ARCH2=i686
fi

AI_SRC="SynfigStudio-1.4.4-2022.12.25-linux${ARCH}-b8d62.appimage"
AI_URL="https://github.com/synfig/synfig/releases/download/v1.4.4/${AI_SRC}"
AITOOL="appimagetool-${ARCH2}.AppImage"
AITOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/13/${AITOOL}"

# Download Synfig if not in current directory
if [ ! -f "$AI_SRC" ]; then
  echo  "# Downloading Synfig"
  wget  $AI_URL
  chmod +x ./$AI_SRC
else
  echo "# Synfig present - Skip download"
fi

echo "# Download AppImage Tool"
if [ ! -f "$AITOOL" ]; then
  echo "# Downloading AppImageTool"
  wget  $AITOOL_URL
  chmod +x ./$AITOOL
else
  echo "# AppimageTool present - Skip download"
fi

# Create a mountpoint if needed
if [ ! -d ./mnt ]; then
  mkdir ./mnt
fi

# Create a AppDir where to unpack the AppImage content
if [ ! -d ./AppDir ]; then
  mkdir ./AppDir
fi

echo "# Mount the AppImage"
sudo mount $AI_SRC ./mnt -o loop

echo "# Extract the content of the AppImage"
cp -a ./mnt/. ./AppDir

echo "# Delete unneeded LOCALE"
pushd . >/dev/null 2>&1
cd ./AppDir/usr/share/locale
for dl in $DELETE_LOCALE
do
  if [ -d $dl ]; then
    rm -rf $dl
  fi
done
popd >/dev/null 2>&1

echo "# Overwrite wrong Symlinks"
# Spares 12,188,688 bytes
if [ "$LINKS" = "all" ];
then

  SRC="./AppDir/usr/lib"
  DST=""
  pushd . >/dev/null 2>&1
  cd $SRC >/dev/null 2>&1

  rm -f libstdc++.so.6                                   >/dev/null 2>&1
  ln -s -f libstdc++.so.6.0.22 libstdc++.so.6            >/dev/null 2>&1

  rm -f {libbz2.so,libbz2.so.1,libbz2.so.1.0}            >/dev/null 2>&1
  ln -s -f libbz2.so.1.0.4 libbz2.so                     >/dev/null 2>&1
  ln -s -f libbz2.so.1.0.4 libbz2.so.1                   >/dev/null 2>&1
  ln -s -f libbz2.so.1.0.4 libbz2.so.1.0                 >/dev/null 2>&1

  rm -f {libdbus-1.so,libdbus-1.so.3}                    >/dev/null 2>&1
  ln -s -f libdbus-1.so.3.14.18 libdbus-1.so             >/dev/null 2>&1
  ln -s -f libdbus-1.so.3.14.18 libdbus-1.so.3           >/dev/null 2>&1

  rm -f libdbus-glib-1.so.2                              >/dev/null 2>&1
  ln -s -f libdbus-glib-1.so.2.3.3 libdbus-glib-1.so.2   >/dev/null 2>&1

  rm -f {libdirect.so,libdirect-1.2.so.9}                >/dev/null 2>&1
  ln -s -f libdirect-1.2.so.9.0.1 libdirect.so           >/dev/null 2>&1
  ln -s -f libdirect-1.2.so.9.0.1 libdirect-1.2.so.9     >/dev/null 2>&1

  rm -f {libdirectfb.so,libdirectfb-1.2.so.9}            >/dev/null 2>&1
  ln -s -f libdirectfb-1.2.so.9.0.1 libdirectfb.so       >/dev/null 2>&1
  ln -s -f libdirectfb-1.2.so.9.0.1 libdirectfb-1.2.so.9 >/dev/null 2>&1

  rm -f libgccpp.so.1                                    >/dev/null 2>&1
  ln -s -f libgccpp.so.1.0.3 libgccpp.so.1               >/dev/null 2>&1

  rm -f libgomp.so.1                                     >/dev/null 2>&1
  ln -s -f libgomp.so.1.0.0 libgomp.so.1                 >/dev/null 2>&1

  rm -f {libpcre16.so,libpcre16.so.3}                    >/dev/null 2>&1
  ln -s -f libpcre16.so.3.13.3 libpcre16.so              >/dev/null 2>&1
  ln -s -f libpcre16.so.3.13.3 libpcre16.so.3            >/dev/null 2>&1

  rm -f {libpcre32.so,libpcre32.so.3}                    >/dev/null 2>&1
  ln -s -f libpcre32.so.3.13.3 libpcre32.so              >/dev/null 2>&1
  ln -s -f libpcre32.so.3.13.3 libpcre32.so.3            >/dev/null 2>&1

  rm -f {libpcrecpp.so,libpcrecpp.so.0}                  >/dev/null 2>&1
  ln -s -f libpcrecpp.so.0.0.1 libpcrecpp.so             >/dev/null 2>&1
  ln -s -f libpcrecpp.so.0.0.1 libpcrecpp.so.0           >/dev/null 2>&1

  rm -f {libudev.so,libudev.so.1}                        >/dev/null 2>&1
  ln -s -f libudev.so.1.6.5 libudev.so                   >/dev/null 2>&1
  ln -s -f libudev.so.1.6.5 libudev.so.1                 >/dev/null 2>&1

  rm -f libgfortran.so.3                                 >/dev/null 2>&1
  ln -s -f libgfortran.so.3.0.0 libgfortran.so.3         >/dev/null 2>&1

  rm -f {libpcre.so,libpcre.so.3}                        >/dev/null 2>&1
  ln -s -f libpcre.so.3.13.3 libpcre.so                  >/dev/null 2>&1
  ln -s -f libpcre.so.3.13.3 libpcre.so.3                >/dev/null 2>&1

  rm -f libquadmath.so.0                                 >/dev/null 2>&1
  ln -s -f libquadmath.so.0.0.0 libquadmath.so.0         >/dev/null 2>&1

  rm -f libselinux.so                                    >/dev/null 2>&1
  ln -s -f libselinux.so.1 libselinux.so                 >/dev/null 2>&1

  rm -f libdb.so                                         >/dev/null 2>&1
  ln -s -f libdb-5.3.so libdb.so                         >/dev/null 2>&1

  rm -f {libfusion.so,libfusion-1.2.so.9}                >/dev/null 2>&1
  ln -s -f libfusion-1.2.so.9.0.1 libfusion.so           >/dev/null 2>&1
  ln -s -f libfusion-1.2.so.9.0.1 libfusion-1.2.so.9     >/dev/null 2>&1

  rm -f {libpcreposix.so,libpcreposix.so.3}              >/dev/null 2>&1
  ln -s -f libpcreposix.so.3.13.3 libpcreposix.so        >/dev/null 2>&1
  ln -s -f libpcreposix.so.3.13.3 libpcreposix.so.3      >/dev/null 2>&1

  #-----
  popd >/dev/null 2>&1

  #----------------------------------------------------------------
  SRC="./AppDir/usr/lib.extra/jack"
  DST=""
  pushd . >/dev/null 2>&1
  cd $SRC >/dev/null 2>&1

  rm -f {libjack.so,libjack.so.0}                        >/dev/null 2>&1
  ln -s -f libjack.so.0.0.28 libjack.so                  >/dev/null 2>&1
  ln -s -f libjack.so.0.0.28 libjack.so.0                >/dev/null 2>&1

  rm -f {libjackserver.so,libjackserver.so.0}            >/dev/null 2>&1
  ln -s -f libjackserver.so.0.0.28 libjackserver.so      >/dev/null 2>&1
  ln -s -f libjackserver.so.0.0.28 libjackserver.so.0    >/dev/null 2>&1

  #-----
  popd >/dev/null 2>&1

fi

echo ":: Patch (removal of libstdc++.so.6)"
TO_BE_REMOVED_1=./AppDir/usr/lib/libstdc++.so.6
TO_BE_REMOVED_2=./AppDir/usr/lib/libstdc++.so.6.0.22

rm $TO_BE_REMOVED_1 >/dev/null 2>&1
rm $TO_BE_REMOVED_2 >/dev/null 2>&1

echo "# Repack the AppImage (and compresses it!)"
ARCH=$ARCH2 ./$AITOOL ./AppDir ./$AI_DST

echo "# Unmount the AppImage"
sudo umount ./mnt

echo "# Cleanup"
rm -R ./AppDir
rmdir ./mnt

echo "# Done"
