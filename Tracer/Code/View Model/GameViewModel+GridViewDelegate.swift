//
//  GameViewModel+GridViewDelegate.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/5/24.
//

import Foundation

/// Enable the GridView to notify the GameViewModel of user interaction and sequence playback completion.
protocol GridViewDelegate: AnyObject {
    func userDidActivateSquare(at gridLoc: GridLoc)
    func didCompleteAnimation()
    func currentGameLevel() -> Int
}

extension GameViewModel: GridViewDelegate {
    /// Respond to the activation of a TileView based on how it affects the progress of the game.
    func userDidActivateSquare(at gridLoc: GridLoc) {
        guard gridMode == .play else {
            return
        }
        
        currentAttempt.append(gridLoc)
        let result = gameModel.result(forAttempt: currentAttempt, atSequence: currentSequence)
        debug("GridViewDelegate: didActivateSquare(\(gridLoc.asString)) with result \(result)", 0, .controlFlow)

        switch result {
        case .stillGoing:
            break
        case .puzzleCompleted:
            gridViewAnimationNeeded = .puzzleCompleted
        case .mistakeMade:
            showEndGameAnimation()
        }
    }
    
    func didCompleteAnimation() {
        let newlyCompletedAnimation = gridViewAnimationNeeded
        gridViewAnimationNeeded = .none
        debug("GridViewDelegate: didCompleteAnimation(\(newlyCompletedAnimation))", 0, .controlFlow)
        
        switch newlyCompletedAnimation {
        case .none:                       
            break
        case .idleSequence:               
            showIdleAnimationSequence()
        case .presentNewPuzzle:          
            break
        case .puzzleFailed:
            endGame()
        case .puzzleCompleted:
            advanceToNextPuzzle()
        case .levelCompleted:
            startNewLevel()
        }
    }
    
    func currentGameLevel() -> Int {
        return currentLevel
    }
}

