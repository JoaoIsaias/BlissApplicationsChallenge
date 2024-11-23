import CoreData

class MainViewModel: ObservableObject {
    private var apiClient: APIClientProtocol
    
    init() {
        self.apiClient = APIClient()
    }
    
    func loadEmojis(context: NSManagedObjectContext) {
        apiClient.request("https://api.github.com/emojis", method: .get, parameters: nil)
        { (result: Result<[String: String]?, Error>) in
            switch result {
            case .success(let data):
                data?.forEach({ emoji in
                    let newEmoji = Emoji(context: context)
                    newEmoji.name = emoji.key
                    newEmoji.url = emoji.value
                })
                
                do {
                    try context.save()
                } catch {
                    print("Error occurred: \(error)")
                    context.rollback()
                }
            case .failure(let error):
                print("Error occurred: \(error)")
            }
        }
    }
    
    func getUserInfo(context: NSManagedObjectContext, username: String, completion: @escaping (User?) -> Void) async {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "login == %@", username)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \User.login, ascending: true)]
        
        do {
            let fetchedUserArray = try context.fetch(fetchRequest)
            if let foundUser = fetchedUserArray.first,
                foundUser.login == username {
                print("Username \(username) found in CoreData")
                completion(foundUser)
            } else {
                print("Username \(username) not found in CoreData, will try API request")
                
                apiClient.request("https://api.github.com/users/\(username)", method: .get, parameters: nil)
                { (result: Result<UserDTO?, Error>) in
                    switch result {
                    case .success(let data):
                        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        let newUser = User(context: context)

                        newUser.login = data?.login?.lowercased()
                        newUser.userId = data?.userId ?? 0
                        newUser.avatarUrl = data?.avatarUrl
                        
                        do {
                            print("Trying to save on coreData")
                            try context.save()
                        } catch {
                            print("Error occurred: \(error)")
                            context.rollback()
                        }
                        completion(newUser)
                    case .failure(let error):
                        print("Error occurred: \(error)")
                    }
                }
            }
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
        completion(nil)
    }

}
