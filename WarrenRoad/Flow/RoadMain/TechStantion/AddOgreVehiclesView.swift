//
//  AddOgreVehiclesView.swift

import SwiftUI

struct AddOgreVehiclesView: View {
    let storageIndex: Int
    @StateObject private var memory = WarrenUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var router: WarrenRouterView
    @State private var isAnimating = false
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var selectedCategory = EquipmentCategory.computers
    @State private var itemQuantity = 1
    @State private var itemValue = 0.0
    @State private var itemModel = ""
    @State private var condition = ItemCondition.new
    @State private var notes = ""
    @State private var waveOffset: CGFloat = 0
    @State private var particleOffset: CGFloat = 0

    private var storage: OfficeEquipmentStorage? {
        guard storageIndex < memory.equipmentStorage.count else { return nil }
        return memory.equipmentStorage[storageIndex]
    }
 
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green,
                                Color.green.opacity(0.8),
                                Color.gray.opacity(0.5),
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        WaveShapeEquipment(offset: waveOffset)
                            .fill(Color.darkBrown.opacity(0.1))
                            .ignoresSafeArea()
                            .animation(
                                Animation.linear(duration: 4.0)
                                    .repeatForever(autoreverses: false),
                                value: waveOffset
                            )
                        
                        ForEach(0..<10, id: \.self) { index in
                            TechFloatingElement(
                                index: index,
                                screenSize: geometry.size
                            )
                        }
                    }
                    
                    VStack(spacing: AdaptiveSize.spacing(20)) {
                        VStack(spacing: AdaptiveSize.spacing(10)) {
                            Text(storage?.name ?? "Equipment Storage")
                                .adaptiveFont(.largeTitle, size: AdaptiveSize.fontSize(28))
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
                                .shadow(color: Color.darkBrown.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            HStack(spacing: AdaptiveSize.spacing(8)) {
                                Image(systemName: "location.fill")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(14))
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                                
                                Text(storage?.location ?? "Unknown Location")
                                    .adaptiveFont(.title3, size: AdaptiveSize.fontSize(16))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.oliveBrown.opacity(0.9))
                            }
                        }
                        .adaptivePadding(.top, 20)
                        
                        HStack(spacing: AdaptiveSize.spacing(30)) {
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("\(storage?.items.count ?? 0)")
                                    .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkBrown)
                                
                                Text("Items")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                            }
                            
                            VStack(spacing: AdaptiveSize.spacing(4)) {
                                Text("$\(String(format: "%.0f", storageTotalValue))")
                                    .adaptiveFont(.title, size: AdaptiveSize.fontSize(24))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkBrown)
                                
                                Text("Total Value")
                                    .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                            }
                        }
                        .adaptivePadding(.vertical, 20)
                        .adaptivePadding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                .fill(Color.green.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(15))
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                        )
                        
                        if storage?.items.isEmpty == true {
                            VStack(spacing: AdaptiveSize.spacing(20)) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                gradient: Gradient(colors: [
                                                    Color.green.opacity(0.3),
                                                    Color.gray.opacity(0.1),
                                                    Color.clear
                                                ]),
                                                center: .center,
                                                startRadius: 0,
                                                endRadius: AdaptiveSize.iconSize(40)
                                            )
                                        )
                                        .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(80))
                                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                                        .animation(
                                            Animation.easeInOut(duration: 2.5)
                                                .repeatForever(autoreverses: true),
                                            value: isAnimating
                                        )
                                    
                                    Text("💻")
                                        .font(.system(size: AdaptiveSize.iconSize(40)))
                                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                                }
                                
                                Text("No Items Yet")
                                    .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkBrown)
                                
                                Text("Add your first equipment item to get started")
                                    .adaptiveFont(.body, size: AdaptiveSize.fontSize(16))
                                    .foregroundColor(Color.oliveBrown.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .adaptivePadding(.top, 50)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: AdaptiveSize.spacing(12)) {
                                    ForEach(storage?.items ?? []) { item in
                                        EquipmentItemCardView(item: item)
                                    }
                                }
                                .adaptivePadding(.horizontal, 20)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.currentScreen = .home
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.left.circle.fill")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(16))
                                .fontWeight(.semibold)
                            Text("Back")
                                .adaptiveFont(.caption, size: AdaptiveSize.fontSize(16))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(Color.lightYellow)
                        .adaptivePadding(.horizontal, 16)
                        .adaptivePadding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.darkBrown.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.darkBrown.opacity(0.6), lineWidth: 1)
                                )
                        )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItem = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .adaptiveFont(.title2, size: AdaptiveSize.fontSize(20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.lightYellow)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                isAnimating = true
                waveOffset = 360
                particleOffset = 360
            }
            memory.checkAndUnlockAchievements()
        }
        .sheet(isPresented: $showingAddItem) {
            AddEquipmentItemView(storageIndex: storageIndex)
        }
    }
    
    private var storageTotalValue: Double {
        return storage?.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) } ?? 0
    }
}

struct EquipmentItemCardView: View {
    let item: EquipmentItem
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AdaptiveSize.spacing(15)) {
            Text(item.emoji)
                .font(.system(size: AdaptiveSize.iconSize(30)))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(alignment: .leading, spacing: AdaptiveSize.spacing(4)) {
                Text(item.name)
                    .adaptiveFont(.title3, size: AdaptiveSize.fontSize(18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkBrown)
                
                if !item.model.isEmpty {
                    Text(item.model)
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                }
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text("Qty: \(item.quantity)")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .foregroundColor(Color.oliveBrown.opacity(0.8))
                    
                    Text("•")
                        .foregroundColor(Color.oliveBrown.opacity(0.6))
                    
                    Text("$\(String(format: "%.0f", item.value))")
                        .adaptiveFont(.body, size: AdaptiveSize.fontSize(14))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.darkBrown.opacity(0.9))
                }
                
                HStack(spacing: AdaptiveSize.spacing(8)) {
                    Text(item.category.displayName)
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .foregroundColor(Color.oliveBrown.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(Color.oliveBrown.opacity(0.6))
                    
                    Text(item.condition.displayName)
                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                        .foregroundColor(Color.oliveBrown.opacity(0.7))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AdaptiveSize.spacing(4)) {
                Text(item.condition.emoji)
                    .font(.system(size: AdaptiveSize.iconSize(16)))
                
                Text(item.condition.displayName)
                    .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                    .fontWeight(.medium)
                    .foregroundColor(Color.oliveBrown.opacity(0.8))
            }
        }
        .adaptivePadding(.all, 16)
        .background(
            RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                .fill(Color.green.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        )
        .onAppear {
            isAnimating = true
        }
    }
}

struct AddEquipmentItemView: View {
    let storageIndex: Int
    @StateObject private var memory = WarrenUserMemory.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemName = ""
    @State private var selectedCategory = EquipmentCategory.computers
    @State private var itemQuantity = 1
    @State private var itemValue = 0.0
    @State private var itemModel = ""
    @State private var condition = ItemCondition.new
    @State private var notes = ""
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Warren Road themed background with green, gray and black
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green,
                            Color.green.opacity(0.8),
                            Color.gray.opacity(0.5),
                            Color.black.opacity(0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: AdaptiveSize.spacing(20)) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.green.opacity(0.3),
                                                Color.gray.opacity(0.1),
                                                Color.clear
                                            ]),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: AdaptiveSize.iconSize(40)
                                        )
                                    )
                                    .frame(width: AdaptiveSize.iconSize(80), height: AdaptiveSize.iconSize(80))
                                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                                    .animation(
                                        Animation.easeInOut(duration: 2.5)
                                            .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                                
                                Text(selectedCategory.emoji)
                                    .font(.system(size: AdaptiveSize.iconSize(40)))
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                            }
                            .adaptivePadding(.vertical, 20)
                            
                            VStack(spacing: AdaptiveSize.spacing(16)) {
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Item Name")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.darkBrown)
                                    
                                    TextField("Enter item name", text: $itemName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Category")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.darkBrown)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: AdaptiveSize.spacing(12)) {
                                            ForEach(EquipmentCategory.allCases, id: \.self) { category in
                                                Button(action: {
                                                    selectedCategory = category
                                                }) {
                                                    VStack(spacing: AdaptiveSize.spacing(4)) {
                                                        Text(category.emoji)
                                                            .font(.system(size: AdaptiveSize.iconSize(24)))
                                                        
                                                        Text(category.displayName)
                                                            .adaptiveFont(.caption2, size: AdaptiveSize.fontSize(10))
                                                            .fontWeight(.medium)
                                                            .foregroundColor(selectedCategory == category ? .white : .primary)
                                                            .lineLimit(1)
                                                            .minimumScaleFactor(0.8)
                                                    }
                                                    .frame(width: AdaptiveSize.iconSize(90), height: AdaptiveSize.iconSize(75))
                                                    .background(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .fill(selectedCategory == category ?
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [Color.green, Color.gray.opacity(0.8)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  ) :
                                                                  LinearGradient(
                                                                    gradient: Gradient(colors: [Color.green.opacity(0.2), Color.gray.opacity(0.1)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                  )
                                                            )
                                                    )
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(12))
                                                            .stroke(selectedCategory == category ? Color.green : Color.gray.opacity(0.5), lineWidth: 2)
                                                    )
                                                }
                                            }
                                        }
                                        .adaptivePadding(.horizontal, 20)
                                    }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Quantity")
                                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color.darkBrown)
                                        
                                        Stepper("\(itemQuantity)", value: $itemQuantity, in: 1...1000)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                        Text("Value ($)")
                                            .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                            .fontWeight(.medium)
                                            .foregroundColor(Color.darkBrown)
                                        
                                        TextField("0", value: $itemValue, format: .number)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .background(Color.white.opacity(0.9))
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Model (Optional)")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.darkBrown)
                                    
                                    TextField("Enter model", text: $itemModel)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(Color.white.opacity(0.9))
                                }
                                
                                VStack(alignment: .leading, spacing: AdaptiveSize.spacing(8)) {
                                    Text("Condition")
                                        .adaptiveFont(.headline, size: AdaptiveSize.fontSize(16))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.darkBrown)
                                    
                                    HStack(spacing: AdaptiveSize.spacing(8)) {
                                        ForEach(ItemCondition.allCases, id: \.self) { conditionOption in
                                            Button(action: {
                                                condition = conditionOption
                                            }) {
                                                HStack(spacing: AdaptiveSize.spacing(4)) {
                                                    Text(conditionOption.emoji)
                                                        .font(.system(size: AdaptiveSize.iconSize(16)))
                                                    
                                                    Text(conditionOption.displayName)
                                                        .adaptiveFont(.caption, size: AdaptiveSize.fontSize(12))
                                                        .fontWeight(.medium)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.8)
                                                }
                                                .foregroundColor(condition == conditionOption ? .white : Color.darkBrown)
                                                .adaptivePadding(.horizontal, 12)
                                                .adaptivePadding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(8))
                                                        .fill(condition == conditionOption ?
                                                              LinearGradient(
                                                                gradient: Gradient(colors: [Color.green, Color.gray]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                              ) :
                                                              LinearGradient(
                                                                gradient: Gradient(colors: [Color.green.opacity(0.3), Color.gray.opacity(0.1)]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                              )
                                                        )
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: AdaptiveSize.cornerRadius(8))
                                                        .stroke(condition == conditionOption ? Color.green : Color.gray.opacity(0.5), lineWidth: 1)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            .adaptivePadding(.horizontal, 20)
                            
                            Spacer()
                            
                            Button(action: {
                                let newItem = EquipmentItem(
                                    name: itemName,
                                    model: itemModel,
                                    emoji: selectedCategory.emoji,
                                    category: selectedCategory,
                                    condition: condition,
                                    quantity: itemQuantity,
                                    value: itemValue,
                                    notes: notes
                                )
                                
                                if let storage = memory.equipmentStorage.first(where: { $0.id == memory.equipmentStorage[storageIndex].id }) {
                                    memory.addItemToEquipmentStorage(storageId: storage.id, item: newItem)
                                    memory.checkAndUnlockAchievements()
                                }
                                
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack {
                                    Text("Add Item")
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
                                            Color.gray,
                                            Color.green
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .adaptiveCornerRadius(25)
                            }
                            .disabled(itemName.isEmpty)
                            .opacity(itemName.isEmpty ? 0.6 : 1.0)
                            .adaptivePadding(.horizontal, 20)
                            .adaptivePadding(.bottom, 20)
                        }
                    }
                }
            }
            .navigationTitle("Add Equipment Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.darkBrown)
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Floating Elements
struct TechFloatingElement: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.3
    
    private let techIcons = ["💻", "🖥️", "⌨️", "🖱️", "📱", "📞", "📠", "🖨️", "📹", "📷", "🔌", "⚡"]
    
    private var elementColor: Color {
        let colors = [Color.green, Color.gray, Color.lightOlive, Color.goldenBeige, Color.darkBrown]
        return colors[index % colors.count]
    }
    
    private var elementSize: CGFloat {
        let sizes: [CGFloat] = [20, 25, 15, 30, 23, 27, 21, 24, 22, 19, 26, 28]
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
            
            Text(techIcons[index % techIcons.count])
                .font(.system(size: AdaptiveSize.iconSize(12)))
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
                    width: randomX + CGFloat.random(in: -60...60),
                    height: randomY + CGFloat.random(in: -60...60)
                )
                rotation = Double.random(in: 0...360)
                scale = CGFloat.random(in: 0.7...1.3)
                opacity = Double.random(in: 0.1...0.4)
            }
        }
    }
}

// MARK: - Wave Shape
struct WaveShapeEquipment: Shape {
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
            let y = midHeight + (sine * height * 0.12)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    AddOgreVehiclesView(storageIndex: 0)
}
