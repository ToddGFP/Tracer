//
//  Constants.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/5/24.
//

import UIKit
import SwiftUI

/**
 Each member of this array determines the seeds that form the puzzle for one level of the game.  For each level, each Int in its sub-array determines the number of adjacent tiles that will be randomly derived as a *sub-sequence* of the level's puzzle.  A pause or 'rest' is automatically inserted between sub-sequences.  The series of sequences are designed to present increasing challenges and interesting rhythms.
 */
var sequenceTemplates: [[Int]] = [
    [3],
    [5],
    [7],
    [1, 3],
    [3, 5],
    [5, 7],
    [1, 3, 3],
    [5, 3, 3],
    [3, 3, 7],
    [3, 3, 3, 1],
    [5, 5, 5, 5],
    [5, 5, 1, 9],
    [5, 5, 1, 3, 5],
    [1, 3, 5, 1, 3, 1]
]

struct DesignConstants {
    // App-Level
    static let enableIdleAnimation: Bool = true
    static let subLevelsPerLevel: Int = 3
    static let attemptsToGiveSubSequenceGenerator: Int = 5
    static let audioPlayersPerTile: Int = 2

    // Grid View
    static let gridWidth: Int = 5
    static let gridHeight: Int = 9
    static let gutterSize: CGFloat = 1.0
    static let gridViewFadedAlphaValue: CGFloat = 0.5
    static let gridViewFadeInDuration: TimeInterval = 0.2
    
    // Overlay Window Appearance
    static let overlayWindowOpacity: CGFloat = 0.44
    static let overlayWindowCornerRadius: CGFloat = 8.0
    static let overlayWindowBorderWidth: CGFloat = 2.0
    static let overlayWindowBorderColor: Color = .yellow
    static let overlayWindowFadeInDuration: TimeInterval = 0.8
    static let overlayWindowFadeOutDuration: TimeInterval = 0.5 // Fade-outs currently not functioning
    static let newLevelDisplayDuration: TimeInterval = 1.8
    static let gameOverDisplayDuration: TimeInterval = 2.8
    static let delayBetweenWindowsAndAction: TimeInterval = 0.33

    // Overlay Window Animations
    static let overlayIngressStiffness: Double = 100
    static let overlayIngressDamping: Double = 100
    static let overlayIngressScale: CGFloat = 1.12
    static let overlayEgressStiffness: Double = 90
    static let overlayEgressDamping: Double = 90
    static let overlayEgressDelay: CGFloat = 0.02
    static let overlayEgressScale: CGFloat = 1.0
    
    // In-Game Animations
    static let squareFadeDuration: TimeInterval = 0.44
    static let slowLightupDelay: TimeInterval = 0.2
    static let fastLightupDelay: TimeInterval = 0.14
    static let subLevelVictoryFadeInDuration: TimeInterval = 0.5
    static let subLevelVictoryFadeOutDuration: TimeInterval = 0.3
    static let subLevelCompletionAnimationDuration =  subLevelVictoryFadeInDuration + subLevelVictoryFadeOutDuration
    static let levelVictoryFadeInDuration: TimeInterval = 0.8
    static let levelVictoryFadeOutDuration: TimeInterval = 0.6
    static let levelVictoryDuration = levelVictoryFadeInDuration + levelVictoryFadeOutDuration
}
