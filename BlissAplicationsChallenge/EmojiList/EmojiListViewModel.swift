import Foundation
import CoreData

class EmojiListViewModel: ObservableObject {
    func resetEmojisList(context: NSManagedObjectContext) -> [Emoji]? {
        let fetchRequest: NSFetchRequest<Emoji> = Emoji.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Emoji.name, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }

        return nil
    }
}
