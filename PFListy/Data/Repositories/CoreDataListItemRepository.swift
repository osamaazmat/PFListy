//
//  CoreDataListItemRepository.swift
//  PropertyFinderListyApp
//
//  Created by Osama Azmat Khan on 2026/02/23.
//

import Foundation
import CoreData

/// Core Data implementation of the list item repository.
final class CoreDataListItemRepository: ListItemRepositoryProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchAll() throws -> [ListItemModel] {
        let request = NSFetchRequest<ListItemEntity>(entityName: "ListItemEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ListItemEntity.timestamp, ascending: true)]

        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }

    func add(_ item: ListItemModel) throws {
        let entity = ListItemEntity(context: context)
        entity.update(from: item)
        try context.save()
    }

    func togglePurchased(id: UUID) throws {
        guard let entity = try fetchEntity(by: id) else { return }
        entity.isPurchased.toggle()
        try context.save()
    }

    func delete(id: UUID) throws {
        guard let entity = try fetchEntity(by: id) else { return }
        context.delete(entity)
        try context.save()
    }

    func update(_ item: ListItemModel) throws {
        guard let entity = try fetchEntity(by: item.id) else { return }
        entity.update(from: item)
        try context.save()
    }

    private func fetchEntity(by id: UUID) throws -> ListItemEntity? {
        let request = NSFetchRequest<ListItemEntity>(entityName: "ListItemEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
