//
//  GameModel.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import Foundation

/// The business logic for the gameplay
class GameModel {
    func newSequence(forLevel level: Int, mostRecentStartingLoc: GridLoc) -> GridLocSequence {
        debug("GameModel: creating new sequence for level \(level) avoiding " +
              "\(mostRecentStartingLoc.asString)", 0, .sequenceGenerator)

        // Use the template corresponding to the current level. If we run out, keep re-using the one for the highest level.
        var templatesArrayLoc = (level > sequenceTemplates.count ? sequenceTemplates.count : level) - 1
        var forbiddenStartingLoc = mostRecentStartingLoc
        
        let generator = GridLocSequenceGenerator(
            forbiddenStartingLoc: forbiddenStartingLoc,
            template: sequenceTemplates[templatesArrayLoc]
        )
        
        if let sequence = generator.generatedSequence {
            return sequence
        } else {
            // If, heaven forbid, the template for the current level is too much for the sequence generator to handle,
            // revert back to the last template that worked, and loosen up the starting loc restriction...
            templatesArrayLoc -= 1
            forbiddenStartingLoc = GridLoc.zero
            
            let generator = GridLocSequenceGenerator(
                forbiddenStartingLoc: forbiddenStartingLoc,
                template: sequenceTemplates[templatesArrayLoc]
            )

            // ...and pray.
            return generator.generatedSequence!
        }
    }
        
    /// Determine how the player's activation of a tile affects the gameplay
    func result(forAttempt attempt: GridLocSequence, atSequence sequence: GridLocSequence) -> TileActivationResult {
        var attempt = attempt
        
        // Remove rests from the goal sequence, since the player can't (and shouldn't need to) input a rest
        let sequenceWithoutRests = sequence.filter {
            $0 != GridLoc.rest
        }

        // Truncate the attempt in case they traced past the end of the sequence to avoid out-of-range errors/confusion/mayhem
        if attempt.count > sequenceWithoutRests.count {
            for _ in 1...(attempt.count - sequenceWithoutRests.count) {
                attempt.removeLast()
            }
        }
        
        // If the attempt perfectly matches the sequence, they won!
        if attempt == sequenceWithoutRests {
            return .puzzleCompleted
        }
        
        // If there are any mistakes, it's game over
        for attemptNumber in 1...attempt.count {
            let index = attemptNumber - 1
            guard attempt[index] == sequenceWithoutRests[index] else {
                return .mistakeMade
            }
        }
        
        // Otherwise, let them keep going
        return .stillGoing
    }
}
