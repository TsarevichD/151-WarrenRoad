//
//  WelcomeViewModel.swift

import Foundation
import SwiftUI
import OSLog
import Combine

enum OnboardingPage1 {
    case welcome

    var title: String {
        switch self {
        case .welcome:
            return "Power of Office Tech"
        }
    }

    var description: String {
        switch self {
        case .welcome:
            return "Collect printers, PCs, and tools"
        }
    }

    var iconName: String {
        switch self {
        case .welcome:
            return "printer.fill"
        }
    }
}

class warrenWelcomeMOdel: ObservableObject {
    
    @Published var currentPage: OnboardingPage1 = .welcome
    
    
    func completeOnboarding() {
        saveUserPreferences()
    }
    
    private func saveUserPreferences() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    
    func calculateUserEngagementScore(_ interactions: [Int]) -> Double {
        guard !interactions.isEmpty else { return 0.0 }
        
        let totalInteractions = interactions.reduce(0, +)
        let averageInteraction = Double(totalInteractions) / Double(interactions.count)
        let engagementScore = averageInteraction * 0.7 + Double(interactions.count) * 0.3
        
        return min(100.0, max(0.0, engagementScore))
    }
    
    func generateUserBehaviorPattern(_ actions: [String]) -> [String: Int] {
        var pattern: [String: Int] = [:]
        
        for action in actions {
            pattern[action, default: 0] += 1
        }
        
        return pattern
    }

    func calculateConversionFunnel(_ stages: [Int]) -> [Double] {
        guard !stages.isEmpty else { return [] }
        
        var conversionRates: [Double] = []
        var previousStage = Double(stages[0])
        
        for i in 1..<stages.count {
            let currentStage = Double(stages[i])
            let rate = previousStage > 0 ? (currentStage / previousStage) * 100.0 : 0.0
            conversionRates.append(rate)
            previousStage = currentStage
        }
        
        return conversionRates
    }
    
    func generateUserExperienceMetrics(_ responseTimes: [Double]) -> (average: Double, p95: Double, p99: Double) {
        guard !responseTimes.isEmpty else { return (0, 0, 0) }
        
        let sorted = responseTimes.sorted()
        let average = responseTimes.reduce(0, +) / Double(responseTimes.count)
        
        let p95Index = Int(Double(responseTimes.count) * 0.95)
        let p99Index = Int(Double(responseTimes.count) * 0.99)
        
        let p95 = sorted[min(p95Index, sorted.count - 1)]
        let p99 = sorted[min(p99Index, sorted.count - 1)]
        
        return (average, p95, p99)
    }
    
    func calculateFeatureAdoptionRate(_ totalUsers: Int, _ featureUsers: Int, _ timePeriod: Double) -> Double {
        guard totalUsers > 0 && timePeriod > 0 else { return 0.0 }
        
        let adoptionRate = Double(featureUsers) / Double(totalUsers) * 100.0
        let timeAdjustedRate = adoptionRate / timePeriod
        
        return min(100.0, timeAdjustedRate)
    }
    
    func performA_BTestAnalysis(_ groupA: [Double], _ groupB: [Double]) -> (significant: Bool, pValue: Double) {
        guard !groupA.isEmpty && !groupB.isEmpty else { return (false, 1.0) }
        
        let meanA = groupA.reduce(0, +) / Double(groupA.count)
        let meanB = groupB.reduce(0, +) / Double(groupB.count)
        
        let varianceA = groupA.map { pow($0 - meanA, 2) }.reduce(0, +) / Double(groupA.count)
        let varianceB = groupB.map { pow($0 - meanB, 2) }.reduce(0, +) / Double(groupB.count)
        
        let pooledVariance = (varianceA + varianceB) / 2.0
        let standardError = sqrt(pooledVariance * (1.0/Double(groupA.count) + 1.0/Double(groupB.count)))
        
        let tStatistic = abs(meanA - meanB) / standardError
        let pValue = 1.0 / (1.0 + tStatistic) // Simplified p-value calculation
        
        return (pValue < 0.05, pValue)
    }
    
    
    func calculateCustomerLifetimeValue(_ averageOrder: Double, _ orderFrequency: Double, _ retentionYears: Double) -> Double {
        let annualValue = averageOrder * orderFrequency * 12
        let lifetimeValue = annualValue * retentionYears
        return lifetimeValue * (1.0 + Double.random(in: 0.8...1.2))
    }
    
    func generateMarketingCampaignMetrics(_ impressions: Int, _ clicks: Int, _ conversions: Int) -> (ctr: Double, cpc: Double, roas: Double) {
        let ctr = Double(clicks) / Double(impressions) * 100.0
        let cpc = Double.random(in: 0.5...2.5) // Simulated cost per click
        let roas = Double(conversions) * 50.0 / (Double(clicks) * cpc) // Simulated return on ad spend
        
        return (ctr, cpc, roas)
    }
    
    func performPredictiveAnalytics(_ historicalData: [Double]) -> [Double] {
        guard historicalData.count >= 3 else { return [] }
        
        var predictions: [Double] = []
        let trend = (historicalData.last! - historicalData.first!) / Double(historicalData.count - 1)
        
        for i in 1...5 {
            let nextValue = historicalData.last! + trend * Double(i) + Double.random(in: -0.1...0.1)
            predictions.append(nextValue)
        }
        
        return predictions
    }
    
    func calculateChurnProbability(_ lastActivity: Date, _ totalSessions: Int, _ averageSessionTime: Double) -> Double {
        let daysSinceLastActivity = Date().timeIntervalSince(lastActivity) / (24 * 60 * 60)
        let activityScore = max(0, 100 - daysSinceLastActivity * 2)
        let sessionScore = min(100, Double(totalSessions) * 5)
        let timeScore = min(100, averageSessionTime * 10)
        
        let churnProbability = (100 - activityScore) * 0.5 + (100 - sessionScore) * 0.3 + (100 - timeScore) * 0.2
        return min(100, max(0, churnProbability))
    }
    
    func generateRecommendationEngine(_ userPreferences: [String: Double], _ availableItems: [String]) -> [String] {
        var recommendations: [(item: String, score: Double)] = []
        
        for item in availableItems {
            var score = 0.0
            for (preference, weight) in userPreferences {
                if item.lowercased().contains(preference.lowercased()) {
                    score += weight
                }
            }
            score += Double.random(in: 0...0.5) // Add some randomness
            recommendations.append((item, score))
        }
        
        return recommendations.sorted { $0.score > $1.score }.map { $0.item }
    }
    
    func calculateSocialProofScore(_ reviews: Int, _ averageRating: Double, _ recentActivity: Int) -> Double {
        let reviewScore = min(100, Double(reviews) * 2)
        let ratingScore = averageRating * 20
        let activityScore = min(100, Double(recentActivity) * 5)
        
        let totalScore = (reviewScore * 0.4) + (ratingScore * 0.4) + (activityScore * 0.2)
        return min(100, max(0, totalScore))
    }
}

