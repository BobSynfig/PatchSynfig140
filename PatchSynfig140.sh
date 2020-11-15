#/bin/bash

# Patch for Synfig 1.4.0
# Solves Fontconfig issues and remove unnedeed locale
# Requires sudo rights

# 2020-11-15 BobSynfig 
# License: Avoid to catch and transmit the COVID and do what you want with this script :)

#----------------------------------------------------------------
# Basic configuration
#----------------------------------------------------------------

# 32 or 64
ARCH=64
# Name it as you wish :)
AI_DST="SynfigStudio-1.4.0-stable-$ARCH-Patched.appimage"
# existing or all (For Fontconfig files, all is better)
LINKS=all
# List of locales to delete
# "en" is already preserved, don't forget to remove your own language to preserve it!
DELETE_LOCALE="
aa_DJ af am an ang ar as ast az az_IR be be@latin bg bn bn_IN br bs ca ca@valencia
crh cs csb cs_CZ cy da de dz el el_GR    en_CA en_CZ en_GB en@shaw eo es es_AR es_PY
et eu eu_ES fa fa_IR fi fr fur fy ga gd gl gu he hi hi_IN hr hu hy ia id io is it ja
ja_JP ka kab kg kk km kn ko ku ky lg li ln lt lv mai mg mi mk ml mn mr ms my nb nds
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

AI_SRC="SynfigStudio-1.4.0-stable-2020.11.14-linux${ARCH}-b9862.appimage"
AI_URL="https://github.com/synfig/synfig/releases/download/v1.4.0/${AI_SRC}"
AITOOL="appimagetool-${ARCH2}.AppImage"
AITOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/12/${AITOOL}"

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

echo "# Overwrite wrong Symlinks"

if [ "$LINKS" = "existing" ];
then
  # Only the existing links
  SRC=./AppDir/usr/etc/fonts/conf.d
  DST=../../../share/fontconfig/conf.avail
  pushd . >/dev/null 2>&1
  cd $SRC >/dev/null 2>&1

  ln -s -f $DST/10-scale-bitmap-fonts.conf ./10-scale-bitmap-fonts.conf
  ln -s -f $DST/20-unhint-small-vera.conf  ./20-unhint-small-vera.conf
  ln -s -f $DST/30-metric-aliases.conf     ./30-metric-aliases.conf
  ln -s -f $DST/30-urw-aliases.conf        ./30-urw-aliases.conf
  ln -s -f $DST/40-nonlatin.conf           ./40-nonlatin.conf
  ln -s -f $DST/45-latin.conf              ./45-latin.conf
  ln -s -f $DST/49-sansserif.conf          ./49-sansserif.conf
  ln -s -f $DST/50-user.conf               ./50-user.conf
  ln -s -f $DST/51-local.conf              ./51-local.conf
  ln -s -f $DST/60-latin.conf              ./60-latin.conf
  ln -s -f $DST/65-fonts-persian.conf      ./65-fonts-persian.conf
  ln -s -f $DST/65-nonlatin.conf           ./65-nonlatin.conf
  ln -s -f $DST/69-unifont.conf            ./69-unifont.conf
  ln -s -f $DST/80-delicious.conf          ./80-delicious.conf
  ln -s -f $DST/90-synthetic.conf          ./90-synthetic.conf

elif [ "$LINKS" = "all" ]; then
 # All the links

  # Copy the conf files (to have their names)
  SRC=../../../etc/fonts/conf.d
  DST=./AppDir/usr/share/fontconfig/conf.avail
  pushd .           >/dev/null 2>&1
  cd $DST           >/dev/null 2>&1

  cp ./*.conf $SRC  >/dev/null 2>&1
  popd              >/dev/null 2>&1

  #-----

  # "Convert" them as symlinks
  SRC=./AppDir/usr/etc/fonts/conf.d
  DST=../../../share/fontconfig/conf.avail
  pushd . >/dev/null 2>&1
  cd $SRC >/dev/null 2>&1

  for f in *.conf
  do
    #echo $f
    rm $f
    ln -s -f $DST/$f ./$f
  done
  #-----
  popd >/dev/null 2>&1
else
  echo "!!! Wrong option !"
fi

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

echo "# Correct FONTCONFIG_PATH"
sed -i 's/FONTCONFIG_PATH=\/etc\/fonts/FONTCONFIG_PATH=\$\{BASE_DIR\}\/etc\/fonts/g' ./AppDir/usr/bin/launch.sh

echo "# Repack the AppImage (and compresses it!)"
ARCH=$ARCH2 ./$AITOOL ./AppDir ./$AI_DST

echo "# Unmount the AppImage"
sudo umount ./mnt

echo "# Cleanup"
rm -R ./AppDir
rmdir ./mnt

echo "# Done"
