//
//  DesignSystem.swift
//  PFListy
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation
import SwiftUI

enum AppColors {
    static let gradientStart = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let gradientEnd = Color(red: 0.35, green: 0.55, blue: 0.95)
    static let primaryGradient = LinearGradient(
        colors: [gradientStart, gradientEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let verticalGradient = LinearGradient(
        colors: [gradientStart, gradientEnd],
        startPoint: .top,
        endPoint: .bottom
    )

    static let dairyBg = Color(red: 0.4, green: 0.6, blue: 0.95)
    static let produceBg = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let bakeryBg = Color(red: 0.85, green: 0.75, blue: 0.6)
    static let meatsBg = Color(red: 0.95, green: 0.7, blue: 0.7)
    static let othersBg = Color(red: 0.95, green: 0.75, blue: 0.8)
    
    static let emptyStateGray = Color(red: 0.6, green: 0.6, blue: 0.65)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
}

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let pill: CGFloat = 24
}
