//
//  GroceryListFactory.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI
import CoreData

/// Factory for creating the Grocery List feature with injected dependencies.
/// Enables testability by allowing mock repository injection.
enum GroceryListFactory {

    /// Creates the main grocery list view with production dependencies.
    static func makeView(
        repository: ListItemRepositoryProtocol? = nil,
        context: NSManagedObjectContext? = nil
    ) -> some View {
        let ctx = context ?? PersistenceController.shared.container.viewContext
        let repo = repository ?? CoreDataListItemRepository(context: ctx)
        let viewModel = GroceryListViewModel(repository: repo)
        return GroceryListView(viewModel: viewModel)
    }

    /// Creates the view with a mock repository for previews and testing.
    static func makeViewForPreview() -> some View {
        let mock = MockListItemRepository()
        mock.items = [
            ListItemModel(name: "Milk", category: .dairy),
            ListItemModel(name: "Apples", category: .produce, isPurchased: true),
            ListItemModel(name: "Bread", category: .bakery),
            ListItemModel(name: "Chicken", category: .meats)
        ]
        return makeView(repository: mock)
    }
}
