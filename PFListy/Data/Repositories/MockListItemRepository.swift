//
//  MockListItemRepository.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation

/// Mock repository for previews and unit tests.
final class MockListItemRepository: ListItemRepositoryProtocol {
    var items: [ListItemModel] = []
    var addCallCount = 0
    var deleteCallCount = 0
    var toggleCallCount = 0
    var updateCallCount = 0

    func fetchAll() throws -> [ListItemModel] {
        items
    }

    func add(_ item: ListItemModel) throws {
        items.append(item)
        addCallCount += 1
    }

    func togglePurchased(id: UUID) throws {
        if let index = items.firstIndex(where: { $0.id == id }) {
            var item = items[index]
            item.isPurchased.toggle()
            items[index] = item
        }
        toggleCallCount += 1
    }

    func delete(id: UUID) throws {
        items.removeAll { $0.id == id }
        deleteCallCount += 1
    }

    func update(_ item: ListItemModel) throws {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
        updateCallCount += 1
    }
}
