import Foundation
import CoreData

class AvatarListViewModel: ObservableObject {
    func deleteAvatar(context: NSManagedObjectContext, username: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", username)

        do {
            let results = try context.fetch(fetchRequest)
            
            if let userToDelete = results.first {
                context.delete(userToDelete)
                
                do {
                    try context.save()
                    print("Successfully deleted user with ID: \(username)")
                } catch {
                    print("Error saving context after deletion: \(error)")
                }
            } else {
                print("No user found with ID: \(username)")
            }
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
}
