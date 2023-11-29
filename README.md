# **Lenta Ground Ground**

# New features
- [x] Remove video control block
- [x] Remove parameters indicator block
- [x] Add roll bar
- [x] Add pitch bar
- [x] Add heading bar
- [x] Add toolbar to the left of the screen
- [x] Change all fonts to "Comic Sans MS"
  

# Old features
- [x] Move video control block to bottom right
- [x] Create a red flashing circle when a video is being recorded
- [x] Remove the 3 buttons on top left of main screen
- [x] Remove roll, pitch and heading instrument on the top right
- [x] Say 'Welcome Lenta Marine' when the program is ready to be used
- [x] Make a custom toolbar
- [x] Change messages icon to custom icon
- [x] Change any original logo to Pyrot logo
- [x] Change app name to Lenta Ground Control Station.
- [x] Change app icon to Lenta Marine logo.  
- [x] 3 Extra livestream preview.


# Steps to build
1. Clone the repository:
   ```
   git clone https://github.com/joeshawky/Lenta-Ground-Control.git
   ```
   
2. Enter the folder:
   ```
   cd lenta-ground-control
   ```
3. Update dependencies by running the shell script update_dependencies:
    ```
    ./update_dependencies.sh
    ```
4. Launch QtCreator and launch project via selecting qgroundcontrol.pro

    <img src="./doc/qtCreatorTutorial.png">

