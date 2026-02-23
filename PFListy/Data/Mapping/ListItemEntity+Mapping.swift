//
//  ListItemEntity+Mapping.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation
import CoreData

extension ListItemEntity {

    /// Converts the Core Data managed object to the domain model.
    func toDomain() -> ListItemModel {
        let mappedCategory = ListItemCategory(rawValue: category ?? "") ?? .other

        return ListItemModel(
            id: id ?? UUID(),
            name: name ?? "",
            category: mappedCategory,
            isPurchased: isPurchased,
            timestamp: timestamp ?? Date()
        )
    }

    /// Updates the entity with values from the domain model.
    func update(from model: ListItemModel) {
        id = model.id
        name = model.name
        category = model.category.rawValue
        isPurchased = model.isPurchased
        timestamp = model.timestamp
    }
}
