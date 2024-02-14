//
//  MainMenuView.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import SwiftUI

struct MainMenuView: View {
    var onPlay: () -> Void
    var onJam: () -> Void

    var body: some View {
        ZStack {
            VStack() {
                Text("Tracer")
                    .font(.largeTitle)
                    .padding(10)
                    .foregroundColor(.yellow)
                    .bold()
                Button("Play", action: onPlay)
                    .font(.title)
                    .padding(10)
                    .bold()
                Button("Jam", action: onJam)
                    .font(.title)
                    .padding(.bottom, 10)
                    .bold()
            }
        }
        .modifier(OverlayViewModifier())
    }
}
