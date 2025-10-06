//
//  RoadMainView.swift

import SwiftUI

struct RoadMainView: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var waveOffset: CGFloat = 0
    @State private var particleOffset: CGFloat = 0
    @State private var iconBounce = false
    @EnvironmentObject var router: WarrenRouterView
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.lightYellow,
                            Color.goldenBeige,
                            Color.lightOlive,
                            Color.warmBrown
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    WaveShapeRoad(offset: waveOffset)
                        .fill(Color.darkBrown.opacity(0.1))
                        .ignoresSafeArea()
                        .animation(
                            Animation.linear(duration: 4.0)
                                .repeatForever(autoreverses: false),
                            value: waveOffset
                        )
                    
                    ForEach(0..<12, id: \.self) { index in
                        StorageElement(
                            index: index,
                            screenSize: geometry.size
                        )
                    }
                }
                VStack(spacing: AdaptiveSize.spacing(30)) {
                    HStack {
                        Button(action: {
                            router.currentScreen = .profile
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.green,
                                                Color.lightOlive
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                                    .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "person.circle.fill")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                    .foregroundColor(Color.lightYellow)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: AdaptiveSize.spacing(4)) {
                            Text("Warren Road")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.darkBrown,
                                            Color.warmBrown
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Storage Manager")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.oliveBrown)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            router.currentScreen = .info
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.warmBrown,
                                                Color.darkBrown
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                                    .shadow(color: Color.warmBrown.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "info.circle.fill")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                    .foregroundColor(Color.lightYellow)
                            }
                        }
                    }
                    .adaptivePadding(.horizontal, 20)
                    .adaptivePadding(.top, 48)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 100)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: showContent)
                    
                    Spacer()
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        HStack(spacing: AdaptiveSize.spacing(8)) {
                            ZStack {
                                Circle()
                                    .fill(Color.darkBrown.opacity(0.1))
                                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                                
                                Image(systemName: "archivebox.fill")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                    .foregroundColor(Color.darkBrown)
                            }
                            
                            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(2)) {
                                Text("Manage Your Storages")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(22))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkBrown)
                                    .lineLimit(1)
                                
                                Text("Organize, track, and grow")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                    .foregroundColor(Color.oliveBrown)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 40)
                    .animation(.easeOut(duration: 1).delay(0.5), value: showContent)
                    
                    HStack(spacing: AdaptiveSize.spacing(20)) {
                        FeatureIcon(icon: "chart.bar.fill", title: "Statistics", color: Color.green)
                        FeatureIcon(icon: "trophy.fill", title: "Achievements", color: Color.warmBrown)
                        FeatureIcon(icon: "person.circle.fill", title: "Personal", color: Color.lightOlive)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 1).delay(0.8), value: showContent)
                    
                    Spacer()
                    
                    VStack(spacing: AdaptiveSize.spacing(20)) {
                        HStack(spacing: AdaptiveSize.spacing(16)) {
                            StorageCard(
                                title: "Desk Depot",
                                subtitle: "Office Equipment",
                                icon: "archivebox.fill",
                                color: Color.green,
                                action: {
                                    router.currentScreen = .desk
                                }
                            )
                            
                            StorageCard(
                                title: "Tech Station",
                                subtitle: "Organizational",
                                icon: "shippingbox.fill",
                                color: Color.warmBrown,
                                action: {
                                    router.currentScreen = .tech
                                }
                            )
                        }
                        HStack(spacing: AdaptiveSize.spacing(16)) {
                            StatsCard(
                                title: "Progress Road",
                                subtitle: "Track Growth",
                                icon: "chart.line.uptrend.xyaxis",
                                color: Color.lightOlive,
                                action: {
                                    router.currentScreen = .statistics
                                }
                            )
                            
                            StatsCard(
                                title: "Badge Path",
                                subtitle: "Unlock Milestones",
                                icon: "trophy.fill",
                                color: Color.goldenBeige,
                                action: {
                                    router.currentScreen = .achievements
                                }
                            )
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 50)
                    .animation(.easeOut(duration: 1).delay(1.1), value: showContent)
                    
                    Spacer()
                        .frame(height: AdaptiveSize.spacing(30))
                }
                .adaptivePadding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                isAnimating = true
                showContent = true
                waveOffset = 360
                particleOffset = 360
            }
        }
    }
}

struct StorageCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AdaptiveSize.spacing(8)) {
                ZStack {
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                        .fill(color.opacity(0.2))
                        .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                    
                    Image(systemName: icon)
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                        .foregroundColor(color)
                }
                
                VStack(spacing: AdaptiveSize.spacing(2)) {
                    Text(title)
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBrown)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(10))
                        .foregroundColor(Color.oliveBrown)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .adaptivePadding(.horizontal, 12)
            .adaptivePadding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                    .fill(Color.lightYellow.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
            )
        }
    }
}

struct StatsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AdaptiveSize.spacing(8)) {
                ZStack {
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                        .fill(color.opacity(0.2))
                        .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                    
                    Image(systemName: icon)
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                        .foregroundColor(color)
                }
                
                VStack(spacing: AdaptiveSize.spacing(2)) {
                    Text(title)
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBrown)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(10))
                        .foregroundColor(Color.oliveBrown)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
            }
            .adaptivePadding(.horizontal, 12)
            .adaptivePadding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                    .fill(Color.goldenBeige.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
            )
        }
    }
}

struct FeatureIcon: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(8)) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: AdaptiveSize.iconSize(40), height: AdaptiveSize.iconSize(40))
                
                Image(systemName: icon)
                    .adaptiveFont(.title3, size: AdaptiveSize.fontSize(20))
                    .foregroundColor(color)
            }
            
            Text(title)
                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                .foregroundColor(Color.darkBrown)
                .fontWeight(.semibold)
        }
    }
}

struct StorageElement: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3
    
    private let icons = ["archivebox.fill", "shippingbox.fill", "cube.box.fill", "tray.full.fill", "folder.fill", "doc.fill", "wrench.fill", "hammer.fill", "screwdriver.fill", "paintbrush.fill", "scissors"]
    
    private var elementColor: Color {
        let colors = [Color.green, Color.warmBrown, Color.lightOlive, Color.goldenBeige, Color.darkBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [25, 30, 20, 35, 28, 32, 26, 29, 27, 24, 31, 33]
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
            
            Image(systemName: icons[index % icons.count])
                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                .foregroundColor(Color.darkBrown.opacity(0.6))
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
                    width: randomX + CGFloat.random(in: -80...80),
                    height: randomY + CGFloat.random(in: -80...80)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.7...1.3)
                opacity = Double.random(in: 0.1...0.4)
            }
        }
    }
}

struct WaveShapeRoad: Shape {
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.3
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX * .pi * 2) + (offset * .pi / 180))
            let y = midHeight + (sine * height * 0.1)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    RoadMainView()
}
