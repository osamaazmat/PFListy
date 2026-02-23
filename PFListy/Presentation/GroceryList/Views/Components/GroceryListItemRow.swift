//
//  GroceryListItemRow.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct GroceryListItemRow: View {
    let item: ListItemModel
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    struct Constants {
        static let editButtonTitle = "Edit"
        static let deleteButtonTitle = "Delete"
    }

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Button(action: onToggle) {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isPurchased ? AppColors.gradientEnd : AppColors.emptyStateGray)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                    .strikethrough(item.isPurchased, color: AppColors.textSecondary)

                Text(item.category.displayName)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                Button(Constants.editButtonTitle, systemImage: "pencil") { onEdit() }
                Button(Constants.deleteButtonTitle, systemImage: "trash", role: .destructive) { onDelete() }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(.vertical, AppSpacing.sm)
        .padding(.horizontal, AppSpacing.md)
    }
}

#Preview {
    List {
        GroceryListItemRow(
            item: ListItemModel(name: "Dairy", category: .dairy),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
        GroceryListItemRow(
            item: ListItemModel(name: "Produce", category: .produce, isPurchased: true),
            onToggle: {},
            onEdit: {},
            onDelete: {}
        )
    }
}
