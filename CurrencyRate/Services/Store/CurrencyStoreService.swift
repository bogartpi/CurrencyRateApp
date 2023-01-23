
import Foundation
import CoreData

class CurrencyStoreService {
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack

    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension CurrencyStoreService {
    func add(base: String, baseName: String, secondary: String, secondaryName: String) {
        let object = CurrencyPair(context: managedObjectContext)
        object.base = base
        object.baseName = baseName
        object.secondary = secondary
        object.secondaryName = secondaryName
        object.timestamp = Date()
        coreDataStack.saveContext(managedObjectContext)
    }
    
    func add(symbols: [String: String]) {
        for symbol in symbols {
            let object = CurrencySymbol(context: managedObjectContext)
            object.abbreviation = symbol.key
            object.name = symbol.value
        }
        coreDataStack.saveContext(managedObjectContext)
    }
    
    func fetchSymbols() -> [CurrencySymbol] {
        let fetchRequest = CurrencySymbol.fetchRequest()
        let alphabeticalSort = NSSortDescriptor(key: "abbreviation", ascending: true)
        fetchRequest.sortDescriptors = [alphabeticalSort]
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    func fetchPairs() -> [CurrencyPair] {
        let fetchRequest = CurrencyPair.fetchRequest()
        let dateSort = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return []
    }
    
    func delete(pair: CurrencyPairDTO) throws {
        let fetchRequest = CurrencyPair.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "base = %@ AND secondary = %@", pair.base, pair.secondary)
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            for object in objects {
                managedObjectContext.delete(object)
            }
            coreDataStack.saveContext(managedObjectContext)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
