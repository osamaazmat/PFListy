//
//  GroceryListCoordinator.swift
//  PFListy
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI
import CoreData

/// Coordinator for the Grocery List feature. Handles navigation and view composition.
/// In SwiftUI, the coordinator pattern is lightweight—it primarily composes the view hierarchy.
struct GroceryListCoordinator: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        GroceryListFactory.makeView(context: viewContext)
    }
}

#Preview {
    GroceryListCoordinator()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
