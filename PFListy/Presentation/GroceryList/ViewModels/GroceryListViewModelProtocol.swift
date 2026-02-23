//
//  GroceryListViewModelProtocol.swift
//  PFListy
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation

/// Protocol for the grocery list view model. Enables testing with mock implementations.
protocol GroceryListViewModelProtocol: AnyObject {
    var items: [ListItemModel] { get }
    var filteredItems: [ListItemModel] { get }
    var groupedItems: [(category: ListItemCategory, items: [ListItemModel])] { get }
    var selectedCategoryFilter: ListItemCategory? { get set }
    var isAddDrawerExpanded: Bool { get set }
    var itemNameInput: String { get set }
    var selectedCategory: ListItemCategory? { get set }
    var isAddButtonEnabled: Bool { get }
    var errorMessage: String? { get }
    var itemToEdit: ListItemModel? { get set }

    func loadItems()
    func clearError()
    /// Adds a new item or updates the item being edited.
    func addItem()
    func deleteItem(id: UUID)
    func togglePurchased(id: UUID)
    func updateItem(_ item: ListItemModel)
    func clearInputs()
    func startEditing(_ item: ListItemModel)
    func cancelEditing()
}
