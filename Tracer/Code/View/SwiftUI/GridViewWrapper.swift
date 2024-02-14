//
//  GridViewWrapper.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import SwiftUI

struct GridViewWrapper: UIViewRepresentable {
    @EnvironmentObject var gameViewModel: GameViewModel

    var tileSize: CGFloat
    var gridViewSize: CGSize
    
    func makeUIView(context: Context) -> GridView {
        debug("GridViewWrapper: makeUIView()", 0, .controlFlow)
        
        let gridView = GridView(tileSize: tileSize)
        gridView.delegate = gameViewModel
        
        return gridView
    }

    func updateUIView(_ uiView: GridView, context: Context) {
        debug("GridViewWrapper: updateUIView() animation: \(gameViewModel.gridViewAnimationNeeded)", 0, .controlFlow)
        
        uiView.configure(frameSize: gridViewSize, tileSize: tileSize)
        uiView.gridMode = gameViewModel.gridMode
        
        switch gameViewModel.gridViewAnimationNeeded {
        case .none: break
        case .idleSequence:
            if DesignConstants.enableIdleAnimation {
                uiView.presentSequence(gameViewModel.currentSequence, speed: .fast, withSound: false, isIdle: true)
            }
        case .presentNewPuzzle:
            uiView.presentSequence(gameViewModel.currentSequence, speed: .slow, withSound: true, isIdle: false)
        case .puzzleFailed:
            uiView.presentSequence(gameViewModel.currentSequence, speed: .fast, withSound: false, isIdle: false)
        case .puzzleCompleted:
            uiView.presentPuzzleSolvedAnimation(forLevel: gameViewModel.currentLevel)
        case .levelCompleted:
            uiView.presentLevelCompletedAnimation(forLevel: gameViewModel.currentLevel)
        }
    }
}
