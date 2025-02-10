//
//  App_RecordApp.swift
//  App_Record
//
//  Created by Nikoloz Bibileishvili on 10/2/25.
//

import SwiftUI

@main
struct App_RecordApp: App {
    @StateObject private var subscriptionService = SubscriptionService()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showingSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showingSplash {
                    SplashScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
                
                Group {
                    if !hasCompletedOnboarding {
                        WelcomeView()
                    } else {
                        ContentView()
                            .environmentObject(subscriptionService)
                    }
                }
                .zIndex(0)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showingSplash = false
                    }
                }
            }
        }
    }
}
