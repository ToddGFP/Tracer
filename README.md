# Tracer

Tracer is a Memory game for iOS written by Todd Gibbons with SwiftUI and UIKit.  The idea was conceived of by Brian Arizaga and Todd Gibbons in 2013.

This project is being published primarily as a portfolio piece for demonstrating my iOS development skills.  I hope this project inspires other game developers with its relatively simple architecture.  It is available on the iOS App Store <a href="https://apps.apple.com/us/app/tracer-a-memory-game/id6477837958">Here</a> and my full developer portfolio is available <a href="http://toddgibbons.com/apps">Here</a>.

Structural Notes:

    - Most of the view layer is written with SwiftUI.
    - GridView and TileView are implemented ub UIKit rather than SwiftUI to ensure optimum performance for the core game UX.
    - The GridView is repurposed as a musical instrument via Jam mode.
    - The GridView (housed in GameView) is used to show a background animation behind the main menu.  Because of its persistence, its view model GameViewModel drives the control flow of the entire app.
    - The GameModel uses GridLocSequenceGenerator to create the puzzles that drive the core gameplay.  GameModel is also responsible for parsing the player's input to determine how it affects the game progression.
    - A Unit Test ensures the puzzles are not too difficult to generate within the allotted number of tries allowed.
