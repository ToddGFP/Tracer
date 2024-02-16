<img src="https://github.com/ToddGFP/Tracer/blob/main/Tracer/Assets.xcassets/AppIcon.appiconset/icon-1024.png" width=128 alt="App Icon">

# Tracer

Tracer is a Memory game for iOS written by Todd Gibbons with SwiftUI, Combine and UIKit.  The idea was first conceived by Brian Arizaga and Todd Gibbons in 2013.

This project is being published primarily as a portfolio piece for demonstrating my iOS development skills.  I hope this project inspires other game developers with its relatively simple structure.  It is available on the iOS App Store <a href="https://apps.apple.com/us/app/tracer-a-memory-game/id6477837958">Here</a> and my developer portfolio is available <a href="http://toddgibbons.com/apps">Here</a>.

**Structural Notes:**

- Most of the view layer is written with SwiftUI.
- GridView and TileView are implemented ub UIKit to ensure optimum performance for the core game UX.
- The GridView is repurposed as a musical instrument via Jam mode.
- The GridView is used to show a background animation behind the main menu.  Because of that view's persistence, The game's view model (GameViewModel) drives the control flow for the entire app.
- The GameModel uses GridLocSequenceGenerator to create the puzzles that drive the core gameplay.  GameModel is also responsible for parsing the player's input to determine how it affects game progression.
- A Unit Test ensures the puzzles are not too difficult to generate within the allotted number of tries.
