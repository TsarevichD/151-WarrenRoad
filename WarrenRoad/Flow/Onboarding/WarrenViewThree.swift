//
//  WarrenViewThree.swift

import SwiftUI

struct WarrenViewThree: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var cardOffset: CGFloat = 0
    @State private var iconBounce = false
    @State private var buttonPressed = false
    @State private var leafRotation: Double = 0
    @State private var profileScale: CGFloat = 1.0
    @EnvironmentObject var router: WarrenRouterView
    @StateObject private var memory = WarrenUserMemory.shared

    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green,
                        Color.lightOlive,
                        Color.lightYellow
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(0..<10, id: \.self) { index in
                    LeafShape()
                        .fill(Color.lightYellow.opacity(0.2))
                        .frame(
                            width: AdaptiveSize.iconSize(CGFloat.random(in: 15...35)),
                            height: AdaptiveSize.iconSize(CGFloat.random(in: 15...35))
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -400...400)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 8...15))
                                .repeatForever(autoreverses: false),
                            value: leafRotation
                        )
                }
                
                ForEach(0..<20, id: \.self) { index in
                    Circle()
                        .fill(Color.lightYellow.opacity(0.4))
                        .frame(
                            width: AdaptiveSize.iconSize(CGFloat.random(in: 4...8)),
                            height: AdaptiveSize.iconSize(CGFloat.random(in: 4...8))
                        )
                        .offset(
                            x: CGFloat.random(in: -180...180),
                            y: CGFloat.random(in: -350...350)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 6...12))
                                .repeatForever(autoreverses: false),
                            value: leafRotation
                        )
                }
            }
            
            VStack(spacing: 0) {
                VStack(spacing: AdaptiveSize.spacing(20)) {
                    Text("Personalization & Support")
                        .adaptiveFont(.title, size: AdaptiveSize.fontSize(28))
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.darkBrown,
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
                    
                    Text("Make Warren Road truly yours")
                        .adaptiveFont(.subheadline, size: AdaptiveSize.fontSize(16))
                        .foregroundColor(Color.darkBrown)
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
                                    
                                    Image(systemName: "person.circle.fill")
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
                                    Text("Personal Profile")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Create your individual experience with personal data")
                                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                        .foregroundColor(Color.lightYellow.opacity(0.9))
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                            }
                            .adaptivePadding(.horizontal, 20)
                        }
                        .offset(x: cardOffset)
                        .scaleEffect(profileScale)
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
                                            Color.lightOlive.opacity(0.9),
                                            Color.green.opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.lightOlive.opacity(0.4), radius: 10, x: 0, y: 5)
                                .frame(height: AdaptiveSize.buttonHeight(120))
                            
                            HStack(spacing: AdaptiveSize.spacing(20)) {
                                ZStack {
                                    Circle()
                                        .fill(Color.lightYellow.opacity(0.2))
                                        .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                                    
                                    Image(systemName: "info.circle.fill")
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
                                    Text("Info & Guidance")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Learn app purpose and get effective usage tips")
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
                    Text("Why Choose Warren Road?")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBrown)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.6),
                            value: showContent
                        )
                    
                    HStack(spacing: AdaptiveSize.spacing(20)) {
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "checkmark.circle.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                .foregroundColor(Color.green)
                            
                            Text("Organized")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.darkBrown)
                                .fontWeight(.bold)
                        }
                        
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                .foregroundColor(Color.lightOlive)
                            
                            Text("Tracked")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.darkBrown)
                                .fontWeight(.bold)
                        }
                        
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "gamecontroller.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                .foregroundColor(Color.goldenBeige)
                            
                            Text("Gamified")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.darkBrown)
                                .fontWeight(.bold)
                        }
                        
                        VStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "person.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                .foregroundColor(Color.warmBrown)
                            
                            Text("Personal")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.darkBrown)
                                .fontWeight(.bold)
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
                    memory.completeOnboarding()
                    router.currentScreen = .home
                }) {
                    ZStack {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.darkBrown,
                                        Color.warmBrown,
                                        Color.darkBrown
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(180), height: AdaptiveSize.iconSize(50))
                            .shadow(color: Color.darkBrown.opacity(0.6), radius: 12, x: 0, y: 6)
                            .overlay(
                                Capsule()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.lightYellow.opacity(0.3),
                                                Color.goldenBeige.opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                        
                        HStack(spacing: AdaptiveSize.spacing(8)) {
                            Image(systemName: "play.circle.fill")
                                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                .foregroundColor(Color.lightYellow)
                                .scaleEffect(buttonPressed ? 1.1 : 1.0)
                                .animation(
                                    Animation.easeInOut(duration: 0.2),
                                    value: buttonPressed
                                )
                            
                            Text("Get Started")
                                .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
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
                leafRotation = 360
                profileScale = 1.05
            }
        }
    }
}

struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        
        path.move(to: CGPoint(x: centerX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: centerY),
            control: CGPoint(x: centerX + width * 0.3, y: rect.minY + height * 0.3)
        )
        path.addQuadCurve(
            to: CGPoint(x: centerX, y: rect.maxY),
            control: CGPoint(x: rect.maxX - width * 0.2, y: centerY + height * 0.3)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: centerY),
            control: CGPoint(x: centerX - width * 0.3, y: centerY + height * 0.3)
        )
        path.addQuadCurve(
            to: CGPoint(x: centerX, y: rect.minY),
            control: CGPoint(x: rect.minX + width * 0.2, y: centerY - height * 0.3)
        )
        path.closeSubpath()
        return path
    }
}

#Preview {
    WarrenViewThree()
}
