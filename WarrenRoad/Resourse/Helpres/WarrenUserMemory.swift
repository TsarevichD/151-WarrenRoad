//
//  WarrenUserMemory.swift


// MARK: - Furniture Item
struct FurnitureItem: Codable, Identifiable {
    let id: UUID
    var name: String
    var model: String
    var emoji: String
    var category: FurnitureCategory
    var condition: ItemCondition
    var quantity: Int
    var value: Double
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, model: String = "", emoji: String, category: FurnitureCategory, condition: ItemCondition = .new, quantity: Int = 1, value: Double = 0.0, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.model = model
        self.emoji = emoji
        self.category = category
        self.condition = condition
        self.quantity = quantity
        self.value = value
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Equipment Item
struct EquipmentItem: Codable, Identifiable {
    let id: UUID
    var name: String
    var model: String
    var emoji: String
    var category: EquipmentCategory
    var condition: ItemCondition
    var quantity: Int
    var value: Double
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, model: String = "", emoji: String, category: EquipmentCategory, condition: ItemCondition = .new, quantity: Int = 1, value: Double = 0.0, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.model = model
        self.emoji = emoji
        self.category = category
        self.condition = condition
        self.quantity = quantity
        self.value = value
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum ItemCondition: String, Codable, CaseIterable {
    case new = "New"
    case used = "Used"
    case needsRepair = "Needs Repair"
    
    var displayName: String {
        switch self {
        case .new:
            return "New"
        case .used:
            return "Used"
        case .needsRepair:
            return "Needs Repair"
        }
    }
    
    var color: String {
        switch self {
        case .new:
            return "#10B981"
        case .used:
            return "#3B82F6"
        case .needsRepair:
            return "#EF4444"
        }
    }
    
    var emoji: String {
        switch self {
        case .new:
            return "✨"
        case .used:
            return "👍"
        case .needsRepair:
            return "🔧"
        }
    }
}

// MARK: - Furniture Categories
enum FurnitureCategory: String, Codable, CaseIterable {
    case chairs = "Chairs"
    case desks = "Desks"
    case storage = "Storage"
    case tables = "Tables"
    case other = "Other"
    
    var displayName: String {
        switch self {
        case .chairs:
            return "Chairs"
        case .desks:
            return "Desks"
        case .storage:
            return "Storage"
        case .tables:
            return "Tables"
        case .other:
            return "Other"
        }
    }
    
    var emoji: String {
        switch self {
        case .chairs:
            return "🪑"
        case .desks:
            return "🪚"
        case .storage:
            return "🗄️"
        case .tables:
            return "🪞"
        case .other:
            return "📦"
        }
    }
}

// MARK: - Equipment Categories
enum EquipmentCategory: String, Codable, CaseIterable {
    case computers = "Computers"
    case electronics = "Electronics"
    case officeSupplies = "Office Supplies"
    case equipment = "Equipment"
    case other = "Other"
    
    var displayName: String {
        switch self {
        case .computers:
            return "Computers"
        case .electronics:
            return "Electronics"
        case .officeSupplies:
            return "Office Supplies"
        case .equipment:
            return "Equipment"
        case .other:
            return "Other"
        }
    }
    
    var emoji: String {
        switch self {
        case .computers:
            return "💻"
        case .electronics:
            return "📱"
        case .officeSupplies:
            return "📋"
        case .equipment:
            return "⚙️"
        case .other:
            return "📦"
        }
    }
}


// MARK: - Storage Collections

struct OfficeFurnitureStorage: Codable, Identifiable {
    let id: UUID
    var name: String
    var location: String
    var description: String
    var items: [FurnitureItem]
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, location: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.location = location
        self.description = description
        self.items = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addItem(_ item: FurnitureItem) {
        items.append(item)
        updatedAt = Date()
    }
    
    mutating func removeItem(_ itemId: UUID) {
        items.removeAll { $0.id == itemId }
        updatedAt = Date()
    }
    
    mutating func updateItem(_ item: FurnitureItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            updatedAt = Date()
        }
    }
}

struct OfficeEquipmentStorage: Codable, Identifiable {
    let id: UUID
    var name: String
    var location: String
    var description: String
    var items: [EquipmentItem]
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, location: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.location = location
        self.description = description
        self.items = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func addItem(_ item: EquipmentItem) {
        items.append(item)
        updatedAt = Date()
    }
    
    mutating func removeItem(_ itemId: UUID) {
        items.removeAll { $0.id == itemId }
        updatedAt = Date()
    }
    
    mutating func updateItem(_ item: EquipmentItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            updatedAt = Date()
        }
    }
}



import Foundation
import SwiftUI

// MARK: - Achievement System
struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let emoji: String
    let category: AchievementCategory
    let requirement: Int
    var isUnlocked: Bool
    var unlockedAt: Date?
    let points: Int
    
    init(id: String, title: String, description: String, emoji: String, category: AchievementCategory, requirement: Int, points: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.emoji = emoji
        self.category = category
        self.requirement = requirement
        self.isUnlocked = false
        self.unlockedAt = nil
        self.points = points
    }
}

enum AchievementCategory: String, Codable, CaseIterable {
    case storage = "Storage"
    case items = "Items"
    case value = "Value"
    case collection = "Collection"
    case efficiency = "Efficiency"
    
    var displayName: String {
        switch self {
        case .storage: return "Storage Master"
        case .items: return "Item Collector"
        case .value: return "Value Expert"
        case .collection: return "Collection Pro"
        case .efficiency: return "Efficiency Guru"
        }
    }
    
    var emoji: String {
        switch self {
        case .storage: return "📦"
        case .items: return "📚"
        case .value: return "💰"
        case .collection: return "🎯"
        case .efficiency: return "⚡"
        }
    }
    
    var color: Color {
        switch self {
        case .storage: return Color.green
        case .items: return Color.blue
        case .value: return Color.goldenBeige
        case .collection: return Color.purple
        case .efficiency: return Color.orange
        }
    }
}

class WarrenUserMemory: ObservableObject {
    
    static let shared = WarrenUserMemory()
    
    private let defaults = UserDefaults.standard
    private let furnitureStorageKey = "furnitureStorage"
    private let equipmentStorageKey = "equipmentStorage"
    private let onboardingCompletedKey = "onboardingCompleted"
    private let achievementsKey = "achievements"
    private let totalPointsKey = "totalPoints"

    private init() {
        self.hasCompletedOnboarding = defaults.bool(forKey: onboardingCompletedKey)
        self.loadFurnitureStorage()
        self.loadEquipmentStorage()
        self.loadAchievements()
    }
    
    
    @Published private(set) var furnitureStorage: [OfficeFurnitureStorage] = [] {
        didSet {
            saveFurnitureStorage()
        }
    }
    
    @Published private(set) var equipmentStorage: [OfficeEquipmentStorage] = [] {
        didSet {
            saveEquipmentStorage()
        }
    }
   
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            defaults.set(hasCompletedOnboarding, forKey: onboardingCompletedKey)
        }
    }
    
    @Published private(set) var achievements: [Achievement] = [] {
        didSet {
            saveAchievements()
        }
    }
    
    @Published private(set) var totalPoints: Int = 0 {
        didSet {
            defaults.set(totalPoints, forKey: totalPointsKey)
        }
    }
    
    private func loadFurnitureStorage() {
        if let data = defaults.data(forKey: furnitureStorageKey) {
            let decoder = JSONDecoder()
            if let loadedStorage = try? decoder.decode([OfficeFurnitureStorage].self, from: data) {
                self.furnitureStorage = loadedStorage
            }
        } else {
            self.furnitureStorage = []
        }
    }
    
    private func saveFurnitureStorage() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(furnitureStorage) {
            defaults.set(encoded, forKey: furnitureStorageKey)
        }
    }
    
    private func loadEquipmentStorage() {
        if let data = defaults.data(forKey: equipmentStorageKey) {
            let decoder = JSONDecoder()
            if let loadedStorage = try? decoder.decode([OfficeEquipmentStorage].self, from: data) {
                self.equipmentStorage = loadedStorage
            }
        } else {
            self.equipmentStorage = []
        }
    }
    
    private func saveEquipmentStorage() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(equipmentStorage) {
            defaults.set(encoded, forKey: equipmentStorageKey)
        }
    }
    
    func addFurnitureStorage(_ storage: OfficeFurnitureStorage) {
        furnitureStorage.append(storage)
    }
    
    func updateFurnitureStorage(_ storage: OfficeFurnitureStorage) {
        if let index = furnitureStorage.firstIndex(where: { $0.id == storage.id }) {
            furnitureStorage[index] = storage
        }
    }
    
    func deleteFurnitureStorage(_ storageId: UUID) {
        furnitureStorage.removeAll { $0.id == storageId }
    }
    
    func getFurnitureStorage(by id: UUID) -> OfficeFurnitureStorage? {
        return furnitureStorage.first { $0.id == id }
    }
    
    
    func addEquipmentStorage(_ storage: OfficeEquipmentStorage) {
        equipmentStorage.append(storage)
    }
    
    func updateEquipmentStorage(_ storage: OfficeEquipmentStorage) {
        if let index = equipmentStorage.firstIndex(where: { $0.id == storage.id }) {
            equipmentStorage[index] = storage
        }
    }
    
    func deleteEquipmentStorage(_ storageId: UUID) {
        equipmentStorage.removeAll { $0.id == storageId }
    }
    
    func getEquipmentStorage(by id: UUID) -> OfficeEquipmentStorage? {
        return equipmentStorage.first { $0.id == id }
    }
    
    
    func addItemToFurnitureStorage(storageId: UUID, item: FurnitureItem) {
        if let index = furnitureStorage.firstIndex(where: { $0.id == storageId }) {
            furnitureStorage[index].addItem(item)
        }
    }
    
    func updateItemInFurnitureStorage(storageId: UUID, item: FurnitureItem) {
        if let index = furnitureStorage.firstIndex(where: { $0.id == storageId }) {
            furnitureStorage[index].updateItem(item)
        }
    }
    
    func removeItemFromFurnitureStorage(storageId: UUID, itemId: UUID) {
        if let index = furnitureStorage.firstIndex(where: { $0.id == storageId }) {
            furnitureStorage[index].removeItem(itemId)
        }
    }
    
    func getItemsFromFurnitureStorage(storageId: UUID) -> [FurnitureItem] {
        return furnitureStorage.first { $0.id == storageId }?.items ?? []
    }
    
    
    func addItemToEquipmentStorage(storageId: UUID, item: EquipmentItem) {
        if let index = equipmentStorage.firstIndex(where: { $0.id == storageId }) {
            equipmentStorage[index].addItem(item)
        }
    }
    
    func updateItemInEquipmentStorage(storageId: UUID, item: EquipmentItem) {
        if let index = equipmentStorage.firstIndex(where: { $0.id == storageId }) {
            equipmentStorage[index].updateItem(item)
        }
    }
    
    func removeItemFromEquipmentStorage(storageId: UUID, itemId: UUID) {
        if let index = equipmentStorage.firstIndex(where: { $0.id == storageId }) {
            equipmentStorage[index].removeItem(itemId)
        }
    }
    
    func getItemsFromEquipmentStorage(storageId: UUID) -> [EquipmentItem] {
        return equipmentStorage.first { $0.id == storageId }?.items ?? []
    }
    
    func getFurnitureItemsByCategory(_ category: FurnitureCategory) -> [FurnitureItem] {
        let furnitureItems = furnitureStorage.flatMap { $0.items }
        return furnitureItems.filter { $0.category == category }
    }
    
    func getEquipmentItemsByCategory(_ category: EquipmentCategory) -> [EquipmentItem] {
        let equipmentItems = equipmentStorage.flatMap { $0.items }
        return equipmentItems.filter { $0.category == category }
    }
    
    func getFurnitureItemsByCondition(_ condition: ItemCondition) -> [FurnitureItem] {
        let furnitureItems = furnitureStorage.flatMap { $0.items }
        return furnitureItems.filter { $0.condition == condition }
    }
    
    func getEquipmentItemsByCondition(_ condition: ItemCondition) -> [EquipmentItem] {
        let equipmentItems = equipmentStorage.flatMap { $0.items }
        return equipmentItems.filter { $0.condition == condition }
    }
    
    func getTotalItemCount() -> Int {
        let furnitureItems = furnitureStorage.flatMap { $0.items }
        let equipmentItems = equipmentStorage.flatMap { $0.items }
        let furnitureCount = furnitureItems.reduce(0) { $0 + $1.quantity }
        let equipmentCount = equipmentItems.reduce(0) { $0 + $1.quantity }
        return furnitureCount + equipmentCount
    }
    
    func getTotalItemValue() -> Double {
        let furnitureItems = furnitureStorage.flatMap { $0.items }
        let equipmentItems = equipmentStorage.flatMap { $0.items }
        let furnitureValue = furnitureItems.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        let equipmentValue = equipmentItems.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        return furnitureValue + equipmentValue
    }
    
    func getFurnitureStorageStatistics(storageId: UUID) -> [String: Any] {
        guard let storage = getFurnitureStorage(by: storageId) else { return [:] }
        
        let totalItems = storage.items.reduce(0) { $0 + $1.quantity }
        let totalValue = storage.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        let newItems = storage.items.filter { $0.condition == .new }.reduce(0) { $0 + $1.quantity }
        let usedItems = storage.items.filter { $0.condition == .used }.reduce(0) { $0 + $1.quantity }
        
        return [
            "totalItems": totalItems,
            "totalValue": totalValue,
            "newItems": newItems,
            "usedItems": usedItems,
            "itemCategories": Set(storage.items.map { $0.category.rawValue }).count
        ]
    }
    
    func getEquipmentStorageStatistics(storageId: UUID) -> [String: Any] {
        guard let storage = getEquipmentStorage(by: storageId) else { return [:] }
        
        let totalItems = storage.items.reduce(0) { $0 + $1.quantity }
        let totalValue = storage.items.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        let newItems = storage.items.filter { $0.condition == .new }.reduce(0) { $0 + $1.quantity }
        let usedItems = storage.items.filter { $0.condition == .used }.reduce(0) { $0 + $1.quantity }
        
        return [
            "totalItems": totalItems,
            "totalValue": totalValue,
            "newItems": newItems,
            "usedItems": usedItems,
            "itemCategories": Set(storage.items.map { $0.category.rawValue }).count
        ]
    }
    
    
    func getGlobalStorageStatistics() -> [String: Any] {
        let furnitureItems = furnitureStorage.flatMap { $0.items }
        let equipmentItems = equipmentStorage.flatMap { $0.items }
        
        let furnitureCount = furnitureItems.reduce(0) { $0 + $1.quantity }
        let equipmentCount = equipmentItems.reduce(0) { $0 + $1.quantity }
        let totalItems = furnitureCount + equipmentCount
        
        let furnitureValue = furnitureItems.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        let equipmentValue = equipmentItems.reduce(0) { $0 + ($1.value * Double($1.quantity)) }
        let totalValue = furnitureValue + equipmentValue
        
        let furnitureNewItems = furnitureItems.filter { $0.condition == .new }.reduce(0) { $0 + $1.quantity }
        let equipmentNewItems = equipmentItems.filter { $0.condition == .new }.reduce(0) { $0 + $1.quantity }
        let newItems = furnitureNewItems + equipmentNewItems
        
        let furnitureUsedItems = furnitureItems.filter { $0.condition == .used }.reduce(0) { $0 + $1.quantity }
        let equipmentUsedItems = equipmentItems.filter { $0.condition == .used }.reduce(0) { $0 + $1.quantity }
        let usedItems = furnitureUsedItems + equipmentUsedItems
        
        return [
            "totalStorages": furnitureStorage.count + equipmentStorage.count,
            "totalItems": totalItems,
            "totalValue": totalValue,
            "newItems": newItems,
            "usedItems": usedItems,
            "averageItemsPerStorage": (furnitureStorage.count + equipmentStorage.count) == 0 ? 0 : totalItems / (furnitureStorage.count + equipmentStorage.count)
        ]
    }
    
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
    
    // MARK: - Achievement Methods
    private func loadAchievements() {
        if let data = defaults.data(forKey: achievementsKey) {
            let decoder = JSONDecoder()
            if let loadedAchievements = try? decoder.decode([Achievement].self, from: data) {
                self.achievements = loadedAchievements
            }
        } else {
            self.achievements = createDefaultAchievements()
        }
        self.totalPoints = defaults.integer(forKey: totalPointsKey)
    }
    
    private func saveAchievements() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(achievements) {
            defaults.set(encoded, forKey: achievementsKey)
        }
    }
    
    private func createDefaultAchievements() -> [Achievement] {
        return [
            Achievement(id: "first_storage", title: "First Storage", description: "Create your first storage", emoji: "📦", category: .storage, requirement: 1, points: 10),
            Achievement(id: "storage_master", title: "Storage Master", description: "Create 5 storages", emoji: "🏆", category: .storage, requirement: 5, points: 50),
            Achievement(id: "first_item", title: "First Item", description: "Add your first item", emoji: "✨", category: .items, requirement: 1, points: 15),
            Achievement(id: "item_collector", title: "Item Collector", description: "Add 20 items", emoji: "📚", category: .items, requirement: 20, points: 100),
            Achievement(id: "value_expert", title: "Value Expert", description: "Reach $1000 total value", emoji: "💰", category: .value, requirement: 1000, points: 75),
            Achievement(id: "collection_pro", title: "Collection Pro", description: "Have items in all categories", emoji: "🎯", category: .collection, requirement: 8, points: 150),
            Achievement(id: "efficiency_guru", title: "Efficiency Guru", description: "Have 10+ items per storage", emoji: "⚡", category: .efficiency, requirement: 10, points: 200)
        ]
    }
    
    func checkAndUnlockAchievements() {
        var hasNewAchievements = false
        
        for i in 0..<achievements.count {
            if !achievements[i].isUnlocked {
                let shouldUnlock = checkAchievementRequirement(achievements[i])
                if shouldUnlock {
                    achievements[i].isUnlocked = true
                    achievements[i].unlockedAt = Date()
                    totalPoints += achievements[i].points
                    hasNewAchievements = true
                }
            }
        }
    }
    
    private func checkAchievementRequirement(_ achievement: Achievement) -> Bool {
        switch achievement.id {
        case "first_storage":
            return (furnitureStorage.count + equipmentStorage.count) >= 1
        case "storage_master":
            return (furnitureStorage.count + equipmentStorage.count) >= 5
        case "first_item":
            return getTotalItemCount() >= 1
        case "item_collector":
            return getTotalItemCount() >= 20
        case "value_expert":
            return getTotalItemValue() >= 1000
        case "collection_pro":
            let furnitureCategories = Set(furnitureStorage.flatMap { $0.items.map { $0.category.rawValue } })
            let equipmentCategories = Set(equipmentStorage.flatMap { $0.items.map { $0.category.rawValue } })
            return (furnitureCategories.count + equipmentCategories.count) >= 8
        case "efficiency_guru":
            let totalStorages = furnitureStorage.count + equipmentStorage.count
            let totalItems = getTotalItemCount()
            return totalStorages > 0 && (totalItems / totalStorages) >= 10
        default:
            return false
        }
    }
    
    func getUnlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.isUnlocked }
    }
    
    func getLockedAchievements() -> [Achievement] {
        return achievements.filter { !$0.isUnlocked }
    }
    
    func getAchievementsByCategory(_ category: AchievementCategory) -> [Achievement] {
        return achievements.filter { $0.category == category }
    }

}




