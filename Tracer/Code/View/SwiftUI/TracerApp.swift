//
//  TracerApp.swift
//  Tracer
//
//  Created by Todd Gibbons on 1/10/24.
//

import SwiftUI

@main
struct TracerApp: App {
    @StateObject var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(gameViewModel)
        }
    }
}

