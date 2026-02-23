//
//  GroceryListView.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct GroceryListView: View {
    @ObservedObject var viewModel: GroceryListViewModel

    struct Constants {
        static let errorAlertTitle = "Error"
        static let okButtonTitle = "OK"
        static let headerTitle = "Grocery List"
        static let headerSubtitle = "Add items to your shopping list"
        static let addNewItemButtonTitle = "Add New Item"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                headerSection
                addItemSection
                listSection
            }
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color(.systemGroupedBackground))
        .onAppear { viewModel.loadItems() }
        .alert(Constants.errorAlertTitle, isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.clearError() } }
        )) {
            Button(Constants.okButtonTitle) { viewModel.clearError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryGradient)
                    .frame(width: 80, height: 80)
                Image(systemName: "cart.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }

            Text(Constants.headerTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            Text(Constants.headerSubtitle)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.top, AppSpacing.xl)
        .padding(.bottom, AppSpacing.md)
    }

    private var addItemSection: some View {
        VStack(spacing: AppSpacing.md) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if viewModel.itemToEdit != nil {
                        viewModel.cancelEditing()
                    } else {
                        viewModel.isAddDrawerExpanded.toggle()
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text(Constants.addNewItemButtonTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.vertical, AppSpacing.md)
                .background(AppColors.primaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            }
            .buttonStyle(.plain)

            if viewModel.isAddDrawerExpanded {
                AddItemDrawerView(
                    itemName: Binding(
                        get: { viewModel.itemNameInput },
                        set: { viewModel.itemNameInput = $0 }
                    ),
                    selectedCategory: Binding(
                        get: { viewModel.selectedCategory },
                        set: { viewModel.selectedCategory = $0 }
                    ),
                    isEditMode: viewModel.itemToEdit != nil,
                    isAddEnabled: viewModel.isAddButtonEnabled,
                    onAdd: { viewModel.addItem() },
                    onCancelEdit: viewModel.itemToEdit != nil ? { viewModel.cancelEditing() } : nil
                )
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }

    private var listSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            if !viewModel.items.isEmpty {
                CategoryFilterView(selectedFilter: Binding(
                    get: { viewModel.selectedCategoryFilter },
                    set: { viewModel.selectedCategoryFilter = $0 }
                ))
                .padding(.horizontal, AppSpacing.md)
            }

            if viewModel.groupedItems.isEmpty {
                EmptyStateView()
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.groupedItems, id: \.category.id) { category, categoryItems in
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(category.displayName)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppColors.textSecondary)
                                .padding(.horizontal, AppSpacing.md)
                                .padding(.top, AppSpacing.md)

                            ForEach(categoryItems) { item in
                                GroceryListItemRow(
                                    item: item,
                                    onToggle: { viewModel.togglePurchased(id: item.id) },
                                    onEdit: { viewModel.startEditing(item) },
                                    onDelete: { viewModel.deleteItem(id: item.id) }
                                )
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }
}

#Preview("With items") {
    let mock = MockListItemRepository()
    mock.items = [
        ListItemModel(name: "Dairy", category: .dairy),
        ListItemModel(name: "Produce", category: .produce, isPurchased: true),
        ListItemModel(name: "Bakery", category: .bakery)
    ]
    return GroceryListView(viewModel: GroceryListViewModel(repository: mock))
}

#Preview("Empty") {
    GroceryListView(viewModel: GroceryListViewModel(repository: MockListItemRepository()))
}
