//
//  DeskDepotView.swift

import SwiftUI

struct DeskDepotView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @EnvironmentObject var router: WarrenRouterView
    @State private var isAnimating = false
    @State private var showingAddStorage = false
    @State private var newStorageName = ""
    @State private var newStorageLocation = ""
    @State private var newStorageDescription = ""
    @State private var waveOffset: CGFloat = 0
    @State private var particleOffset: CGFloat = 0

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
                    
                    WaveShapeDeskDepot(offset: waveOffset)
                        .fill(Color.darkBrown.opacity(0.1))
                        .ignoresSafeArea()
                        .animation(
                            Animation.linear(duration: 4.0)
                                .repeatForever(autoreverses: false),
                            value: waveOffset
                        )
                    
                    ForEach(0..<12, id: \.self) { index in
                        FurnitureElement(
                            index: index,
                            screenSize: geometry.size
                        )
                    }
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            router.currentScreen = .home
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.darkBrown.opacity(0.8),
                                                Color.warmBrown.opacity(0.6)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                                    .shadow(color: Color.darkBrown.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "arrow.left")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.lightYellow)
                            }
                        }
                        .adaptivePadding(.top, 48)
                        .adaptivePadding(.leading, 20)
                        
                        Spacer()
                        
                        VStack(spacing: AdaptiveSize.spacing(4)) {
                            Text("Desk Depot")
                                .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
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
                            
                            Text("Office Furniture Storage")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                .foregroundColor(Color.oliveBrown)
                        }
                        .adaptivePadding(.top, 48)
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color.clear)
                            .frame(width: AdaptiveSize.iconSize(50), height: AdaptiveSize.iconSize(50))
                            .adaptivePadding(.trailing, 20)
                    }
                    
                    Spacer()
                }
                
                VStack(spacing: AdaptiveSize.spacing(20)) {
                    Spacer()
                    
                    if memory.furnitureStorage.isEmpty {
                        VStack(spacing: AdaptiveSize.spacing(24)) {
                            ZStack {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    Color.green.opacity(0.3),
                                                    Color.lightOlive.opacity(0.1),
                                                    Color.clear
                                                ]),
                                                center: .center,
                                                startRadius: 0,
                                                endRadius: AdaptiveSize.iconSize(60)
                                            )
                                        )
                                        .frame(width: AdaptiveSize.iconSize(120), height: AdaptiveSize.iconSize(120))
                                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                                        .animation(
                                            Animation.easeInOut(duration: 2.5)
                                                .repeatForever(autoreverses: true),
                                            value: isAnimating
                                        )
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.darkBrown.opacity(0.8),
                                                    Color.warmBrown.opacity(0.6)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(80))
                                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                                        .animation(
                                            Animation.easeInOut(duration: 1.8)
                                                .repeatForever(autoreverses: true),
                                            value: isAnimating
                                        )
                                    
                                    Text("🪑")
                                        .font(.system(size: AdaptiveSize.iconSize(40)))
                                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                                        .animation(
                                            Animation.easeInOut(duration: 2.0)
                                                .repeatForever(autoreverses: true),
                                            value: isAnimating
                                        )
                                }
                            }
                            
                            VStack(spacing: AdaptiveSize.spacing(15)) {
                                Text("Create Your First \nFurniture Storage")
                                    .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
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
                                    .multilineTextAlignment(.center)
                                    .shadow(color: Color.darkBrown.opacity(0.3), radius: 2, x: 0, y: 1)
                                
                                Text("Start organizing your office furniture by creating your first storage")
                                    .adaptiveFont(.body, size: AdaptiveSize.fontSize(16))
                                    .foregroundColor(Color.oliveBrown.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .adaptivePadding(.horizontal, 40)
                                    .lineSpacing(4)
                            }
                        }
                        .adaptivePadding(.top, 60)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: AdaptiveSize.spacing(15)) {
                                ForEach(Array(memory.furnitureStorage.enumerated()), id: \.element.id) { index, storage in
                                    FurnitureStorageCardView(storage: storage)
                                        .onTapGesture {
                                            router.selectedDeskIndex = index
                                            router.currentScreen = .addFurniture                                     }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                        }
                        .adaptivePadding(.top, 80)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingAddStorage = true
                        }) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.green.opacity(0.8),
                                                Color.lightOlive.opacity(0.6)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 3
                                    )
                                    .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(80))
                                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                                    .animation(
                                        Animation.easeInOut(duration: 2.0)
                                            .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                
                                // Main button
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.green,
                                                Color.lightOlive,
                                                Color.green
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(70), height: AdaptiveSize.iconSize(70))
                                    .shadow(color: Color.green.opacity(0.6), radius: 12, x: 0, y: 6)
                                
                                // Inner highlight
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.lightYellow.opacity(0.3),
                                                Color.clear
                                            ]),
                                            center: .topLeading,
                                            startRadius: 0,
                                            endRadius: AdaptiveSize.iconSize(35)
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(70), height: AdaptiveSize.iconSize(70))
                                
                                // Plus icon
                                Image(systemName: "plus")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.lightYellow)
                                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                            }
                        }
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                        .adaptivePadding(.trailing, 30)
                        .adaptivePadding(.bottom, 30)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                isAnimating = true
                waveOffset = 360
                particleOffset = 360
            }
            memory.checkAndUnlockAchievements()
        }
        .sheet(isPresented: $showingAddStorage) {
            AddFurnitureStorageView(
                storageName: $newStorageName,
                storageLocation: $newStorageLocation,
                storageDescription: $newStorageDescription,
                onSave: {
                    let newStorage = OfficeFurnitureStorage(
                        name: newStorageName,
                        location: newStorageLocation,
                        description: newStorageDescription
                    )
                    memory.addFurnitureStorage(newStorage)
                    newStorageName = ""
                    newStorageLocation = ""
                    newStorageDescription = ""
                    showingAddStorage = false
                }
            )
        }
    }
}

struct FurnitureElement: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3
    
    private let furnitureIcons = ["🪑", "🛋️", "🪞", "🪟", "📦", "🗄️", "🪚", "🔨", "📐", "📏", "🪜", "🪞"]
    
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
            
            Text(furnitureIcons[index % furnitureIcons.count])
                .font(.system(size: AdaptiveSize.iconSize(16)))
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

struct FurnitureStorageCardView: View {
    let storage: OfficeFurnitureStorage
    @State private var isAnimating = false
    
    private var storageTotalValue: Double {
        return storage.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            HStack {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(6)) {
                    Text(storage.name)
                        .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
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
                        .shadow(color: Color.darkBrown.opacity(0.3), radius: 1, x: 0, y: 1)
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Image(systemName: "location.fill")
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .foregroundColor(Color.oliveBrown.opacity(0.8))
                        
                        Text(storage.location)
                            .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                            .fontWeight(.medium)
                            .foregroundColor(Color.oliveBrown.opacity(0.9))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(8)) {
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("🪑")
                            .font(.system(size: AdaptiveSize.iconSize(16)))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.2), value: isAnimating)
                        
                        Text("\(storage.items.count)")
                            .adaptiveFont(.title3, size: AdaptiveSize.fontSize(18))
                            .fontWeight(.bold)
                            .foregroundColor(Color.darkBrown)
                            .shadow(color: Color.darkBrown.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    
                    Text("Items")
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .fontWeight(.medium)
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("💰")
                            .font(.system(size: AdaptiveSize.iconSize(14)))
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.5), value: isAnimating)
                        
                        Text(formatCurrency(storageTotalValue))
                            .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.darkBrown)
                            .shadow(color: Color.darkBrown.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    
                    Text("Total Value")
                        .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                        .fontWeight(.medium)
                        .foregroundColor(Color.oliveBrown.opacity(0.7))
                }
            }
            
            if !storage.description.isEmpty {
                Text(storage.description)
                    .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                    .fontWeight(.medium)
                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                    .lineLimit(2)
                    .adaptivePadding(.vertical, 4)
            }
            
            HStack {
                HStack(spacing: AdaptiveSize.spacing(4)) {
                    Image(systemName: "calendar")
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(10))
                        .foregroundColor(Color.oliveBrown.opacity(0.6))
                    
                    Text("Created: \(storage.createdAt, formatter: dateFormatter)")
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .fontWeight(.medium)
                        .foregroundColor(Color.oliveBrown.opacity(0.7))
                }
                
                Spacer()
                
                HStack(spacing: AdaptiveSize.spacing(4)) {
                    Circle()
                        .fill(storage.items.isEmpty ? Color.gray.opacity(0.8) : Color.green.opacity(0.8))
                        .frame(width: AdaptiveSize.iconSize(8), height: AdaptiveSize.iconSize(8))
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text(storage.items.isEmpty ? "Empty" : "Active")
                        .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                }
            }
        }
        .adaptivePadding(.horizontal, 20)
        .adaptivePadding(.vertical, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.lightYellow.opacity(0.8),
                                Color.goldenBeige.opacity(0.6)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.6),
                                Color.lightOlive.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(20))
                    .stroke(Color.green.opacity(0.4), lineWidth: 1)
            }
        )
        .shadow(color: Color.darkBrown.opacity(0.3), radius: 8, x: 0, y: 4)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    private func formatCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
}

struct AddFurnitureStorageView: View {
    @Binding var storageName: String
    @Binding var storageLocation: String
    @Binding var storageDescription: String
    let onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: AdaptiveSize.spacing(20)) {
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Storage Name")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.medium)
                        .foregroundColor(Color.darkBrown)
                    
                    TextField("Enter storage name", text: $storageName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Color.darkBrown)
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Location")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.medium)
                        .foregroundColor(Color.darkBrown)
                    
                    TextField("Enter location", text: $storageLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Color.darkBrown)
                }
                
                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                    Text("Description (Optional)")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.medium)
                        .foregroundColor(Color.darkBrown)
                    
                    TextField("Enter description", text: $storageDescription, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                        .foregroundColor(Color.darkBrown)
                }
                
                Spacer()
                
                Button(action: onSave) {
                    HStack {
                        Text("Create Storage")
                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(18))
                            .fontWeight(.semibold)
                        Image(systemName: "plus.circle.fill")
                            .adaptiveFont(.title2, size: AdaptiveSize.fontSize(18))
                    }
                    .foregroundColor(Color.lightYellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: AdaptiveSize.buttonHeight(50))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green,
                                Color.lightOlive,
                                Color.green
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .adaptiveCornerRadius(25)
                }
                .disabled(storageName.isEmpty || storageLocation.isEmpty)
                .opacity(storageName.isEmpty || storageLocation.isEmpty ? 0.6 : 1.0)
            }
            .adaptivePadding(.all, 20)
            .background(
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
            )
            .navigationTitle("New Furniture Storage")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.darkBrown)
            )
        }
    }
}

// MARK: - Wave Shape
struct WaveShapeDeskDepot: Shape {
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.4
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX * .pi * 2) + (offset * .pi / 180))
            let y = midHeight + (sine * height * 0.15)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    DeskDepotView()
}
