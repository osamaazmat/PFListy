//
//  ListItemModel.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation

/// Domain model representing a list item. Keeps the app layer independent of Core Data.
struct ListItemModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var category: ListItemCategory
    var isPurchased: Bool
    var timestamp: Date

    init(
        id: UUID = UUID(),
        name: String,
        category: ListItemCategory,
        isPurchased: Bool = false,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.isPurchased = isPurchased
        self.timestamp = timestamp
    }
}

/// Category for list items. Raw values are stored in Core Data.
enum ListItemCategory: String, CaseIterable, Identifiable {
    case dairy = "dairy"
    case produce = "produce"
    case meats = "meats"
    case bakery = "bakery"
    case other = "other"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dairy: return "Dairy"
        case .produce: return "Produce"
        case .meats: return "Meats"
        case .bakery: return "Bakery"
        case .other: return "Other"
        }
    }

    /// Categories shown in the add-item UI (excludes "other").
    static var selectableCategories: [ListItemCategory] {
        [.dairy, .produce, .meats, .bakery, .other]
    }
}
