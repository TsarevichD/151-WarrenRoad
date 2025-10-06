//
//  WarrenRouterView.swift

import SwiftUI

enum AppScreen {
    case onboar1
    case onboar2
    case onboar3
    case home
    case desk
    case tech
    case addFurniture
    case addOrge
    case achievements
    case statistics
    case profile
    case info
}

class WarrenRouterView: ObservableObject {
    @Published var currentScreen: AppScreen = .onboar1
    @Published var selectedDeskIndex: Int = 0
    @Published var selectedTechIndex: Int = 0
}


struct FirstView: View {
    @StateObject var router = WarrenRouterView()
    @StateObject private var memory = WarrenUserMemory.shared
    
    var body: some View {
        Group {
            if memory.hasCompletedOnboarding {
                switch router.currentScreen {
                case .home:
                    RoadMainView().environmentObject(router)
                case .desk:
                    DeskDepotView().environmentObject(router)
                case .addFurniture:
                    AddFurnitureView(storageIndex: router.selectedDeskIndex).environmentObject(router)
                case .tech:
                    TechStantionView().environmentObject(router)
                case .addOrge:
                    AddOgreVehiclesView(storageIndex: router.selectedTechIndex).environmentObject(router)
                case .achievements:
                    RoadAchivView().environmentObject(router)
                case .statistics:
                    RoadStatView().environmentObject(router)
                case .profile:
                    RoadProfileView().environmentObject(router)
                case .info:
                    RoadInfoView().environmentObject(router)
                default:
                    RoadMainView().environmentObject(router)
                }
            } else {
                switch router.currentScreen {
                case .onboar1:
                    WarrenViewOne().environmentObject(router)
                case .onboar2:
                    WarrenViewTwo().environmentObject(router)
                case .onboar3:
                    WarrenViewThree().environmentObject(router)
                default:
                    WarrenViewOne().environmentObject(router)
                }
            }
        }
        .onAppear {
            if memory.hasCompletedOnboarding {
                router.currentScreen = .home
            } else {
                router.currentScreen = .onboar1
            }
        }
    }
}

