//
//  RoadInfoView.swift

import SwiftUI

struct RoadInfoView: View {
    @EnvironmentObject var router: WarrenRouterView
    @State private var animateElements = false
    
    private let colors = (
        darkBrown: Color.darkBrown,
        lightYellow: Color.lightYellow,
        oliveBrown: Color.oliveBrown,
        green: Color.green,
        warmBrown: Color.warmBrown,
        lightOlive: Color.lightOlive,
        goldenBeige: Color.goldenBeige
    )
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    backgroundGradient
                    floatingElements(geometry: geometry)
                    infoContent
                }
            }
            .navigationTitle("App Info")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    homeButton
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateElements = true
            }
        }
    }
    
    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                colors.darkBrown,
                colors.oliveBrown,
                colors.warmBrown,
                colors.darkBrown.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Floating Elements
    private func floatingElements(geometry: GeometryProxy) -> some View {
        VStack {
            HStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.9),
                                colors.green.opacity(0.7)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                    .offset(x: -geometry.size.width/2 + 80, y: -geometry.size.height/2 + 100)
                    .scaleEffect(animateElements ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateElements)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                colors.lightOlive.opacity(0.8),
                                colors.warmBrown.opacity(0.6)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .frame(width: 40, height: 40)
                    .offset(x: geometry.size.width/2 - 60, y: -geometry.size.height/2 + 200)
                    .scaleEffect(animateElements ? 0.8 : 1.2)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: animateElements)
            }
        }
    }
    
    // MARK: - Info Content
    private var infoContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AdaptiveSize.spacing(25)) {
                headerSection
                appDescriptionCard
                featuresSection
                abstractSection
                philosophySection
                visionSection
            }
            .adaptivePadding(.bottom, 50)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            Text("Warren Road")
                .adaptiveFont(.largeTitle, size: 32)
                .fontWeight(.bold)
                .foregroundColor(colors.lightYellow)
                .shadow(color: colors.darkBrown.opacity(0.5), radius: 3, x: 0, y: 2)
            
            Text("Office Storage Manager")
                .adaptiveFont(.title3, size: 16)
                .fontWeight(.medium)
                .foregroundColor(colors.lightYellow.opacity(0.9))
                .shadow(color: colors.darkBrown.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .adaptivePadding(.top, 12)
    }
    
    // MARK: - App Description Card
    private var appDescriptionCard: some View {
        VStack(spacing: AdaptiveSize.spacing(12)) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("About Warren Road")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.lightYellow.opacity(0.95),
                                colors.goldenBeige.opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(120))
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.6),
                                colors.green.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(120))
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Warren Road is more than just a storage management application - it's a digital ecosystem that transforms how we think about office organization and workplace efficiency.")
                        .adaptiveFont(.body, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.darkBrown)
                        .multilineTextAlignment(.leading)
                    
                    Text("In the digital age, where information flows like rivers and productivity is the currency of success, Warren Road stands as a beacon of organization. It's not merely about tracking furniture and equipment; it's about creating a symphony of order in the chaos of modern work life.")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.regular)
                        .foregroundColor(colors.darkBrown.opacity(0.8))
                        .multilineTextAlignment(.leading)
                    
                    Text("Every desk, every chair, every piece of technology becomes a note in the grand composition of workplace harmony. Warren Road orchestrates this symphony with precision and elegance.")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.regular)
                        .foregroundColor(colors.darkBrown.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                .adaptivePadding(.horizontal, 20)
                .adaptivePadding(.vertical, 16)
            }
            .shadow(color: colors.goldenBeige.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Features Section
    private var featuresSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Key Features")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            VStack(spacing: AdaptiveSize.spacing(12)) {
                featureCard(
                    icon: "archivebox.fill",
                    title: "Storage Management",
                    description: "Organize furniture and equipment by location and category"
                )
                
                featureCard(
                    icon: "chart.bar.fill",
                    title: "Statistics & Analytics",
                    description: "Track inventory value, condition, and usage patterns"
                )
                
                featureCard(
                    icon: "trophy.fill",
                    title: "Achievement System",
                    description: "Unlock achievements as you build your office inventory"
                )
                
                featureCard(
                    icon: "person.circle.fill",
                    title: "Profile Management",
                    description: "Customize your profile and work position information"
                )
                
                featureCard(
                    icon: "brain.head.profile",
                    title: "Intelligent Analytics",
                    description: "AI-powered insights into your storage patterns and efficiency"
                )
                
                featureCard(
                    icon: "cloud.fill",
                    title: "Cloud Synchronization",
                    description: "Seamless data sync across all your devices and platforms"
                )
            }
        }
    }
    
    // MARK: - Feature Card
    private func featureCard(icon: String, title: String, description: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.lightOlive.opacity(0.9),
                            colors.goldenBeige.opacity(0.8)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: AdaptiveSize.buttonHeight(80))
            
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(16))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            colors.green.opacity(0.6),
                            colors.warmBrown.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(height: AdaptiveSize.buttonHeight(80))
            
            HStack(spacing: AdaptiveSize.spacing(12)) {
                Image(systemName: icon)
                    .font(.system(size: AdaptiveSize.iconSize(20)))
                    .foregroundColor(colors.darkBrown)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                    Text(title)
                        .adaptiveFont(.headline, size: 16)
                        .fontWeight(.bold)
                        .foregroundColor(colors.darkBrown)
                    
                    Text(description)
                        .adaptiveFont(.caption, size: 12)
                        .fontWeight(.regular)
                        .foregroundColor(colors.darkBrown.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 16)
        }
        .shadow(color: colors.green.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Abstract Section
    private var abstractSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Digital Philosophy")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.lightOlive.opacity(0.9),
                                colors.green.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(140))
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.6),
                                colors.lightYellow.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(140))
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("In the vast digital landscape, where data flows like digital rivers and information creates mountains of knowledge, Warren Road emerges as a digital architect of order.")
                        .adaptiveFont(.body, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.darkBrown)
                        .multilineTextAlignment(.leading)
                    
                    Text("Like a master conductor leading an orchestra of productivity, Warren Road transforms the chaotic symphony of office life into a harmonious melody of efficiency and organization.")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.regular)
                        .foregroundColor(colors.darkBrown.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                .adaptivePadding(.horizontal, 20)
                .adaptivePadding(.vertical, 16)
            }
            .shadow(color: colors.green.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Philosophy Section
    private var philosophySection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("The Art of Organization")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.warmBrown.opacity(0.9),
                                colors.oliveBrown.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(160))
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.6),
                                colors.lightOlive.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(160))
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Every workspace tells a story. Warren Road doesn't just manage your inventory; it weaves the narrative of your professional journey through the digital tapestry of modern work.")
                        .adaptiveFont(.body, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightYellow)
                        .multilineTextAlignment(.leading)
                    
                    Text("From the humble beginnings of a single desk to the complex ecosystem of a thriving office, every item becomes a character in your success story. The chairs that support your team's dreams, the computers that process your innovations, the storage units that safeguard your memories - all orchestrated by Warren Road's digital symphony.")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.regular)
                        .foregroundColor(colors.lightYellow.opacity(0.9))
                        .multilineTextAlignment(.leading)
                }
                .adaptivePadding(.horizontal, 20)
                .adaptivePadding(.vertical, 16)
            }
            .shadow(color: colors.warmBrown.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Vision Section
    private var visionSection: some View {
        VStack(spacing: AdaptiveSize.spacing(15)) {
            HStack {
                Image(systemName: "eye.fill")
                    .font(.system(size: AdaptiveSize.iconSize(24)))
                    .foregroundColor(colors.lightYellow)
                
                Text("Future Vision")
                    .adaptiveFont(.title2, size: 20)
                    .fontWeight(.bold)
                    .foregroundColor(colors.lightYellow)
                
                Spacer()
            }
            .adaptivePadding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.green.opacity(0.8),
                                colors.lightOlive.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(140))
                
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colors.goldenBeige.opacity(0.6),
                                colors.lightYellow.opacity(0.4)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(minHeight: AdaptiveSize.buttonHeight(140))
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Warren Road envisions a future where every workspace becomes a canvas for innovation, where organization meets inspiration, and where the mundane transforms into the extraordinary.")
                        .adaptiveFont(.body, size: 16)
                        .fontWeight(.medium)
                        .foregroundColor(colors.lightYellow)
                        .multilineTextAlignment(.leading)
                    
                    Text("Join us on this journey of digital transformation, where every click, every entry, every achievement becomes a step toward a more organized, efficient, and inspiring workplace.")
                        .adaptiveFont(.body, size: 14)
                        .fontWeight(.regular)
                        .foregroundColor(colors.lightYellow.opacity(0.9))
                        .multilineTextAlignment(.leading)
                }
                .adaptivePadding(.horizontal, 20)
                .adaptivePadding(.vertical, 16)
            }
            .shadow(color: colors.green.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .adaptivePadding(.horizontal, 20)
    }
    
    // MARK: - Home Button
    private var homeButton: some View {
        Button(action: {
            router.currentScreen = .home
        }) {
            HStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Home")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(colors.lightYellow)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.goldenBeige.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colors.goldenBeige.opacity(0.6), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    RoadInfoView()
        .environmentObject(WarrenRouterView())
}
