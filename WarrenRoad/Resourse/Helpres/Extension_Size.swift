//
//  Extension_Size.swift

import Foundation
import SwiftUI
import UIKit

extension UIDevice {
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIScreen {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var isSmallScreen: Bool {
        return screenWidth <= 375
    }
    
    static var isMediumScreen: Bool {
        return screenWidth > 375 && screenWidth <= 414
    }
    
    static var isLargeScreen: Bool {
        return screenWidth > 414
    }
    
    static var isIPadScreen: Bool {
        return UIDevice.isIPad
    }
}

// MARK: - Adaptive Size Helper
struct AdaptiveSize {
    // MARK: - Font Sizes
    static func fontSize(_ baseSize: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return baseSize * 1.3
        } else if UIScreen.isSmallScreen {
            return baseSize * 0.9
        } else if UIScreen.isMediumScreen {
            return baseSize
        } else {
            return baseSize * 1.1
        }
    }
    
    // MARK: - Spacing
    static func spacing(_ baseSpacing: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return baseSpacing * 1.5
        } else if UIScreen.isSmallScreen {
            return baseSpacing * 0.8
        } else {
            return baseSpacing
        }
    }
    
    // MARK: - Padding
    static func padding(_ basePadding: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return basePadding * 1.4
        } else if UIScreen.isSmallScreen {
            return basePadding * 0.85
        } else {
            return basePadding
        }
    }
    
    // MARK: - Corner Radius
    static func cornerRadius(_ baseRadius: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return baseRadius * 1.2
        } else {
            return baseRadius
        }
    }
    
    // MARK: - Button Size
    static func buttonHeight(_ baseHeight: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return baseHeight * 1.3
        } else if UIScreen.isSmallScreen {
            return baseHeight * 0.9
        } else {
            return baseHeight
        }
    }
    
    // MARK: - Icon Size
    static func iconSize(_ baseSize: CGFloat) -> CGFloat {
        if UIDevice.isIPad {
            return baseSize * 1.4
        } else if UIScreen.isSmallScreen {
            return baseSize * 0.9
        } else {
            return baseSize
        }
    }
}

// MARK: - SwiftUI View Extensions
extension View {
    // MARK: - Adaptive Font
    func adaptiveFont(_ style: Font.TextStyle, size: CGFloat? = nil) -> some View {
        let fontSize = size ?? UIFont.preferredFont(forTextStyle: style.uiTextStyle).pointSize
        return self.font(.system(size: AdaptiveSize.fontSize(fontSize), weight: .regular, design: .default))
    }
    
    // MARK: - Adaptive Padding
    func adaptivePadding(_ edges: Edge.Set = .all, _ length: CGFloat) -> some View {
        return self.padding(edges, AdaptiveSize.padding(length))
    }
    
    // MARK: - Adaptive Spacing
    func adaptiveSpacing(_ length: CGFloat) -> some View {
        return self.frame(height: AdaptiveSize.spacing(length))
    }
    
    // MARK: - Adaptive Corner Radius
    func adaptiveCornerRadius(_ radius: CGFloat) -> some View {
        return self.cornerRadius(AdaptiveSize.cornerRadius(radius))
    }
    
    // MARK: - Adaptive Frame
    func adaptiveFrame(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        let adaptiveWidth = width.map { AdaptiveSize.spacing($0) }
        let adaptiveHeight = height.map { AdaptiveSize.spacing($0) }
        return self.frame(width: adaptiveWidth, height: adaptiveHeight)
    }
}

// MARK: - Font Style Extension
extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}

// MARK: - Orientation Helper
extension View {
    func adaptiveForOrientation() -> some View {
        return self.modifier(OrientationAdaptiveModifier())
    }
}

struct OrientationAdaptiveModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    func body(content: Content) -> some View {
        content
            .environment(\.adaptiveSize, AdaptiveSize())
    }
}

struct AdaptiveSizeKey: EnvironmentKey {
    static let defaultValue = AdaptiveSize()
}

extension EnvironmentValues {
    var adaptiveSize: AdaptiveSize {
        get { self[AdaptiveSizeKey.self] }
        set { self[AdaptiveSizeKey.self] = newValue }
    }
}
