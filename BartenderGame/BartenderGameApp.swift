//
//  BartenderGameApp.swift
//  BartenderGame
//
//  Created by Daniel Harlos on 16/04/2025.
//

import SwiftUI

@main
struct BartenderGameApp: App {
    @StateObject private var dailyTransitionManager = DailyTransitionManager.shared
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .onAppear {
                    // Check for daily transition when app launches
                    dailyTransitionManager.checkAndProcessDailyTransition()
                }
        }
    }
}
