//
//  GameViewModel.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import Foundation
import Combine

typealias GridLocSequence = [GridLoc]
typealias GridLocSet = Set<GridLoc>

class GameViewModel: ObservableObject {
    var gameModel = GameModel()

    // State tracking for external view showing/hiding
    @Published var gridMode: GridMode = .idle
    @Published var isLevelStartViewVisible: Bool = false
    @Published var isGameOverViewVisibile: Bool = false
    @Published var gridViewAnimationNeeded: GridViewAnimationNeeded = .idleSequence
    
    // State tracking for each game playthrough
    var currentLevel: Int = 1
    var currentSubLevel: Int = 0
    var currentSequence = GridLocSequence()
    var currentAttempt = GridLocSequence()
    var mostRecentStartingLoc = GridLoc.zero
    
    func enterJamMode() {
        gridMode = .jam
    }
        
    func resetPlayThroughState() {
        debug("GameViewModel: resetPlayThroughState()", 0, .controlFlow)
        
        currentLevel = 1
        currentSubLevel = 1
        currentSequence = GridLocSequence()
        currentAttempt = GridLocSequence()
        mostRecentStartingLoc = GridLoc.zero
    }
    
    func startNewGame() {
        debug("GameViewModel: startNewGame()", 0, .controlFlow)
        
        gridMode = .play
        resetPlayThroughState()
        startNewLevel()
    }
        
    func startNewLevel() {
        debug("GameViewModel: startNewLevel()", 0, .controlFlow)
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.delayBetweenWindowsAndAction) {
            self.isLevelStartViewVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.newLevelDisplayDuration) {
                self.isLevelStartViewVisible = false
                DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.delayBetweenWindowsAndAction) {
                    self.startSubLevel()
                }
            }
        }
    }

    func startSubLevel() {
        mostRecentStartingLoc = currentSequence.count > 0 ? currentSequence[0] : GridLoc.zero
        currentSequence = gameModel.newSequence(forLevel: currentLevel, mostRecentStartingLoc: mostRecentStartingLoc)
        currentAttempt = GridLocSequence()

        debug("GameViewModel: startSubLevel with sequence: \(gridLocSequenceAsString(currentSequence))", 0, .controlFlow)
        
        gridViewAnimationNeeded = .presentNewPuzzle
    }
    
    func advanceToNextPuzzle() {
        debug("GameViewModel: advanceToNextPuzzle()", 0, .controlFlow)
        
        currentSubLevel += 1
        
        if currentSubLevel > DesignConstants.subLevelsPerLevel {
            currentLevel += 1
            currentSubLevel = 1
            gridViewAnimationNeeded = .levelCompleted
        } else {
            startSubLevel()
        }
    }
    
    func showEndGameAnimation() {
        debug("GameViewModel: showEndGameAnimation()", 0, .controlFlow)
        
        gridViewAnimationNeeded = .puzzleFailed
    }
    
    func endGame() {
        debug("GameViewModel: endGame()", 0, .controlFlow)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.delayBetweenWindowsAndAction) {
            self.isGameOverViewVisibile = true
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.gameOverDisplayDuration) {
                self.isGameOverViewVisibile = false
                DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.delayBetweenWindowsAndAction) {
                    self.gridMode = .idle
                    self.showIdleAnimationSequence()
                }
            }
        }
    }
    
    func showIdleAnimationSequence() {
        currentSequence = gameModel.newSequence(forLevel: 2, mostRecentStartingLoc: GridLoc.zero)
        
        debug("GameViewModel: startIdleAnimation() sequence: \(gridLocSequenceAsString(currentSequence))", 0, .controlFlow)
        
        if gridMode == .idle {
            self.gridViewAnimationNeeded = .idleSequence
        }
    }

    func addNewIdleAnimationToQueue(withPriorDuration: TimeInterval) {
        debug("GameViewModel: addNewIdleAnimationToQueue()", 0, .controlFlow)
        
        var pattern = [PuzzleComponent]()
        let sequenceLength = Int.random(in: 5...8)
        
        for _ in 1...sequenceLength {
            pattern.append(.note)
        }
    }
}
