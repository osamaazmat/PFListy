//
//  CategoryFilterView.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedFilter: ListItemCategory?

    struct Constants {
        static let allFilterTitle = "All"
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                FilterChip(title: Constants.allFilterTitle, isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }

                ForEach(ListItemCategory.selectableCategories) { category in
                    FilterChip(
                        title: category.displayName,
                        isSelected: selectedFilter == category
                    ) {
                        selectedFilter = category
                    }
                }
            }
            .padding(.horizontal, 1)
        }
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AnyShapeStyle(AppColors.primaryGradient) : AnyShapeStyle(Color(.tertiarySystemFill)))
                .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CategoryFilterView(selectedFilter: .constant(nil))
        .padding()
}
