//
//  MockListItemRepository.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation

/// Mock repository for SwiftUI previews.
final class MockListItemRepository: ListItemRepositoryProtocol {
    var items: [ListItemModel] = []

    func fetchAll() throws -> [ListItemModel] {
        items
    }

    func add(_ item: ListItemModel) throws {
        items.append(item)
    }

    func togglePurchased(id: UUID) throws {
        if let index = items.firstIndex(where: { $0.id == id }) {
            var item = items[index]
            item.isPurchased.toggle()
            items[index] = item
        }
    }

    func delete(id: UUID) throws {
        items.removeAll { $0.id == id }
    }

    func update(_ item: ListItemModel) throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
}
