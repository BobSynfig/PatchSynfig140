# PatchSynfig140
Patch for Synfig 1.4.0 AppImage  
Solves Fontconfig errors + removes unneeded locale  

Don't wait for a new version of Synfig, it takes 2 minutes ^_^  
**sudo required for mounting the appimage for extraction**  

# Features  
- Automatic downloads from GitHub official repositories of AppImageKit and Synfig  
- Unpack the appimage  
- Patch internal Fontconfig configuration and the Launcher  
- Remove unneeded locale (_be aware that by default only "en" is kept, remove your language from the list_)  
- Repack the AppImage (it is even compressed ^_^)  
- Clean before to quit   

# Usage  
- Create a directory or clone this "huge" repo  
- Make the script executable  
- Edit the config part if needed (Archi 32/64, Name of the produced file, Locales to delete...)  
- If you already have SynfigStudio on your machine, place it in the folder, it will avoid to download it again :)  
- Launch the script from the command line:  
  `./PatchSynfig140.sh` (if already executable)  
  or   
  `bash ./PatchSynfig140.sh` (if you don't like chmod)  
- I would like to say "Prepare a :coffee:" but you will not have the time  

Have fun with Synfig, stay inside, wear a :mask: and take care :)
