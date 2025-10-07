//
//  WarrenApp.swift

import SwiftUI

@main
struct WarrenApp: App {
    @State private var isUserRegistered = UserDefaults.standard.bool(forKey: "isUserRegistered")
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("hasCompletedPermissionFlow") private var hasCompletedPermissionFlow = false
    
    
    init() {
        UIButton.appearance().isMultipleTouchEnabled = false
        UIButton.appearance().isExclusiveTouch = true
        UIView.appearance().isMultipleTouchEnabled = false
        UIView.appearance().isExclusiveTouch = true
    }
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedPermissionFlow {
                PushPermissionView(onComplete: {
                    hasCompletedPermissionFlow = true
                })
                .preferredColorScheme(.dark)
                
            } else if !hasSeenWelcome {
                WelcomeView()
                    .preferredColorScheme(.dark)
                    
            } else {
                if #available(iOS 17.3, *) {
                    NavigationStack {
                        FirstView()
                            .ignoresSafeArea(.all)
                    }
                }
            }
           
        }
    }
}
