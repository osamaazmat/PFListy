//
//  ListItemRepositoryProtocol.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation

/// Protocol defining list item data operations. Uses domain models only—no Core Data types leak into the app layer.
protocol ListItemRepositoryProtocol {
    /// Fetches all list items, sorted by timestamp ascending.
    func fetchAll() throws -> [ListItemModel]

    /// Adds a new list item.
    func add(_ item: ListItemModel) throws

    /// Toggles the purchased state of an item by ID.
    func togglePurchased(id: UUID) throws

    /// Deletes an item by ID.
    func delete(id: UUID) throws

    /// Updates an existing item.
    func update(_ item: ListItemModel) throws
}
