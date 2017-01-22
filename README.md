# ggj17

## How to use Better Collada Exporter in Blender
Copy the folder **io_scene_dae** from https://github.com/godotengine/collada-exporter to $(HOME)/.config/blender/$(VERSION)/scripts/addons and enable the plugin in blender (File -> User Preferences -> Search for "Collada" and activate the plugin -> Save User Settings).

## How to compile
Create a symbolic link from the `sphericalWaves` folder in the project you cloned to your cloned `godot/modules` folder, e.g. with `ln -s /home/$user/ggj17/sphericalWaves/ ../godot/modules/` on Linux (the first must be an absolute path!). Otherwise follow https://godot.readthedocs.io/en/latest/reference/compiling_for_x11.html to compile Godot (e.g. install `scons`, `clang` and `pkg-config`, compile with `scons platform=x11 use_llvm=yes -j2 pulseaudio=no`).


## How to export for Linux
Compile the project using the additional option `tools=no` and `target=release`, e.g. `scons platform=x11 use_llvm=yes -j2 pulseaudio=no target=release tools=no`. Move the generated file to `/home/$user/.godot/templates/` and rename it to `linux_x11_64_release`, see [here](https://godot.readthedocs.io/en/stable/reference/compiling_for_x11.html).
Link to this file in Godot Export -> Linux X11 -> Debug, click Export..., type a name and export it to a different folder than the projects' folder. As soon as you allow execution you should have a binary ready running the game.
