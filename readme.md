# Vigilant Octo Doodle

This is vigilant octo doodle.

# Dev notes
- Player to enemy collisions on layer 1 kinematic2D collisions
- weapon to enemy collisions on layer 2 masked only for weapon to enemy. Weapon as Node2D detects the collision and calls take damage on enemy if available.
- Firing origin location offset added to knife so it wont float with player
- Waves/levels defined in json format. either as ```recurring``` type or ```oneshot```. Details on key val pairs in example level [grassy.json](scenes/spawner/levels/grassy.json) 

