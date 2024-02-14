//
//  GameOverView.swift
//  Tracer
//
//  Created by Todd Gibbons on 2/3/24.
//

import SwiftUI

struct GameOverView: View {
    var levelNumber: Int

    var body: some View {
        VStack() {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            Text("You got to level \(levelNumber)!")
                .font(.title)
                .padding()
        }
        .modifier(OverlayViewModifier())
    }
}
