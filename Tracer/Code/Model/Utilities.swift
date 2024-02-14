//
//  Utilities.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/5/24.
//

import SwiftUI

/**
 The Grid is the game board.  The reason it needs a Mode enum is because it plays three different roles:
 
 - **idle** mode allows the grid to provide background entertainment behind the main menu
 - **play** mode is the game itself
 - **jam** mode allows the player to jam on the game boafd like a musical instrument
 
 Because of this unconventional re-use of the primary game board, the structure of the app revolves around the ever-present GridView always doing *something* to create a consistent UX.
 */
enum GridMode {
    case idle
    case play
    case jam
}

enum TileActivationResult {
    case stillGoing
    case puzzleCompleted
    case mistakeMade
}

enum GridViewAnimationNeeded {
    case none
    case idleSequence
    case presentNewPuzzle
    case puzzleFailed
    case puzzleCompleted
    case levelCompleted
}

enum SequencePlaybackSpeed: Int {
    case slow
    case fast
    
    var duration: TimeInterval {
        switch self {
        case .slow: return DesignConstants.slowLightupDelay
        case .fast: return DesignConstants.fastLightupDelay
        }
    }
}

enum PuzzleComponent {
    case note
    case rest
}

enum Gesture: String {
    case tap
    case pan
}

/// The core struct upon which all gameplay and puzzle sequences are built
struct GridLoc: Equatable, Hashable {
    var x: Int
    var y: Int
    
    static var zero: GridLoc {
        return GridLoc(x: 0, y: 0)
    }
    
    static var rest: GridLoc {
        return GridLoc.zero
    }
    
    // A GridLoc is valid if it's within the bounds of the grid
    var isValid: Bool {
        return x >= 1 && y >= 1 && x <= DesignConstants.gridWidth && y <= DesignConstants.gridHeight
    }

    var isRest: Bool {
        return x == 0 && y == 0
    }
    
    var asString: String {
        if x == 0 && y == 0 {
            return "rest"
        }
        return "\(x),\(y)"
    }

    var soundFilename: String {
        let xValue = x == 5 ? "10" : "0" + String(x * 2)
        let yValue = "0" + String(DesignConstants.gridHeight + 1 - y)
        
        return "\(xValue)_\(yValue)"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func rando(_ rangeStart: Int, _ rangeEnd: Int) -> Int {
    Int.random(in: rangeStart...rangeEnd)
}

func gridLocSequenceAsString(_ sequence: GridLocSequence) -> String {
    if sequence.isEmpty {
        return "(empty)"
    }
    
    var debugStrings = [String]()
    for gridLoc in sequence {
        debugStrings.append(gridLoc.asString)
    }
    return debugStrings.joined(separator: " ")
}

class PanGestureRecognizerWithInitialLocation: UIPanGestureRecognizer {
    var panGestureDelegate: PanGestureDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        let pixelLoc = touches.first!.location(in: view)
        panGestureDelegate?.tileSelectedAsDelegate(forPixelLoc: pixelLoc, viaGesture: .pan)
    }
}

// MARK: - Debugging

var debuggingOn = false

/**
 Console debugging tool
 */
enum DebugMode {
    case controlFlow
    case sequenceGenerator
    case animation
    case swiftUIViews
    
    var isActive: Bool {
        switch self {
        case .controlFlow: return true
        case .sequenceGenerator: return false
        case .animation: return false
        case .swiftUIViews: return false
        }
    }
    
    var abbreviation: String {
        switch self {
        case .controlFlow: return "CF"
        case .sequenceGenerator: return "SG"
        case .animation: return "AN"
        case .swiftUIViews: return "UI"
        }
    }
}

/**
 UIKit/Foundation Debugging.

 All parameters are unnamed to prevent calls to debug() from exceding one line whenever possible.
 - **message**: The message to print to the console
 - **indent**: The number of indentations at which the message should appear in the console
 - **mode**: The sub-component(s) of the app that being debugged via one or more DebuggingMode.isActive being activated
 */
func debug(_ message: String,_ indent: Int,_ mode: DebugMode) {
    guard debuggingOn, mode.isActive else {
        return
    }
        
    var indentString = ""
    if indent > 0 {
        for _ in 1...indent {
            indentString += "    "
        }
    }
    
    print(mode.abbreviation + ": " + indentString + message)
}

// SwiftUI bridge to debug()
extension View {
    func debugFromSwiftUIView(_ message: String) -> Self {
        debug(message, 0, .swiftUIViews)
        return self
    }
}
