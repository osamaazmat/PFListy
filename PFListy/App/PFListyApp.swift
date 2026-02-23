//
//  PFListyApp.swift
//  PFListy
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import SwiftUI
import CoreData

@main
struct PFListyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GroceryListCoordinator()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
