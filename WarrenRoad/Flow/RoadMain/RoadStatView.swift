//
//  RoadStatView.swift

import SwiftUI

struct RoadStatView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @EnvironmentObject var router: WarrenRouterView
    @State private var isAnimating = false
    
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
                
                ForEach(0..<6, id: \.self) { index in
                    FloatingStatElement(
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
                                .foregroundColor(Color.darkBrown)
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
                                Text("Analytics")
                                    .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkBrown)
                                
                                Text("Storage Insights")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    isAnimating.toggle()
                                }
                            }) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                    .foregroundColor(Color.black)
                                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                    .animation(.easeInOut(duration: 0.6), value: isAnimating)
                            }
                        }
                        .adaptivePadding(.horizontal, 20)
                        .adaptivePadding(.top, 20)
                        
                        // Quick Stats Row
                        HStack(spacing: AdaptiveSize.spacing(12)) {
                            QuickStatCard(
                                title: "Storages",
                                value: "\(memory.furnitureStorage.count + memory.equipmentStorage.count)",
                                icon: "📦",
                                color: Color.green,
                                isAnimating: isAnimating
                            )
                            
                            QuickStatCard(
                                title: "Items",
                                value: "\(memory.getTotalItemCount())",
                                icon: "📊",
                                color: Color.oliveBrown,
                                isAnimating: isAnimating
                            )
                            
                            QuickStatCard(
                                title: "Value",
                                value: formatCurrency(memory.getTotalItemValue()),
                                icon: "💰",
                                color: Color.goldenBeige,
                                isAnimating: isAnimating
                            )
                        }
                        .adaptivePadding(.horizontal, 20)
                        
                        // Storage Distribution Chart
                        StorageDistributionView()
                            .adaptivePadding(.horizontal, 20)
                        
                        // Furniture vs Equipment Comparison
                        ComparisonView()
                            .adaptivePadding(.horizontal, 20)
                        
                        // Recent Activity
                        RecentActivityView()
                            .adaptivePadding(.horizontal, 20)
                        
                        // Storage Details
                        StorageDetailsView()
                            .adaptivePadding(.horizontal, 20)
                            .adaptivePadding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
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

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isAnimating: Bool
    
    var body: some View {
        VStack(spacing: AdaptiveSize.spacing(8)) {
            Text(icon)
                .font(.system(size: AdaptiveSize.iconSize(20)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text(value)
                .adaptiveFont(.title3, size: AdaptiveSize.fontSize(18))
                .fontWeight(.bold)
                .foregroundColor(Color.darkBrown)
            
            Text(title)
                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(10))
                .fontWeight(.medium)
                .foregroundColor(Color.oliveBrown.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .adaptivePadding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.15),
                            color.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Storage Distribution View
struct StorageDistributionView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            Text("Storage Distribution")
                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                .fontWeight(.bold)
                .foregroundColor(Color.darkBrown)
            
            HStack(spacing: AdaptiveSize.spacing(20)) {
                // Furniture
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.green.opacity(0.3),
                                        Color.green.opacity(0.1),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: AdaptiveSize.iconSize(30)
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        Text("🪑")
                            .font(.system(size: AdaptiveSize.iconSize(24)))
                    }
                    
                    VStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("Furniture")
                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                            .fontWeight(.bold)
                            .foregroundColor(Color.darkBrown)
                        
                        Text("\(memory.furnitureStorage.count)")
                            .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.green)
                        
                        Text("Storages")
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .foregroundColor(Color.oliveBrown.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity)
                .adaptivePadding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .fill(Color.lightYellow.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                .stroke(Color.green.opacity(0.5), lineWidth: 1)
                        )
                )
                
                // Equipment
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.gray.opacity(0.3),
                                        Color.gray.opacity(0.1),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: AdaptiveSize.iconSize(30)
                                )
                            )
                            .frame(width: AdaptiveSize.iconSize(60), height: AdaptiveSize.iconSize(60))
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true).delay(0.3), value: isAnimating)
                        
                        Text("💻")
                            .font(.system(size: AdaptiveSize.iconSize(24)))
                    }
                    
                    VStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("Equipment")
                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                            .fontWeight(.bold)
                            .foregroundColor(Color.darkBrown)
                        
                        Text("\(memory.equipmentStorage.count)")
                            .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.oliveBrown)
                        
                        Text("Storages")
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .foregroundColor(Color.oliveBrown.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity)
                .adaptivePadding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                        .fill(Color.oliveBrown.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                .stroke(Color.oliveBrown.opacity(0.5), lineWidth: 1)
                        )
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Comparison View
struct ComparisonView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var isAnimating = false
    
    private var furnitureItems: Int {
        memory.furnitureStorage.flatMap { $0.items }.reduce(0) { $0 + $1.quantity }
    }
    
    private var equipmentItems: Int {
        memory.equipmentStorage.flatMap { $0.items }.reduce(0) { $0 + $1.quantity }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            Text("Items Comparison")
                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                .fontWeight(.bold)
                .foregroundColor(Color.darkBrown)
            
            VStack(spacing: AdaptiveSize.spacing(12)) {
                // Furniture bar
                HStack {
                    Text("🪑 Furniture")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.medium)
                        .foregroundColor(Color.darkBrown)
                    
                    Spacer()
                    
                    Text("\(furnitureItems)")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                }
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.green.opacity(0.8))
                            .frame(width: furnitureItems > 0 ? geometry.size.width * CGFloat(furnitureItems) / CGFloat(max(furnitureItems, equipmentItems, 1)) : 0)
                            .scaleEffect(isAnimating ? 1.0 : 0.0, anchor: .leading)
                            .animation(.easeOut(duration: 1.0).delay(0.2), value: isAnimating)
                        
                        Rectangle()
                            .fill(Color.oliveBrown.opacity(0.8))
                            .frame(width: equipmentItems > 0 ? geometry.size.width * CGFloat(equipmentItems) / CGFloat(max(furnitureItems, equipmentItems, 1)) : 0)
                            .scaleEffect(isAnimating ? 1.0 : 0.0, anchor: .trailing)
                            .animation(.easeOut(duration: 1.0).delay(0.4), value: isAnimating)
                    }
                }
                .frame(height: AdaptiveSize.iconSize(8))
                .background(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(4))
                        .fill(Color.oliveBrown.opacity(0.2))
                )
                
                // Equipment bar
                HStack {
                    Text("💻 Equipment")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.medium)
                        .foregroundColor(Color.darkBrown)
                    
                    Spacer()
                    
                    Text("\(equipmentItems)")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.bold)
                        .foregroundColor(Color.oliveBrown)
                }
            }
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

// MARK: - Recent Activity View
struct RecentActivityView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            Text("Recent Activity")
                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                .fontWeight(.bold)
                .foregroundColor(Color.darkBrown)
            
            if memory.furnitureStorage.isEmpty && memory.equipmentStorage.isEmpty {
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    Text("📊")
                        .font(.system(size: AdaptiveSize.iconSize(40)))
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text("No Activity Yet")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBrown)
                    
                    Text("Create your first storage to see activity")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .adaptivePadding(.vertical, 30)
            } else {
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    ForEach(Array(memory.furnitureStorage.prefix(3).enumerated()), id: \.element.id) { index, storage in
                        ActivityItem(
                            title: storage.name,
                            subtitle: "Furniture Storage",
                            icon: "🪑",
                            color: Color.green,
                            index: index,
                            isAnimating: isAnimating
                        )
                    }
                    
                    ForEach(Array(memory.equipmentStorage.prefix(3).enumerated()), id: \.element.id) { index, storage in
                        ActivityItem(
                            title: storage.name,
                            subtitle: "Equipment Storage",
                            icon: "💻",
                            color: Color.gray,
                            index: index + memory.furnitureStorage.count,
                            isAnimating: isAnimating
                        )
                    }
                }
            }
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

// MARK: - Activity Item
struct ActivityItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let index: Int
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(12)) {
            Text(icon)
                .font(.system(size: AdaptiveSize.iconSize(20)))
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: isAnimating)
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(2)) {
                Text(title)
                    .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                    .fontWeight(.medium)
                    .foregroundColor(Color.darkBrown)
                
                Text(subtitle)
                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                    .foregroundColor(Color.oliveBrown.opacity(0.7))
            }
            
            Spacer()
            
            Circle()
                .fill(color.opacity(0.3))
                .frame(width: AdaptiveSize.iconSize(8), height: AdaptiveSize.iconSize(8))
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
        }
        .adaptivePadding(.vertical, 8)
    }
}

// MARK: - Storage Details View
struct StorageDetailsView: View {
    @StateObject private var memory = WarrenUserMemory.shared
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AdaptiveSize.spacing(16)) {
            Text("Storage Details")
                .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                .fontWeight(.bold)
                .foregroundColor(Color.darkBrown)
            
            if memory.furnitureStorage.isEmpty && memory.equipmentStorage.isEmpty {
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    Text("📦")
                        .font(.system(size: AdaptiveSize.iconSize(40)))
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Text("No Storage Created")
                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                        .fontWeight(.bold)
                        .foregroundColor(Color.darkBrown)
                    
                    Text("Create your first storage to see details")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .adaptivePadding(.vertical, 30)
            } else {
                VStack(spacing: AdaptiveSize.spacing(12)) {
                    ForEach(Array(memory.furnitureStorage.prefix(2).enumerated()), id: \.element.id) { index, storage in
                        StorageDetailCard(
                            storage: storage,
                            type: "Furniture",
                            icon: "🪑",
                            color: Color.green,
                            index: index,
                            isAnimating: isAnimating
                        )
                    }
                    
                    ForEach(Array(memory.equipmentStorage.prefix(2).enumerated()), id: \.element.id) { index, storage in
                        StorageDetailCard(
                            storage: storage,
                            type: "Equipment",
                            icon: "💻",
                            color: Color.gray,
                            index: index + memory.furnitureStorage.count,
                            isAnimating: isAnimating
                        )
                    }
                }
            }
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

// MARK: - Storage Detail Card
struct StorageDetailCard: View {
    let storage: Any // Can be OfficeFurnitureStorage or OfficeEquipmentStorage
    let type: String
    let icon: String
    let color: Color
    let index: Int
    let isAnimating: Bool
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(12)) {
            Text(icon)
                .font(.system(size: AdaptiveSize.iconSize(24)))
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: isAnimating)
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                Text(getStorageName())
                    .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkBrown)
                
                Text("\(type) • \(getStorageLocation())")
                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                    .foregroundColor(Color.oliveBrown.opacity(0.7))
                
                HStack(spacing: AdaptiveSize.spacing(16)) {
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("📊")
                            .font(.system(size: AdaptiveSize.iconSize(12)))
                        Text("\(getItemCount())")
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .fontWeight(.medium)
                            .foregroundColor(Color.darkBrown)
                    }
                    
                    HStack(spacing: AdaptiveSize.spacing(4)) {
                        Text("💰")
                            .font(.system(size: AdaptiveSize.iconSize(12)))
                        Text(formatCurrency(getTotalValue()))
                            .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                            .fontWeight(.medium)
                            .foregroundColor(Color.darkBrown)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: AdaptiveSize.spacing(4)) {
                Circle()
                    .fill(color.opacity(0.3))
                    .frame(width: AdaptiveSize.iconSize(12), height: AdaptiveSize.iconSize(12))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
                
                Text("Active")
                    .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                    .fontWeight(.medium)
                    .foregroundColor(Color.oliveBrown.opacity(0.7))
            }
        }
        .adaptivePadding(.all, 12)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(10))
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func getStorageName() -> String {
        if let furnitureStorage = storage as? OfficeFurnitureStorage {
            return furnitureStorage.name
        } else if let equipmentStorage = storage as? OfficeEquipmentStorage {
            return equipmentStorage.name
        }
        return "Unknown"
    }
    
    private func getStorageLocation() -> String {
        if let furnitureStorage = storage as? OfficeFurnitureStorage {
            return furnitureStorage.location
        } else if let equipmentStorage = storage as? OfficeEquipmentStorage {
            return equipmentStorage.location
        }
        return "Unknown"
    }
    
    private func getItemCount() -> Int {
        if let furnitureStorage = storage as? OfficeFurnitureStorage {
            return furnitureStorage.items.reduce(0) { $0 + $1.quantity }
        } else if let equipmentStorage = storage as? OfficeEquipmentStorage {
            return equipmentStorage.items.reduce(0) { $0 + $1.quantity }
        }
        return 0
    }
    
    private func getTotalValue() -> Double {
        if let furnitureStorage = storage as? OfficeFurnitureStorage {
            return furnitureStorage.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        } else if let equipmentStorage = storage as? OfficeEquipmentStorage {
            return equipmentStorage.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        }
        return 0
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

// MARK: - Floating Stat Element
struct FloatingStatElement: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.2
    
    private let statIcons = ["📊", "📈", "📉", "💰", "📦", "🔄"]
    
    private var elementColor: Color {
        let colors = [Color.green, Color.lightOlive, Color.goldenBeige, Color.lightYellow, Color.warmBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [15, 20, 12, 25, 18, 22]
        return AdaptiveSize.iconSize(sizes[index % sizes.count])
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            elementColor.opacity(0.3),
                            elementColor.opacity(0.1),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: elementSize / 2
                    )
                )
                .frame(width: elementSize, height: elementSize)
            
            Text(statIcons[index % statIcons.count])
                .font(.system(size: AdaptiveSize.iconSize(10)))
                .foregroundColor(Color.darkBrown.opacity(0.4))
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
                .easeInOut(duration: Double.random(in: 10...20))
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: randomX + CGFloat.random(in: -40...40),
                    height: randomY + CGFloat.random(in: -40...40)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.8...1.2)
                opacity = Double.random(in: 0.1...0.3)
            }
        }
    }
}


#Preview {
    RoadStatView()
}
