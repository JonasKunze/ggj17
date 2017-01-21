https://etherpad.wikimedia.org/p/AwesomeWaveJump
# ggj17

## How to use Better Collada Exporter in Blender
Copy the folder **io_scene_dae** from https://github.com/godotengine/collada-exporter to $(HOME)/.config/blender/$(VERSION)/scripts/addons and enable the plugin in blender (File -> User Preferences -> Search for "Collada" and activate the plugin -> Save User Settings).

## How to compile
Create a symbolic link from the `sphericalWaves` folder in the project you cloned to your cloned `godot/modules` folder, e.g. with `ln -s /home/$user/ggj17/sphericalWaves/ ../godot/modules/` on Linux (the first must be an absolute path!). Otherwise follow https://godot.readthedocs.io/en/latest/reference/compiling_for_x11.html to compile Godot (e.g. install `scons`, `clang` and `pkg-config`, compile with `scons platform=x11 use_llvm=yes -j2 pulseaudio=no`).
