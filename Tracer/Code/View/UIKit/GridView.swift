//
//  GridView.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import UIKit
import AVFoundation

/**
 Builds a grid comprised of TileViews to act as the Tracer game board.
 
 Tap and pan gestures accept user input across the entire board which, after eliminating redundant events, trigger TileViews to produce visual and audio feedback for the selected tile.

 `GridView` has three different `gridMode` settings that allow the view to be repurposed for three contexts:
 
 - **idle** mode allows the grid to serve as a background decoration behind the main menu
 - **play** mode is the game itself
 - **jam** mode allows the player to jam on the game board like a musical instrument
 
 Because of this unconventional re-use of the primary game view, the structure of the app largely revolves around `GridView` and its `gridMode` property.
*/
class GridView: UIView {
    var tiles = [TileView]()
    var audioPlayers = [AVAudioPlayer]()
    var playerLoc = 0
    var gridViewDelegate: GridViewDelegate?
    var gestureRecognizersSetup = false
    var mostRecentGesture: Gesture?
    var mostRecentSelectedGridLoc = GridLoc.zero
    var tileSize: CGFloat
    var previousFrameSize: CGSize = CGSize.zero
    weak var delegate: GridViewDelegate?

    var gridMode: GridMode = .idle {
        didSet {
            debug("GridView: mode changed to \(gridMode) with alpha at \(alpha)", 0, .controlFlow)
            
            switch gridMode {
            case .idle: 
                disableUserInteraction()
                if alpha > DesignConstants.gridViewFadedAlphaValue {
                    fadeOutEntireView()
                }
            case .jam:
                enableUserInteraction()
                if alpha < 1 {
                    fadeInEntireView()
                }
            case .play:
                if delegate!.currentGameLevel() == 1 {
                    updateColors(forLevel: delegate!.currentGameLevel())
                }
                if alpha < 1 {
                    fadeInEntireView()
                }
            }
        }
    }
    
    init(tileSize: CGFloat) {
        self.tileSize = tileSize
        super.init(frame: .zero)
        backgroundColor = backgroundColor(forLevel: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        removeTiles()
        layoutTiles()
        setupGestureRecognizers()
    }
    
    func gridLoc(forPixelLoc pixelLoc: CGPoint) -> GridLoc? {
        let gutterSize = DesignConstants.gutterSize
        
        // Check for (literal) edge cases
        guard pixelLoc.x >= gutterSize && pixelLoc.x <= bounds.size.width  - gutterSize,
              pixelLoc.y >= gutterSize && pixelLoc.y <= bounds.size.height - gutterSize else {
            return nil
        }
        
        let tileWithGutterSize = tileSize + gutterSize
        let gridX = Int(((pixelLoc.x - gutterSize) / tileWithGutterSize) + 1)
        let gridY = Int(((pixelLoc.y - gutterSize) / tileWithGutterSize) + 1)
        
        return GridLoc(x: gridX, y: gridY)
    }
}
