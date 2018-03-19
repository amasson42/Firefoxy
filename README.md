# Firefoxy

This project is a small test to use GameplayKit and new things from SceneKit with OS 10.13

The game is actually cross-plateform for iOS and macOS but using spell are only possible on macOS :
Q - launch fireball to cursor
W - whirlwind
E - jump to cursor

Here is the GameplayKit features we're using :

- Entity-Component System :
  In the shared-plateform directory, we have a Game group wich contains all the Entities ans the Components of the game
  Entity has a main class GameEntity wich describe the main Components every entities from the game must have. We have 3 Concrete entities: Fox (main character), FireEnemy (fire rocks floating around) and Spells
- Agent-Behavior :
  Every GameEntity have an agent component. We can then give them behavior...
- State Machine :
  the UnitCoreComponent has a stateMachine so switch between every kind of state a unit can be. They're in the file UnitStates.swift
