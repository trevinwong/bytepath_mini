# Deletes old versions, generates a new .love file, drops it into my local love-android-sdl2 repo, and renames it appropriately.
# Makes Android builds a lot easier.
rm ../love-android-sdl2/app/src/main/assets/game.love
zip -r ../love-android-sdl2/app/src/main/assets/game.love * -x *.git*


