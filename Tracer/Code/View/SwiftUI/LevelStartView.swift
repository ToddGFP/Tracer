//
//  LevelStartView.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/30/24.
//

import SwiftUI

struct LevelStartView: View {
    var levelNumber: Int
    
    var body: some View {
        Text("Level \(levelNumber)")
            .font(.largeTitle)
            .modifier(OverlayViewModifier())
    }
}
