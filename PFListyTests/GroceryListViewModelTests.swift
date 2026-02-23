//
//  GroceryListViewModelTests.swift
//  PFListyTests
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import XCTest
@testable import PFListy

@MainActor
final class GroceryListViewModelTests: XCTestCase {

    private var viewModel: GroceryListViewModel!
    private var mockRepository: MockListItemRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockListItemRepository()
        viewModel = GroceryListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Happy Path Tests

    func testLoadItems_success() {
        mockRepository.items = [ListItemModel(name: "Milk", category: .dairy)]
        
        viewModel.loadItems()
        
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFilteredItems_returnsAllItemsWhenNoFilter() {
        mockRepository.items = [
            ListItemModel(name: "Milk", category: .dairy),
            ListItemModel(name: "Apple", category: .produce)
        ]
        viewModel.loadItems()
        viewModel.selectedCategoryFilter = nil
        
        XCTAssertEqual(viewModel.filteredItems.count, 2)
    }

    func testFilteredItems_filtersByCategory() {
        mockRepository.items = [
            ListItemModel(name: "Milk", category: .dairy),
            ListItemModel(name: "Apple", category: .produce),
            ListItemModel(name: "Cheese", category: .dairy)
        ]
        viewModel.loadItems()
        viewModel.selectedCategoryFilter = .dairy
        
        XCTAssertEqual(viewModel.filteredItems.count, 2)
        XCTAssertTrue(viewModel.filteredItems.allSatisfy { $0.category == .dairy })
    }

    func testGroupedItems_groupsByCategory() {
        mockRepository.items = [
            ListItemModel(name: "Milk", category: .dairy),
            ListItemModel(name: "Cheese", category: .dairy),
            ListItemModel(name: "Apple", category: .produce)
        ]
        viewModel.loadItems()
        
        let grouped = viewModel.groupedItems
        
        XCTAssertEqual(grouped.count, 2)
        let dairyGroup = grouped.first { $0.category == .dairy }
        XCTAssertEqual(dairyGroup?.items.count, 2)
    }

    func testIsAddButtonEnabled_requiresNameAndCategory() {
        viewModel.itemNameInput = ""
        viewModel.selectedCategory = .dairy
        XCTAssertFalse(viewModel.isAddButtonEnabled)
        
        viewModel.itemNameInput = "Milk"
        viewModel.selectedCategory = nil
        XCTAssertFalse(viewModel.isAddButtonEnabled)
        
        viewModel.itemNameInput = "Milk"
        viewModel.selectedCategory = .dairy
        XCTAssertTrue(viewModel.isAddButtonEnabled)
    }

    func testAddItem_addsNewItemAndClearsInputs() {
        viewModel.itemNameInput = "Milk"
        viewModel.selectedCategory = .dairy
        
        viewModel.addItem()
        
        XCTAssertEqual(mockRepository.items.count, 1)
        XCTAssertEqual(mockRepository.items.first?.name, "Milk")
        XCTAssertEqual(viewModel.itemNameInput, "")
        XCTAssertNil(viewModel.selectedCategory)
    }

    func testAddItem_inEditMode_updatesExistingItem() {
        let existingItem = ListItemModel(name: "Milk", category: .dairy)
        mockRepository.items = [existingItem]
        viewModel.loadItems()
        viewModel.startEditing(existingItem)
        
        viewModel.itemNameInput = "Almond Milk"
        viewModel.addItem()
        
        XCTAssertEqual(mockRepository.items.first?.name, "Almond Milk")
        XCTAssertEqual(mockRepository.items.first?.id, existingItem.id)
    }

    func testUpdateItem_updatesItemAndCancelsEditing() {
        let item = ListItemModel(name: "Milk", category: .dairy)
        mockRepository.items = [item]
        viewModel.loadItems()
        
        let updated = ListItemModel(
            id: item.id,
            name: "Almond Milk",
            category: .dairy,
            isPurchased: item.isPurchased,
            timestamp: item.timestamp
        )
        viewModel.updateItem(updated)
        
        XCTAssertEqual(mockRepository.items.first?.name, "Almond Milk")
        XCTAssertNil(viewModel.itemToEdit)
    }

    func testDeleteItem_removesItem() {
        let item = ListItemModel(name: "Milk", category: .dairy)
        mockRepository.items = [item]
        viewModel.loadItems()
        
        viewModel.deleteItem(id: item.id)
        
        XCTAssertTrue(mockRepository.items.isEmpty)
    }

    func testTogglePurchased_togglesItemState() {
        let item = ListItemModel(name: "Milk", category: .dairy, isPurchased: false)
        mockRepository.items = [item]
        viewModel.loadItems()
        
        viewModel.togglePurchased(id: item.id)
        
        XCTAssertTrue(mockRepository.items.first?.isPurchased == true)
    }

    func testStartEditing_populatesInputsAndExpandsDrawer() {
        let item = ListItemModel(name: "Milk", category: .dairy)
        
        viewModel.startEditing(item)
        
        XCTAssertEqual(viewModel.itemToEdit?.id, item.id)
        XCTAssertEqual(viewModel.itemNameInput, "Milk")
        XCTAssertEqual(viewModel.selectedCategory, .dairy)
        XCTAssertTrue(viewModel.isAddDrawerExpanded)
    }

    func testCancelEditing_clearsItemToEditAndInputs() {
        let item = ListItemModel(name: "Milk", category: .dairy)
        viewModel.startEditing(item)
        
        viewModel.cancelEditing()
        
        XCTAssertNil(viewModel.itemToEdit)
        XCTAssertEqual(viewModel.itemNameInput, "")
        XCTAssertNil(viewModel.selectedCategory)
    }

    // MARK: - Error Tests

    func testLoadItems_whenRepositoryThrows_setsErrorMessage() {
        mockRepository.shouldThrowOnFetch = true
        
        viewModel.loadItems()
        
        XCTAssertEqual(viewModel.errorMessage, GroceryListViewModel.Constants.failedToLoadItems)
    }

    func testClearError_clearsErrorMessage() {
        mockRepository.shouldThrowOnFetch = true
        viewModel.loadItems()
        XCTAssertNotNil(viewModel.errorMessage)
        
        viewModel.clearError()
        XCTAssertNil(viewModel.errorMessage)
    }

    func testDeleteItem_whenRepositoryThrows_setsErrorMessage() {
        let item = ListItemModel(name: "Milk", category: .dairy)
        mockRepository.shouldThrowOnDelete = true
        
        viewModel.deleteItem(id: item.id)
        
        XCTAssertEqual(viewModel.errorMessage, GroceryListViewModel.Constants.failedToDeleteItem)
    }
}

final class MockListItemRepository: ListItemRepositoryProtocol {
    var items: [ListItemModel] = []
    
    // Toggle switches for errors
    var shouldThrowOnFetch = false
    var shouldThrowOnAdd = false
    var shouldThrowOnUpdate = false
    var shouldThrowOnDelete = false

    func fetchAll() throws -> [ListItemModel] {
        if shouldThrowOnFetch { throw NSError(domain: "Test", code: -1) }
        return items
    }

    func add(_ item: ListItemModel) throws {
        if shouldThrowOnAdd { throw NSError(domain: "Test", code: -1) }
        items.append(item)
    }

    func update(_ item: ListItemModel) throws {
        if shouldThrowOnUpdate { throw NSError(domain: "Test", code: -1) }
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }

    func delete(id: UUID) throws {
        if shouldThrowOnDelete { throw NSError(domain: "Test", code: -1) }
        items.removeAll { $0.id == id }
    }

    func togglePurchased(id: UUID) throws {
        // Reuse the update error flag or add a specific one
        if shouldThrowOnUpdate { throw NSError(domain: "Test", code: -1) }
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isPurchased.toggle()
        }
    }
}
