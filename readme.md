This project is an on-going rewrite of the source code for Fallout Equestria: Remains (1.0.2).

\#####

Contributors:

 Woons - Developer
 
\#####

Goals:
- Simplify and document the code.
- Optimize wherever possible.
- Un-Hardcode as much of the game as possible to allow easy modding.
- Remove the dependency on Adobe Animate to compile the source code.
- Use strongly typed code whenever possible to allow much easier porting of the code to a different engine.

\#####

Implemented features: 
 - Portraits are loaded at runtime from loose images.
 - Tile textures are loaded at runtime from loose images.
 - Sky textures are loaded at runtime from loose images.
 - Game data is loaded at runtime.
 - Sound effects loaded at runtime.
 - Weapon sprite offsets loaded at runtime.

\#####

Wip:
 - Load spritesheets and animation data at runtime.
 - Load background items at runtime.
 - Load in-game items/objects at runtime.
 - Add ability to easily create new tiles.
 - Real inventories and items instead of global values
 - Weapons are all separate, unique, easy to understand items
 - Localizations simplified, no more using multiple strings for a single key

\#####