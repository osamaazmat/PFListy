//
//  AddItemDrawerView.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct AddItemDrawerView: View {
    @Binding var itemName: String
    @Binding var selectedCategory: ListItemCategory?
    let isEditMode: Bool
    let isAddEnabled: Bool
    let onAdd: () -> Void
    let onCancelEdit: (() -> Void)?

    struct Constants {
        static let itemNameLabel = "Item Name"
        static let itemNamePlaceholder = "Enter grocery item..."
        static let cancelButtonTitle = "Cancel"
        static let updateItemButtonTitle = "Update Item"
        static let addItemButtonTitle = "Add Item"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text(Constants.itemNameLabel)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textSecondary)

            TextField(Constants.itemNamePlaceholder, text: $itemName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()

            CategorySelectionView(
                categories: ListItemCategory.selectableCategories,
                selectedCategory: $selectedCategory
            )

            HStack(spacing: AppSpacing.md) {
                if isEditMode, let onCancel = onCancelEdit {
                    Button(Constants.cancelButtonTitle) {
                        onCancel()
                    }
                    .foregroundStyle(AppColors.textSecondary)
                }

                Button {
                    onAdd()
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "plus")
                        Text(isEditMode ? Constants.updateItemButtonTitle : Constants.addItemButtonTitle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                    .background(isAddEnabled ? AnyShapeStyle(AppColors.primaryGradient) : AnyShapeStyle(Color.gray.opacity(0.3)))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .disabled(!isAddEnabled)
                .buttonStyle(.plain)
            }
        }
        .padding(AppSpacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

#Preview {
    AddItemDrawerView(
        itemName: .constant(""),
        selectedCategory: .constant(nil),
        isEditMode: false,
        isAddEnabled: false,
        onAdd: {},
        onCancelEdit: nil
    )
    .padding()
}
