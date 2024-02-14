//
//  GameView.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            let (gridViewSize, tileSize) = gridViewFrameAndTileSize(in: geometry.size)
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        VStack {
                            // Show a 'close' button in the upper-left corner for exiting Jam mode
                            if gameViewModel.gridMode == .jam {
                                HStack {
                                    Button(action: {
                                        gameViewModel.gridMode = .idle
                                    }) {
                                        Image(systemName: "xmark.rectangle")
                                            .font(.title)
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                            }
                            GridViewWrapper(tileSize: tileSize, gridViewSize: gridViewSize)
                                .frame(width: gridViewSize.width, height: gridViewSize.height, alignment: .center)
                                .edgesIgnoringSafeArea(.all)
                        }
                        
                        if gameViewModel.isLevelStartViewVisible {
                            LevelStartView(levelNumber: gameViewModel.currentLevel)
                                .transition(.opacity)
                                .zIndex(1)
                                .animation(.easeIn(duration: DesignConstants.overlayWindowFadeInDuration),
                                           value: gameViewModel.isLevelStartViewVisible
                                )
                                .animation(.easeOut(duration: DesignConstants.overlayWindowFadeOutDuration),
                                           value: gameViewModel.isLevelStartViewVisible
                                )
                        } else if gameViewModel.isGameOverViewVisibile {
                            GameOverView(levelNumber: gameViewModel.currentLevel)
                                .transition(.opacity)
                                .zIndex(1)
                                .animation(.easeIn(duration: DesignConstants.overlayWindowFadeInDuration),
                                           value: gameViewModel.isLevelStartViewVisible
                                )
                                .animation(.easeOut(duration: DesignConstants.overlayWindowFadeOutDuration),
                                           value: gameViewModel.isLevelStartViewVisible
                                )
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    private func gridViewFrameAndTileSize(in size: CGSize) -> (CGSize, CGFloat) {
        let gutterWidth = CGFloat(DesignConstants.gridWidth + 1) * DesignConstants.gutterSize
        let gutterHeight = CGFloat(DesignConstants.gridHeight + 1) * DesignConstants.gutterSize
        let gridRatio = CGFloat(DesignConstants.gridHeight) / CGFloat(DesignConstants.gridWidth)
        let screenRatio = size.height / size.width
        
        if gridRatio < screenRatio {
            // Screen width is the limiting factor
            let tileSize = (size.width - gutterWidth) / CGFloat(DesignConstants.gridWidth)
            let gridViewHeight = tileSize * CGFloat(DesignConstants.gridHeight) + gutterHeight
            return (CGSize(width: size.width, height: gridViewHeight), tileSize)
        } else {
            // Screen height is the limiting factor
            let tileSize = (size.height - gutterHeight) / CGFloat(DesignConstants.gridHeight)
            let gridViewWidth = tileSize * CGFloat(DesignConstants.gridWidth) + gutterWidth
            return (CGSize(width: gridViewWidth, height: size.height), tileSize)
        }
    }
}
