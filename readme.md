This project is an on-going rewrite of Fallout Equestria: Remains (1.0.2) with a few goals in mind.

- Simplify and document the code.
- Optimize wherever possible.
- Un-Hardcode as much of the game as possible to allow easy modding.
- Remove the dependency on Adobe Animate to compile the source code.
- Use strongly typed code whenever possible.
- Allow much easier porting of the code to a different engine.

Features:
 
 - Portraits are loaded at runtime from loose images.
 - Tile textures are loaded at runtime from loose images.
 - Sky textures are loaded at runtime from loose images.
 - Game XML data is loaded at runtime.
 - Music loaded at runtime.
 - Sound effects loaded at runtime.
 - Weapon sprite offsets loaded at runtime.

 In-depth rambling: 

   Entities now have a Vector.<Number> for their coordinates and velocity.
   A lot of objects in this game have multiple properties, eg. {X: 0, Y: 0}.
   This makes math a but cumbersome since you have to do a lot more work potentially in different
   ways in different classes.
   Vector math lets us add these together or apply modifications in bulk.
   For example -- 
   
     x += dx;
     y += dy;
     
     Turns into...
     
     coords.sum(velocity);
   
   or
   
     var n:Number = Math.sqrt(x * x + y * y);

     Becomes...
   
     var n:Number = coords.magnitude();

   I'm hoping to use more and more of this vector based math (which CPUs love) for a good portion of
   the game's simplification and optimization.
   There's not a whole lot of compiler optimization happening with Actionsript 3, so the less overhead I
   can get from function calls (getting those properties from objects constantly) the better.
