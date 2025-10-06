//
//  RoadAchivView.swift

import SwiftUI

struct RoadAchivView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @EnvironmentObject var router: WarrenRouterView
    @State private var isAnimating = false
    @State private var selectedCategory: AchievementCategory? = nil
    @State private var waveOffset: CGFloat = 0
    @State private var particleOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.darkBrown.opacity(0.8),
                        Color.warmBrown.opacity(0.6),
                        Color.green.opacity(0.4),
                        Color.oliveBrown.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(0..<8, id: \.self) { index in
                    AchievementFloatingElement(
                        index: index,
                        screenSize: geometry.size
                    )
                }
                
                ScrollView {
                    VStack(spacing: AdaptiveSize.spacing(24)) {
                        // Safe area spacer
                        Spacer()
                            .frame(height: 20)
                        HStack {
                            Button(action: {
                                router.currentScreen = .home
                            }) {
                                HStack(spacing: AdaptiveSize.spacing(8)) {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                    Text("Back")
                                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(16))
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(Color.lightYellow)
                                .adaptivePadding(.horizontal, 16)
                                .adaptivePadding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                                        .fill(Color.lightYellow.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                                                .stroke(Color.green.opacity(0.6), lineWidth: 1)
                                        )
                                )
                            }
                            
                            Spacer()
                            
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("Achievements")
                                    .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.lightYellow)
                                
                                Text("Your Progress")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            VStack(spacing: AdaptiveSize.spacing(2)) {
                                Text("\(memory.totalPoints)")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                                
                                Text("Points")
                                    .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                                    .foregroundColor(Color.darkBrown)
                            }
                        }
                        .adaptivePadding(.horizontal, 20)
                        .adaptivePadding(.top, 20)
                        
                        // Progress Overview
                        AchievementProgressView()
                            .adaptivePadding(.horizontal, 20)
                        
                        // Category Filter
                        CategoryFilterView(selectedCategory: $selectedCategory)
                            .adaptivePadding(.horizontal, 20)
                        
                        // Achievements List
                        AchievementsListView(selectedCategory: selectedCategory)
                            .adaptivePadding(.horizontal, 20)
                            .adaptivePadding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
                waveOffset = 360
                particleOffset = 360
            }
            memory.checkAndUnlockAchievements()
        }
    }
}

struct AchievementProgressView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var isAnimating = false
    
    private var unlockedCount: Int {
        memory.getUnlockedAchievements().count
    }
    
    private var totalCount: Int {
        memory.achievements.count
    }
    
    private var progressPercentage: Double {
        totalCount > 0 ? Double(unlockedCount) / Double(totalCount) : 0
    }
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(16)) {
            HStack {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text("Progress Overview")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                        .fontWeight(.bold)
                        .foregroundColor(Color.lightYellow)
                    
                    Text("\(unlockedCount) of \(totalCount) achievements unlocked")
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(4)) {
                    Text("\(Int(progressPercentage * 100))%")
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.goldenBeige)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                        .fill(Color.oliveBrown.opacity(0.3))
                        .frame(height: AdaptiveSize.iconSize(12))
                    
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.green,
                                    Color.lightOlive,
                                    Color.goldenBeige
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progressPercentage, height: AdaptiveSize.iconSize(12))
                        .scaleEffect(isAnimating ? 1.0 : 0.0, anchor: .leading)
                        .animation(.easeOut(duration: 1.0).delay(0.3), value: isAnimating)
                }
            }
            .frame(height: AdaptiveSize.iconSize(12))
        }
        .adaptivePadding(.all, 20)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .fill(Color.lightYellow.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .stroke(Color.green.opacity(0.4), lineWidth: 1)
                )
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: AchievementCategory?
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(12)) {
            Text("Filter by Category")
                .adaptiveFont(.title, size: AdaptiveSize.fontSize(16))
                .fontWeight(.bold)
                .foregroundColor(Color.lightYellow)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AdaptiveSize.spacing(12)) {
                    AllCategoriesButton(selectedCategory: $selectedCategory)
                    
                    ForEach(AchievementCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            category: category,
                            selectedCategory: $selectedCategory
                        )
                    }
                }
                .adaptivePadding(.horizontal, 20)
            }
        }
    }
}

struct AllCategoriesButton: View {
    @Binding var selectedCategory: AchievementCategory?
    
    var body: some View {
        Button(action: {
            selectedCategory = nil
        }) {
            HStack(spacing: AdaptiveSize.spacing(6)) {
                Text("🏆")
                    .font(.system(size: AdaptiveSize.iconSize(16)))
                
                Text("All")
                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                    .fontWeight(.medium)
            }
            .foregroundColor(selectedCategory == nil ? .white : Color.lightYellow)
            .adaptivePadding(.horizontal, 16)
            .adaptivePadding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(selectedCategory == nil ? Color.green : Color.lightYellow.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(selectedCategory == nil ? Color.green : Color.lightYellow.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct CategoryButton: View {
    let category: AchievementCategory
    @Binding var selectedCategory: AchievementCategory?
    
    var body: some View {
        Button(action: {
            selectedCategory = category
        }) {
            HStack(spacing: AdaptiveSize.spacing(6)) {
                Text(category.emoji)
                    .font(.system(size: AdaptiveSize.iconSize(16)))
                
                Text(category.displayName)
                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(selectedCategory == category ? .white : Color.lightYellow)
            .adaptivePadding(.horizontal, 16)
            .adaptivePadding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(selectedCategory == category ? category.color : Color.lightYellow.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(selectedCategory == category ? category.color : Color.lightYellow.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct AchievementsListView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    let selectedCategory: AchievementCategory?
    @State private var isAnimating = false
    
    private var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return memory.getAchievementsByCategory(category)
        } else {
            return memory.achievements
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            Text("Achievements")
                .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                .fontWeight(.bold)
                .foregroundColor(Color.lightYellow)
            
            LazyVStack(spacing: AdaptiveSize.spacing(12)) {
                ForEach(Array(filteredAchievements.enumerated()), id: \.element.id) { index, achievement in
                    AchievementCardView(achievement: achievement, index: index)
                }
            }
        }
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(16)) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                achievement.isUnlocked ? achievement.category.color.opacity(0.8) : Color.gray.opacity(0.3),
                                achievement.isUnlocked ? achievement.category.color.opacity(0.4) : Color.gray.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: AdaptiveSize.iconSize(25)
                        )
                    )
                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: isAnimating)
                
                Text(achievement.emoji)
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.3), value: isAnimating)
            }
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(6)) {
                HStack {
                    Text(achievement.title)
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.bold)
                        .foregroundColor(achievement.isUnlocked ? Color.lightYellow : Color.oliveBrown.opacity(0.7))
                    
                    Spacer()
                    
                    if achievement.isUnlocked {
                        HStack(spacing: AdaptiveSize.spacing(4)) {
                            Text("+\(achievement.points)")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                .fontWeight(.bold)
                                .foregroundColor(Color.darkBrown)
                            
                            Text("pts")
                                .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                                .foregroundColor(Color.oliveBrown.opacity(0.8))
                        }
                    }
                }
                
                Text(achievement.description)
                    .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                    .foregroundColor(achievement.isUnlocked ? Color.oliveBrown.opacity(0.9) : Color.oliveBrown.opacity(0.6))
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("Requirement:")
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .foregroundColor(Color.oliveBrown.opacity(0.7))
                        
                        Text(getRequirementText(achievement))
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .fontWeight(.medium)
                            .foregroundColor(Color.oliveBrown.opacity(0.8))
                    }
                }
            }
            
            Spacer()
            
            // Status Indicator
            VStack(spacing: AdaptiveSize.spacing(4)) {
                if achievement.isUnlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                        .foregroundColor(Color.green)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(index) * 0.4), value: isAnimating)
                } else {
                    Image(systemName: "lock.circle.fill")
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                        .foregroundColor(Color.gray.opacity(0.6))
                }
            }
        }
        .adaptivePadding(.all, 16)
        .background(
            ZStack {
                // Main background with category-specific gradient
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                    .fill(getAchievementBackground(achievement))
                
                // Overlay pattern for unlocked achievements
                if achievement.isUnlocked {
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ]),
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                .stroke(getAchievementStroke(achievement), lineWidth: 2)
        )
        .shadow(
            color: getAchievementShadow(achievement),
            radius: achievement.isUnlocked ? 8 : 4,
            x: 0,
            y: achievement.isUnlocked ? 4 : 2
        )
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func getRequirementText(_ achievement: Achievement) -> String {
        switch achievement.id {
        case "first_storage", "storage_master":
            return "\(achievement.requirement) storages"
        case "first_item", "item_collector":
            return "\(achievement.requirement) items"
        case "value_expert":
            return "$\(achievement.requirement) total value"
        case "collection_pro":
            return "\(achievement.requirement) categories"
        case "efficiency_guru":
            return "\(achievement.requirement)+ items per storage"
        default:
            return "Complete requirement"
        }
    }
    
    private func getAchievementBackground(_ achievement: Achievement) -> LinearGradient {
        if achievement.isUnlocked {
            switch achievement.category {
            case .storage:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.9),
                        Color.lightOlive.opacity(0.8),
                        Color.green.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .items:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color.lightOlive.opacity(0.9),
                        Color.green.opacity(0.8),
                        Color.lightOlive.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .value:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color.lightYellow.opacity(0.9),
                        Color.goldenBeige.opacity(0.8),
                        Color.lightYellow.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .collection:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color.warmBrown.opacity(0.9),
                        Color.goldenBeige.opacity(0.8),
                        Color.warmBrown.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .efficiency:
                return LinearGradient(
                    gradient: Gradient(colors: [
                        Color.darkBrown.opacity(0.9),
                        Color.warmBrown.opacity(0.8),
                        Color.darkBrown.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.3),
                    Color.gray.opacity(0.2),
                    Color.gray.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private func getAchievementStroke(_ achievement: Achievement) -> LinearGradient {
        if achievement.isUnlocked {
            switch achievement.category {
            case .storage:
                return LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.lightOlive]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .items:
                return LinearGradient(
                    gradient: Gradient(colors: [Color.lightOlive, Color.green]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .value:
                return LinearGradient(
                    gradient: Gradient(colors: [Color.lightYellow, Color.goldenBeige]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .collection:
                return LinearGradient(
                    gradient: Gradient(colors: [Color.warmBrown, Color.goldenBeige]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .efficiency:
                return LinearGradient(
                    gradient: Gradient(colors: [Color.darkBrown, Color.warmBrown]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private func getAchievementShadow(_ achievement: Achievement) -> Color {
        if achievement.isUnlocked {
            switch achievement.category {
            case .storage:
                return Color.green.opacity(0.3)
            case .items:
                return Color.lightOlive.opacity(0.3)
            case .value:
                return Color.lightYellow.opacity(0.3)
            case .collection:
                return Color.warmBrown.opacity(0.3)
            case .efficiency:
                return Color.darkBrown.opacity(0.3)
            }
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}

// MARK: - Floating Elements
struct AchievementFloatingElement: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.2
    
    private let achievementIcons = ["🏆", "⭐", "🎯", "💎", "🔥", "⚡", "🌟", "💫"]
    
    private var elementColor: Color {
        let colors = [Color.green, Color.lightOlive, Color.goldenBeige, Color.lightYellow, Color.warmBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [20, 25, 15, 30, 23, 27, 21, 24]
        return AdaptiveSize.iconSize(sizes[index % sizes.count])
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            elementColor.opacity(0.4),
                            elementColor.opacity(0.2),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: elementSize / 2
                    )
                )
                .frame(width: elementSize, height: elementSize)
            
            Text(achievementIcons[index % achievementIcons.count])
                .font(.system(size: AdaptiveSize.iconSize(12)))
                .foregroundColor(Color.lightYellow.opacity(0.6))
        }
        .offset(offset)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            let randomX = CGFloat.random(in: -screenSize.width/2...screenSize.width/2)
            let randomY = CGFloat.random(in: -screenSize.height/2...screenSize.height/2)
            offset = CGSize(width: randomX, height: randomY)
            
            withAnimation(
                .easeInOut(duration: Double.random(in: 8...15))
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: randomX + CGFloat.random(in: -60...60),
                    height: randomY + CGFloat.random(in: -60...60)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.7...1.3)
                opacity = Double.random(in: 0.1...0.3)
            }
        }
    }
}

#Preview {
    RoadAchivView()
}
