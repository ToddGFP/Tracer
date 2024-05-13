<!--<img src="https://github.com/ToddGFP/Tracer/blob/main/icon.png" width=150 alt="App Icon">-->
<img src="https://github.com/ToddGFP/Tracer/blob/main/Tracer/Assets.xcassets/AppIcon.appiconset/icon-1024.png" width=128 alt="App Icon">

# Tracer

Tracer is a Memory game for iOS written by Todd Gibbons using Swift, SwiftUI, Combine and UIKit.  I hope this project is helpful to other game developers as an example of a simple implementation of MVVM.  Tracer is available on the iOS App Store <a href="https://apps.apple.com/us/app/tracer-a-memory-game/id6477837958">Here</a>.<!-- and my developer portfolio is available <a href="http://toddgibbons.com/apps">Here</a>.-->

**Notes:**

- Most of the view layer is written in SwiftUI.
- `GridView` and `TileView` are implemented in UIKit to ensure optimum performance for the core game UX.
- The GridView is used both for the core gameplay and to show a background animation behind the main menu. Because of its persistence, its view model (`GameViewModel`) drives the control flow for the entire app.
- The `GameModel` handles parsing the player's input to determine how it affects gameplay.
- `GameModel` uses `GridLocSequenceGenerator` to create the puzzles that drive the core gameplay. 
- A Unit Test ensures the puzzles are not too difficult for `GridLocSequenceGenerator` to generate within the allotted number of attempts.
- The `GridView` is repurposed for use as a musical instrument via "Jam Mode."
