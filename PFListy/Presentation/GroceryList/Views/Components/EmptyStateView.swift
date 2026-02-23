//
//  EmptyStateView.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI

struct EmptyStateView: View {
    struct Constants {
        static let emptyStateTitle = "Grocery List is empty"
        static let emptyStateSubtitle = "Add items above or change filter to get started"
    }

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "cart")
                .font(.system(size: 48))
                .foregroundStyle(AppColors.emptyStateGray)

            Text(Constants.emptyStateTitle)
                .font(.headline)
                .foregroundStyle(AppColors.textPrimary)

            Text(Constants.emptyStateSubtitle)
                .font(.subheadline)
                .foregroundStyle(AppColors.emptyStateGray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xl)
    }
}

#Preview {
    EmptyStateView()
}
