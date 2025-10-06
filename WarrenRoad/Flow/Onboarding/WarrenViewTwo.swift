//
//  WarrenViewTwo.swift

import SwiftUI

struct WarrenViewTwo: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var cardOffset: CGFloat = 0
    @State private var iconBounce = false
    @State private var buttonPressed = false
    @State private var sparkleRotation: Double = 0
    @EnvironmentObject var router: WarrenRouterView

    var body: some View {
        ZStack {
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.lightOlive,
                        Color.goldenBeige,
                        Color.warmBrown
                    ]),
                    center: .topTrailing,
                    startRadius: 0,
                    endRadius: UIScreen.screenHeight
                )
                .ignoresSafeArea()
                
                ForEach(0..<12, id: \.self) { index in
                    TriangleShape()
                        .fill(Color.green.opacity(0.1))
                        .frame(
                            width: AdaptiveSize.iconSize(CGFloat.random(in: 20...40)),
                            height: AdaptiveSize.iconSize(CGFloat.random(in: 20...40))
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -400...400)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 10...20))
                                .repeatForever(autoreverses: false),
                            value: cardOffset
                        )
                }
                
                ForEach(0..<15, id: \.self) { index in
                    Image(systemName: "sparkle")
                        .foregroundColor(Color.lightYellow.opacity(0.6))
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(8))
                        .offset(
                            x: CGFloat.random(in: -180...180),
                            y: CGFloat.random(in: -350...350)
                        )
                        .rotationEffect(.degrees(sparkleRotation + Double(index * 24)))
                        .animation(
                            Animation.linear(duration: 8)
                                .repeatForever(autoreverses: false),
                            value: sparkleRotation
                        )
                }
            }
            
            VStack(spacing: 0) {
                VStack(spacing: AdaptiveSize.spacing(20)) {
                    Text("Features & Benefits")
                        .adaptiveFont(.title, size: AdaptiveSize.fontSize(28))
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
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -30)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.1),
                            value: showContent
                        )
                    
                    Text("Discover what makes Warren Road special")
                        .adaptiveFont(.subheadline, size: AdaptiveSize.fontSize(16))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.2),
                            value: showContent
                        )
                }
                .adaptivePadding(.top, 60)
                .adaptivePadding(.horizontal, 30)
                
                Spacer()
                
                VStack(spacing: AdaptiveSize.spacing(25)) {
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.darkBrown.opacity(0.9),
                                            Color.oliveBrown.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.darkBrown.opacity(0.4), radius: 10, x: 0, y: 5)
                                .frame(height: AdaptiveSize.buttonHeight(120))
                            
                            HStack(spacing: AdaptiveSize.spacing(20)) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lightYellow.opacity(0.2))
                                        .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                                    
                                    Image(systemName: "chart.bar.fill")
                                        .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                        .foregroundColor(Color.lightYellow)
                                        .scaleEffect(iconBounce ? 1.2 : 1.0)
                                        .animation(
                                            Animation.easeInOut(duration: 1.5)
                                                .repeatForever(autoreverses: true),
                                            value: iconBounce
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Clear Statistics")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Track your storage growth and see what's been added")
                                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                        .foregroundColor(Color.lightYellow.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                            }
                            .adaptivePadding(.horizontal, 20)
                        }
                        .offset(x: cardOffset)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: cardOffset
                        )
                    }
                    
                    VStack(spacing: AdaptiveSize.spacing(16)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.green.opacity(0.9),
                                            Color.lightOlive.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.green.opacity(0.4), radius: 10, x: 0, y: 5)
                                .frame(height: AdaptiveSize.buttonHeight(120))
                            
                            HStack(spacing: AdaptiveSize.spacing(20)) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lightYellow.opacity(0.2))
                                        .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                                    
                                    Image(systemName: "trophy.fill")
                                        .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                        .foregroundColor(Color.lightYellow)
                                        .scaleEffect(iconBounce ? 1.2 : 1.0)
                                        .animation(
                                            Animation.easeInOut(duration: 1.5)
                                                .repeatForever(autoreverses: true),
                                            value: iconBounce
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Achievements")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Turn storage management into a game with milestones")
                                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                        .foregroundColor(Color.lightYellow.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                            }
                            .adaptivePadding(.horizontal, 20)
                        }
                        .offset(x: -cardOffset)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: cardOffset
                        )
                    }
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
                .animation(
                    Animation.spring(response: 1.0, dampingFraction: 0.8)
                        .delay(0.3),
                    value: showContent
                )
                
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    Text("Core Features")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.darkBrown)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.6),
                            value: showContent
                        )
                    
                    HStack(spacing: AdaptiveSize.spacing(30)) {
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "chart.bar.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                .foregroundColor(Color.green)
                            
                            Text("Statistics")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                .foregroundColor(Color.oliveBrown)
                                .fontWeight(.semibold)
                        }
                        
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "trophy.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                .foregroundColor(Color.warmBrown)
                            
                            Text("Achievements")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                .foregroundColor(Color.oliveBrown)
                                .fontWeight(.semibold)
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(
                        Animation.spring(response: 1.0, dampingFraction: 0.7)
                            .delay(0.7),
                        value: showContent
                    )
                }
                .adaptivePadding(.horizontal, 40)
                .adaptivePadding(.vertical, 20)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            buttonPressed = false
                        }
                    }
                    router.currentScreen = .onboar3
                }) {
                    ZStack {
                        HexagonShape()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.warmBrown,
                                        Color.darkBrown,
                                        Color.warmBrown
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(200), height: AdaptiveSize.iconSize(60))
                            .shadow(color: Color.darkBrown.opacity(0.5), radius: 8, x: 0, y: 4)
                        
                        HStack(spacing: AdaptiveSize.spacing(10)) {
                            Text("Continue")
                                .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                .foregroundColor(.white)
                                .offset(x: buttonPressed ? 3 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 0.2),
                                    value: buttonPressed
                                )
                        }
                    }
                }
                .scaleEffect(buttonPressed ? 0.9 : 1.0)
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                .animation(
                    Animation.spring(response: 1.0, dampingFraction: 0.7)
                        .delay(0.8),
                    value: showContent
                )
                .adaptivePadding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                isAnimating = true
                showContent = true
                cardOffset = 20
                iconBounce = true
                sparkleRotation = 360
            }
        }
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    WarrenViewTwo()
}
