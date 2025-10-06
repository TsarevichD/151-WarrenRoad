//
//  WarrenViewOne.swift
//  WarrenRoad


import SwiftUI

struct WarrenViewOne: View {
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var waveOffset: CGFloat = 0
    @State private var particleOffset: CGFloat = 0
    @State private var buttonPressed = false
    @State private var logoRotation: Double = 0
    @EnvironmentObject var router: WarrenRouterView

    var body: some View {
        ZStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.lightYellow,
                        Color.goldenBeige,
                        Color.lightOlive
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                WaveShape(offset: waveOffset)
                    .fill(Color.warmBrown.opacity(0.1))
                    .ignoresSafeArea()
                    .animation(
                        Animation.linear(duration: 4.0)
                            .repeatForever(autoreverses: false),
                        value: waveOffset
                    )
                
                ForEach(0..<8, id: \.self) { index in
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(4))
                        .fill(Color.green.opacity(0.15))
                        .frame(
                            width: AdaptiveSize.iconSize(CGFloat.random(in: 6...12)),
                            height: AdaptiveSize.iconSize(CGFloat.random(in: 6...12))
                        )
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .offset(
                            x: CGFloat.random(in: -200...200),
                            y: CGFloat.random(in: -400...400)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 8...15))
                                .repeatForever(autoreverses: false),
                            value: particleOffset
                        )
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.darkBrown.opacity(0.3),
                                        Color.warmBrown.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(
                                width: AdaptiveSize.iconSize(140 + CGFloat(index * 20)),
                                height: AdaptiveSize.iconSize(140 + CGFloat(index * 20))
                            )
                            .scaleEffect(pulseScale + CGFloat(index) * 0.1)
                            .opacity(0.6 - CGFloat(index) * 0.2)
                            .animation(
                                Animation.easeInOut(duration: 2.5 + Double(index) * 0.5)
                                    .repeatForever(autoreverses: true),
                                value: pulseScale
                            )
                    }
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.warmBrown.opacity(0.3),
                                        Color.darkBrown.opacity(0.1)
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: AdaptiveSize.iconSize(60)
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(120), height: AdaptiveSize.iconSize(120))
                            .scaleEffect(isAnimating ? 1.05 : 0.95)
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        HStack(spacing: AdaptiveSize.spacing(12)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(6))
                                    .fill(Color.oliveBrown)
                                    .frame(width: AdaptiveSize.iconSize(24), height: AdaptiveSize.iconSize(36))
                                    .shadow(color: Color.darkBrown.opacity(0.3), radius: 4, x: 2, y: 2)
                                
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .fill(Color.lightOlive.opacity(0.6))
                                        .frame(width: AdaptiveSize.iconSize(16), height: 1)
                                    Rectangle()
                                        .fill(Color.lightOlive.opacity(0.6))
                                        .frame(width: AdaptiveSize.iconSize(16), height: 1)
                                }
                            }
                            .rotationEffect(.degrees(isAnimating ? -8 : 8))
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1.8)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(6))
                                    .fill(Color.green)
                                    .frame(width: AdaptiveSize.iconSize(24), height: AdaptiveSize.iconSize(36))
                                    .shadow(color: Color.darkBrown.opacity(0.3), radius: 4, x: 2, y: 2)
                                
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .fill(Color.lightYellow.opacity(0.8))
                                        .frame(width: AdaptiveSize.iconSize(16), height: 1)
                                    Rectangle()
                                        .fill(Color.lightYellow.opacity(0.8))
                                        .frame(width: AdaptiveSize.iconSize(16), height: 1)
                                }
                            }
                            .rotationEffect(.degrees(isAnimating ? 8 : -8))
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1.8)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        }
                        .rotationEffect(.degrees(logoRotation))
                        .animation(
                            Animation.linear(duration: 20)
                                .repeatForever(autoreverses: false),
                            value: logoRotation
                        )
                    }
                }
                .padding(.bottom, AdaptiveSize.padding(30))
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.3)
                .animation(
                    Animation.spring(response: 1.2, dampingFraction: 0.8)
                        .delay(0.2),
                    value: showContent
                )
                
                VStack(spacing: AdaptiveSize.spacing(16)) {
                    Text("Warren Road")
                        .adaptiveFont(.largeTitle, size: AdaptiveSize.fontSize(36))
                        .fontWeight(.black)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.darkBrown,
                                    Color.warmBrown
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.darkBrown.opacity(0.3), radius: 2, x: 1, y: 1)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 50)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.4),
                            value: showContent
                        )
                    
                    Text("Manage Two Storages")
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(22))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.oliveBrown)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 40)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.6),
                            value: showContent
                        )
                    
                    Text("Organize, track, and grow your storages with clear statistics and achievements")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(17))
                        .foregroundColor(Color.oliveBrown.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .adaptivePadding(.horizontal, 50)
                        .lineSpacing(4)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(
                            Animation.spring(response: 1.0, dampingFraction: 0.7)
                                .delay(0.8),
                            value: showContent
                        )
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        buttonPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            buttonPressed = false
                        }
                    }
                    router.currentScreen = .onboar2
                }) {
                    HStack(spacing: AdaptiveSize.spacing(12)) {
                        Text("Get Started")
                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(19))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(17))
                            .foregroundColor(.white)
                            .offset(x: buttonPressed ? 5 : 0)
                            .animation(
                                Animation.easeInOut(duration: 0.2),
                                value: buttonPressed
                            )
                    }
                    .adaptivePadding(.horizontal, 50)
                    .adaptivePadding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(30))
                                .fill(Color.darkBrown.opacity(0.3))
                                .offset(y: 4)
                            
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(30))
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
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(30))
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.goldenBeige.opacity(0.3),
                                                    Color.lightYellow.opacity(0.2)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        }
                    )
                    .scaleEffect(buttonPressed ? 0.95 : 1.0)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)
                    .animation(
                        Animation.spring(response: 1.0, dampingFraction: 0.7)
                            .delay(1.0),
                        value: showContent
                    )
                }
                .adaptivePadding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = true
                pulseScale = 1.3
                showContent = true
                waveOffset = 360
                particleOffset = 360
                logoRotation = 360
            }
        }
    }
}

struct WaveShape: Shape {
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.5
        
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
    WarrenViewOne()
}
