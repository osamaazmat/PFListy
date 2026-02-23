//
//  GroceryListViewModel.swift
//  PFListy
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation
import Combine

@MainActor
final class GroceryListViewModel: GroceryListViewModelProtocol, ObservableObject {

    struct Constants {
        static let failedToLoadItems = "Failed to load items"
        static let failedToAddItem = "Failed to add item"
        static let failedToUpdateItem = "Failed to update item"
        static let failedToDeleteItem = "Failed to delete item"
    }

    @Published private(set) var items: [ListItemModel] = []
    @Published var selectedCategoryFilter: ListItemCategory?
    @Published var isAddDrawerExpanded: Bool = false
    @Published var itemNameInput: String = ""
    @Published var selectedCategory: ListItemCategory?
    @Published var errorMessage: String?
    @Published var itemToEdit: ListItemModel?

    private let repository: ListItemRepositoryProtocol

    init(repository: ListItemRepositoryProtocol) {
        self.repository = repository
    }

    var filteredItems: [ListItemModel] {
        guard let filter = selectedCategoryFilter else { return items }
        return items.filter { $0.category == filter }
    }

    var groupedItems: [(category: ListItemCategory, items: [ListItemModel])] {
        let itemsToGroup = filteredItems
        let categories = ListItemCategory.selectableCategories
        return categories.compactMap { category in
            let categoryItems = itemsToGroup.filter { $0.category == category }
            return categoryItems.isEmpty ? nil : (category, categoryItems)
        }
    }

    var isAddButtonEnabled: Bool {
        !itemNameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedCategory != nil
    }

    func loadItems() {
        do {
            items = try repository.fetchAll()
        } catch {
            errorMessage = Constants.failedToLoadItems
        }
    }

    func addItem() {
        guard isAddButtonEnabled, let category = selectedCategory else { return }
        let name = itemNameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if let existing = itemToEdit {
            let updated = ListItemModel(
                id: existing.id,
                name: name,
                category: category,
                isPurchased: existing.isPurchased,
                timestamp: existing.timestamp
            )
            updateItem(updated)
        } else {
            let item = ListItemModel(name: name, category: category)
            do {
                try repository.add(item)
                loadItems()
                clearInputs()
            } catch {
                errorMessage = Constants.failedToAddItem
            }
        }
    }

    func updateItem(_ item: ListItemModel) {
        do {
            try repository.update(item)
            loadItems()
            cancelEditing()
        } catch {
            errorMessage = Constants.failedToUpdateItem
        }
    }

    func deleteItem(id: UUID) {
        do {
            try repository.delete(id: id)
            loadItems()
        } catch {
            errorMessage = Constants.failedToDeleteItem
        }
    }

    func togglePurchased(id: UUID) {
        do {
            try repository.togglePurchased(id: id)
            loadItems()
        } catch {
            errorMessage = Constants.failedToUpdateItem
        }
    }

    func clearInputs() {
        itemNameInput = ""
        selectedCategory = nil
    }

    func startEditing(_ item: ListItemModel) {
        itemToEdit = item
        itemNameInput = item.name
        selectedCategory = item.category
        isAddDrawerExpanded = true
    }

    func cancelEditing() {
        itemToEdit = nil
        clearInputs()
    }

    func clearError() {
        errorMessage = nil
    }
}
