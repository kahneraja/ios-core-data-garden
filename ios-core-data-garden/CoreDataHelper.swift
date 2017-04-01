import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    static let sharedInstance = CoreDataHelper()
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func persistenceContainer() -> NSPersistentContainer{
        return appDelegate().persistentContainer
    }
    
    func viewContext() -> NSManagedObjectContext {
        return persistenceContainer().viewContext
    }
    
    func fetchAllPeople() -> [NSManagedObject] {
        var people : [Person] = []
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        // request.preOdicate = NSPredicate(format: "firstName CONTAINS[cd] %@", "1")
        do {
             try people += persistenceContainer().viewContext.fetch(request)
            return people
        } catch {
            print(error.localizedDescription)
        }
        return people
    }
    
    func saveContext(){
        persistenceContainer().performBackgroundTask{(backgroundContext) in
            do {
                try backgroundContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
}
