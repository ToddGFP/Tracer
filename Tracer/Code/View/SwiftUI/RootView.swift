//
//  RootView.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            GameView()
            if gameViewModel.gridMode == .idle {
                MainMenuView(onPlay: {
                    gameViewModel.startNewGame()
                }, onJam: {
                    gameViewModel.enterJamMode()
                })
            }
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}
