//
//  GridView+Animations.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/5/24.
//

import UIKit

extension GridView {
    func fadeOutEntireView() {
        UIView.animate(withDuration: DesignConstants.gridViewFadeInDuration) {
            self.alpha = DesignConstants.gridViewFadedAlphaValue
        }
    }
    
    func fadeInEntireView() {
        UIView.animate(withDuration: DesignConstants.gridViewFadeInDuration) {
            self.alpha = 1.0
        }
    }
    
    /**
     Queue up asynchronous UIView animations for the given sequence of tiles and return the duration of the animation.
     */
    func presentSequence(_ sequence: GridLocSequence, speed: SequencePlaybackSpeed, withSound: Bool, isIdle: Bool) {
        debug("GridView: presentSequence(\(sequence))", 0, .animation)
        
        disableUserInteraction()

        var duration: TimeInterval = DesignConstants.squareFadeDuration
        
        for gridLoc in sequence {
            if gridLoc != GridLoc.rest {
                activateTile(
                    forGridLoc: gridLoc,
                    afterDelay: duration,
                    withSound: withSound,
                    fromUserInput: false,
                    fromIdle: isIdle
                )
            }
            // Rests are implicitly implemented by incrementing the duration in the absence of a new note
            duration += speed.duration
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // If the mode has changed from idle since being called, cancel the animation early.
            if isIdle {
                if self.gridMode != .idle {
                    debug("presentSequence: Idle sequence exited early due to mode change to \(self.gridMode)", 1, .animation)
                    self.enableUserInteraction()
                    return
                } else {
                    debug("presentSequence: Idle sequence continuing", 1, .animation)
                }
            }
            
            // TODO: This relies on `speed` to identify the 'failure' animation- should be more explicit.
            if speed == .fast {
                self.disableUserInteraction()
            } else {
                self.enableUserInteraction()
            }
            self.delegate?.didCompleteAnimation()
        }
    }
    
    /**
     Tell a TileView to light up and make some noise, then use delegation to have the GameViewModel react accordingly based on its knowledge of the current game state.
     */
    func activateTile(
        forGridLoc gridLoc: GridLoc,
        afterDelay delay: TimeInterval,
        withSound: Bool,
        fromUserInput: Bool,
        fromIdle: Bool
    ) {
        if fromIdle && self.gridMode != .idle {
            debug("activateTile: Idle sequence exited early due to mode change to \(self.gridMode)", 2, .animation)
            return
        }
        debug("activateTile: Idle sequence continuing", 2, .animation)

        let tile = tileView(forGridLoc: gridLoc)
        tile.lightUpAndFadeOut(true, afterDelay: delay)
        
        if withSound {
            tile.playSound(afterDelay: delay)
        }
        
        if fromUserInput {
            guard delay == 0 else {
                return assertionFailure("There should be no delay when activating a tile via user input")
            }
            delegate?.userDidActivateSquare(at: gridLoc)
        }
    }
          
    func presentPuzzleSolvedAnimation(forLevel level: Int) {
        debug("GridView: presentPuzzleSolvedAnimation(forLevel: \(level))", 0, .controlFlow)
        
        UIView.animate(withDuration: DesignConstants.subLevelVictoryFadeInDuration, animations: {
            self.backgroundColor = .white
        }, completion: { _ in
            UIView.animate(withDuration: DesignConstants.subLevelVictoryFadeOutDuration, animations: {
                self.updateBackgroundColor(forLevel: level)
            }, completion: { _ in
                self.delegate?.didCompleteAnimation()
            })
        })
    }
    
    func presentLevelCompletedAnimation(forLevel level: Int) {
        debug("GridView: presentLevelCompletedAnimation(forLevel: \(level))", 0, .controlFlow)
        
        UIView.animate(withDuration: DesignConstants.levelVictoryFadeInDuration, animations: {
            self.fadeTilesOut()
        }, completion: { _ in
            self.updateColors(forLevel: level)
            UIView.animate(withDuration: DesignConstants.levelVictoryFadeOutDuration, animations: {
                self.fadeTilesIn()
            }, completion: { _ in
                self.delegate?.didCompleteAnimation()
            })
        })
    }
    
    func fadeTilesOut() {
        for tile in self.tiles {
            tile.alpha = 0
        }
    }
    
    func fadeTilesIn() {
        for tile in self.tiles {
            tile.alpha = 1
        }
    }
}
