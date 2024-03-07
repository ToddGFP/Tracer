//
//  GridLocSequenceGenerator.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/6/24.
//

import Foundation

/**
 Produce the puzzle sequences that make up the core of the game.
 
 This class is essentially a stand-alone puzzle generator with multiple tiers of abstraction to its algorithm, each denoted with a pragma MARK in this file.
 
 - `generatedSequence` is the top tier of the algorithm and the only public API call.
 - `generateSubSequence()` is the next tier down in complexity, each sub sequence delimited from the others with rests.
 - The `candidates...` functions are the next tier down, implementing the details of sub-sequence generation.
 - Finally, a fourth tier of helper functions supports the `candidate` functions'.
 
 It is theoretically possible to create entries in `sequenceTemplates` that are impossible for the algorithm to solve in the allotted max number of tries denoted in `Constants.swift`.  
 
 A unit test called `testSequenceGenerationForTemplates` is intended to solve that problem by making sure the sequence gneeration never fails in this way, performing multiple test runs to see if it ever breaks.
 */
class GridLocSequenceGenerator {
    var forbiddenStartingLoc: GridLoc
    var template: [Int]
    var subSequences: [GridLocSequence]
    
    init(forbiddenStartingLoc: GridLoc, template: [Int]) {
        self.forbiddenStartingLoc = forbiddenStartingLoc
        self.template = template
        self.subSequences = [GridLocSequence]()
    }

    // MARK: - Top-level sequence generation
    
    /**
     This is the one public call in the API for generating sequences.  You just call this and you're done.
     
     Returns nil if it was impossible to generate the sequence after x tries indicating an overly-demanding template.
     */
    var generatedSequence: GridLocSequence? {
        debug("Generating puzzle for template \(template)", 0, .sequenceGenerator)
        
        var isFirstSubSequence = true
        for subSequenceLength in template {
            debug("Preparing to attempt generating sub-sequence of length \(subSequenceLength)", 1, .sequenceGenerator)
            var attempts = 1
            
            while attempts <= DesignConstants.attemptsToGiveSubSequenceGenerator {
                debug("Starting attempt #\(attempts) for this sub-sequence", 2, .sequenceGenerator)
                
                if generateSubSequence(ofLength: subSequenceLength, isFirstSubSequence: isFirstSubSequence) {
                    isFirstSubSequence = false
                    attempts = 1
                    debug("Generated sub-sequence: \(gridLocSequenceAsString(subSequences.last!))", 3, .sequenceGenerator)
                    break
                } else {
                    debug("Failed to generate sequence!", 3, .sequenceGenerator)
                    attempts += 1
                    continue
                }
            }
            // This means one of the sub-sequences failed enough times that the puzzle constants need to be tweaked
            if attempts >= DesignConstants.attemptsToGiveSubSequenceGenerator {
                assertionFailure("Puzzle was impossible to generate! Mayday!!")
                return nil
            }
        }
        // Getting here means the sequence was successfully generated within the allotted number of tries
        return sequenceWithRests
    }
        
    // MARK: - Second-tier sub-sequence generation

    /// Returns false if it was impossible to generate any part of the sub-sequence, otherise returns true
    private func generateSubSequence(ofLength length: Int, isFirstSubSequence: Bool) -> Bool {
        var isFirstGridLocInSubSequence = true
        debug("Generating sub-sequence of length \(length)", 3, .sequenceGenerator)
        
        for gridLocNumber in 1...length {
            debug("Generating gridLocNumber \(gridLocNumber) in sub-sequence", 4, .sequenceGenerator)
            
            if isFirstGridLocInSubSequence {
                if isFirstSubSequence {
                    let gridLoc = randomPick(fromGridLocSet: candidatesForFirstLocInOverallSequence)
                    debug("Added \(gridLoc.asString) as first entry in first sub-sequence", 5, .sequenceGenerator)
                    addToNewSubSequence(gridLoc)
                } else {
                    debug("Attempting to add first entry in non-first sub-sequence", 5, .sequenceGenerator)
                    
                    if let candidates = candidatesForFirstLocInSubSequence {
                        debug("Found \(candidates.count) candidates", 6, .sequenceGenerator)
                        let gridLoc = randomPick(fromGridLocSet: candidates)
                        debug("Added \(gridLoc.asString)", 6, .sequenceGenerator)
                        addToNewSubSequence(gridLoc)
                    } else {
                        debug("Failed to find any candidates", 6, .sequenceGenerator)
                        return false
                    }
                }
                isFirstGridLocInSubSequence = false
            } else {
                debug("Attempting to add non-first entry in sub-sequence", 5, .sequenceGenerator)
                
                if let currentSubSequence = subSequences.last, let lastAddedGridLoc = currentSubSequence.last {
                    if let candidates = candidatesForNextSquareInSubSequence(following: lastAddedGridLoc) {
                        debug("Found \(candidates.count) candidates orthogonally adjacent to " +
                              lastAddedGridLoc.asString, 6, .sequenceGenerator)
                        let gridLoc = randomPick(fromGridLocSet: candidates)
                        debug("Added \(gridLoc.asString)", 6, .sequenceGenerator)
                        addToExistingSubSequence(gridLoc)
                    } else {
                        debug("Failed to find any candidates", 6, .sequenceGenerator)
                        return false
                    }
                } else {
                    assertionFailure("The subsequent generator got called first for some reason")
                }
            }
        }
        return true
    }
    
    private func addToNewSubSequence(_ gridLoc: GridLoc) {
        var newSubSequence = GridLocSequence()
        newSubSequence.append(gridLoc)
        subSequences.append(newSubSequence)
    }
    
    private func addToExistingSubSequence(_ gridLoc: GridLoc) {
        guard var lastSubSequence = subSequences.last else {
            return assertionFailure("Tried to modify non-existant sub-sequence")
        }
        lastSubSequence.append(gridLoc)
        subSequences.removeLast()
        subSequences.append(lastSubSequence)
    }

    /// Concatenate the sub-sequences into the final sequence, concatenated with 'rests' that generate pauses during playback
    private var sequenceWithRests: GridLocSequence {
        var allGridLocs = GridLocSequence()

        for subSequence in subSequences {
            for gridLoc in subSequence {
                allGridLocs.append(gridLoc)
            }
            // Add a 'rest'
            allGridLocs.append(GridLoc.rest)
        }
        
        // Remove the extra rest at the end
        allGridLocs.removeLast()
        debug("Newly-generated sequence: " + gridLocSequenceAsString(allGridLocs), 0, .sequenceGenerator)
        
        return allGridLocs
    }

    // MARK: - Third-tier candidate grid loc generators for the three use cases encountered in sub-sequence generation
    
    private var candidatesForFirstLocInOverallSequence: GridLocSet {
        var candidates = allGridLocs
        
        // Avoid accidentally triggering OS-level swipe gestures from screen edges
        candidates.subtract(gridLocsAtEdgesOfScreen)
        
        // Avoid repeating same starting position as last sequence
        candidates.remove(forbiddenStartingLoc)
        
        return candidates
    }
    
    private var candidatesForFirstLocInSubSequence: GridLocSet? {
        guard let lastAddedGridLoc = lastLocAddedToLastSubSequence else {
            assertionFailure("This method was mis-used")
            return nil
        }
        
        // Sub-sequences after the first should start two squares from the last square of the prior sequence to let it breathe
        guard var candidates = gridLocsTwoSquares(fromGridLoc: lastAddedGridLoc) else {
            return nil
        }
                
        // Avoid accidentally triggering OS-level swipe gestures from screen edges
        candidates.subtract(gridLocsAtEdgesOfScreen)
        
        // Avoid repeating anything already in the sequence
        candidates.subtract(allGridLocsInSequence)
        
        return candidates.isEmpty ? nil : candidates
    }

    private func candidatesForNextSquareInSubSequence(following lastAddedGridLoc: GridLoc) -> GridLocSet? {
        // Must be orthogonally adjacent to last loc in sub-sequence (not diagonally)
        if var candidates = gridLocsOrthogonallyAdjacent(toGridLoc: lastAddedGridLoc) {
            
            // Avoid repeating anything already in the sequence
            candidates.subtract(allGridLocsInSequence)
            
            if candidates.isEmpty {
                return nil
            }
            return candidates
        } else {
            return nil
        }
    }
    
    // MARK: - Fourth-tier derived vars and funcs for supporting the candidate generators
        
    private var allGridLocsInSequence: GridLocSet {
        var gridLocSet = GridLocSet()
        
        for subSequence in subSequences {
            for gridLoc in subSequence {
                gridLocSet.insert(gridLoc)
            }
        }
        
        return gridLocSet
    }

    private var allGridLocs: GridLocSet {
        var gridLocSet = GridLocSet()
        
        for x in 1...DesignConstants.gridWidth {
            for y in 1...DesignConstants.gridHeight {
                gridLocSet.insert(GridLoc(x: x, y: y))
            }
        }
        
        return gridLocSet
    }
        
    private var gridLocsAtEdgesOfScreen: GridLocSet {
        var gridLocSet = GridLocSet()
        
        for x in 1...DesignConstants.gridWidth {
            gridLocSet.insert(GridLoc(x: x, y: 1))
            gridLocSet.insert(GridLoc(x: x, y: DesignConstants.gridHeight))
        }
        
        for y in 1...DesignConstants.gridHeight {
            gridLocSet.insert(GridLoc(x: 1, y: y))
            gridLocSet.insert(GridLoc(x: DesignConstants.gridWidth, y: y))
        }

        return gridLocSet
    }
    
    private var lastLocAddedToLastSubSequence: GridLoc? {
        guard let lastSubSequence = subSequences.last,
              let lastGridLoc = lastSubSequence.last else {
            return nil
        }
        
        return lastGridLoc
    }
        
    private func gridLocsAdjacent(toGridLoc originalGridLoc: GridLoc) -> GridLocSet {
        var gridLocSet = GridLocSet()

        for x in originalGridLoc.x - 1...originalGridLoc.x + 1 {
            for y in originalGridLoc.y - 1...originalGridLoc.y + 1 {
                let candidateGridLoc = GridLoc(x: x, y: y)
                
                if candidateGridLoc != originalGridLoc {
                    gridLocSet.insert(candidateGridLoc)
                }
            }
        }
        
        // This can safely be force-unwrapped because there is always at least one valid adjacent grid loc
        return validGridLocs(inSet: gridLocSet)!
    }
    
    private func gridLocsOrthogonallyAdjacent(toGridLoc originalGridLoc: GridLoc) -> GridLocSet? {
        var gridLocSet = GridLocSet()
        
        let orthogonalNeighbors: GridLocSequence = [
            GridLoc(x: originalGridLoc.x - 1, y: originalGridLoc.y),
            GridLoc(x: originalGridLoc.x + 1, y: originalGridLoc.y),
            GridLoc(x: originalGridLoc.x, y: originalGridLoc.y - 1),
            GridLoc(x: originalGridLoc.x, y: originalGridLoc.y + 1),
        ]
        
        for neighbor in orthogonalNeighbors {
            if neighbor.isValid {
                gridLocSet.insert(neighbor)
            }
        }
        
        return validGridLocs(inSet: gridLocSet)
    }
    
    private func gridLocsTwoSquares(fromGridLoc originalGridLoc: GridLoc) -> GridLocSet? {
        var gridLocSet = GridLocSet()

        for count in -2...2 {
            gridLocSet.insert(GridLoc(x: originalGridLoc.x + count, y: originalGridLoc.y + 2))
            gridLocSet.insert(GridLoc(x: originalGridLoc.x + count, y: originalGridLoc.y - 2))
            gridLocSet.insert(GridLoc(x: originalGridLoc.x + 2, y: originalGridLoc.y + count))
            gridLocSet.insert(GridLoc(x: originalGridLoc.x - 2, y: originalGridLoc.y + count))
        }
        
        return validGridLocs(inSet: gridLocSet)
    }
    
    private func validGridLocs(inSet gridLocSet: GridLocSet) -> GridLocSet? {
        var validGridLocSet = GridLocSet()
        
        for gridLoc in gridLocSet {
            if gridLoc.isValid {
                validGridLocSet.insert(gridLoc)
            }
        }
        
        return validGridLocSet
    }
    
    private func randomPick(fromGridLocSet locSet: GridLocSet) -> GridLoc {
        let locArray = Array(locSet)
        let arrayLoc = rando(0, locArray.count - 1)
        
        return locArray[arrayLoc]
    }
}
