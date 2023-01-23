
import CoreData
import UIKit

class CoreDataStack {

    static let modelName = "CurrencyRate"
    
    static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: CoreDataStack.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    lazy var newDerivedContext: NSManagedObjectContext = {
        return storeContainer.newBackgroundContext()
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName,
                                              managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        saveContext(mainContext)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context != mainContext {
            saveDerivedContext(context)
            return
        }

        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.saveContext(self.mainContext)
        }
    }
}

//extension CoreDataStack: PersistenceServiceProtocol {
//    func save(symbols: [CurrencySymbolDTO]) throws {
//        for symbol in symbols {
//            let object = CurrencySymbol(context: mainContext)
//            object.abbreviation = symbol.abbreviation
//            object.name = symbol.name
//        }
//        do {
//            try mainContext.save()
//        } catch {
//            throw PersistenceError.unableToSave
//        }
//    }
//    
//    func save(pairs: [CurrencyPairDTO]) throws {
//        guard let entity = NSEntityDescription.entity(forEntityName: "CurrencyPair", in: mainContext) else {
//            throw PersistenceError.entityNotFound
//        }
//        for pair in pairs {
//            let object = CurrencyPair(entity: entity, insertInto: mainContext)
//            object.base = pair.base
//            object.baseName = pair.baseDescription
//            object.secondary = pair.secondary
//            object.secondaryName = pair.secondaryDescription
//            object.timestamp = Date()
//        }
//        do {
//            try mainContext.save()
//        } catch {
//            throw PersistenceError.unableToSave
//        }
//    }
//    
//    func fetchCurrencySymbols() throws -> [CurrencySymbol] {
//        let fetchRequest = CurrencySymbol.fetchRequest()
//        let alphabeticalSort = NSSortDescriptor(key: "abbreviation", ascending: true)
//        fetchRequest.sortDescriptors = [alphabeticalSort]
//        do {
//            return try mainContext.fetch(fetchRequest)
//        } catch {
//            throw PersistenceError.unableToFetch
//        }
//    }
//    
//    func fetchCurrencyPairs() throws -> [CurrencyPair] {
//        let fetchRequest = CurrencyPair.fetchRequest()
//        let dateSort = NSSortDescriptor(key: "timestamp", ascending: false)
//        fetchRequest.sortDescriptors = [dateSort]
//        do {
//            return try mainContext.fetch(fetchRequest)
//        } catch {
//            throw PersistenceError.unableToFetch
//        }
//    }
//    
//    func delete(pair: CurrencyPairDTO) throws {
//        let fetchRequest = CurrencyPair.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "base = %@ AND secondary = %@", pair.base, pair.secondary)
//        do {
//            let objects = try mainContext.fetch(fetchRequest)
//            for object in objects {
//                mainContext.delete(object)
//            }
//            try mainContext.save()
//        } catch {
//            throw PersistenceError.unableToDelete
//        }
//    }
//}
