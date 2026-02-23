//
//  CategorySelectionView.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct CategorySelectionView: View {
    let categories: [ListItemCategory]
    @Binding var selectedCategory: ListItemCategory?

    struct Constants {
        static let categoryLabel = "Category"
    }

    private var categoryConfig: [(ListItemCategory, Color, String)] {
        [
            (.dairy, AppColors.dairyBg, "drop.fill"),
            (.produce, AppColors.produceBg, "leaf.fill"),
            (.bakery, AppColors.bakeryBg, "birthday.cake.fill"),
            (.meats, AppColors.meatsBg, "fork.knife"),
            (.other, AppColors.othersBg, "tag.fill")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(Constants.categoryLabel)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(AppColors.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(categoryConfig, id: \.0.id) { category, bgColor, icon in
                        CategoryChip(
                            category: category,
                            backgroundColor: bgColor,
                            iconName: icon,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
}

private struct CategoryChip: View {
    let category: ListItemCategory
    let backgroundColor: Color
    let iconName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(.white)
                Text(category.displayName)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 72, height: 72)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CategorySelectionView(
        categories: ListItemCategory.selectableCategories,
        selectedCategory: .constant(.dairy)
    )
    .padding()
}
