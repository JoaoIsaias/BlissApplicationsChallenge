import CoreData

class MainViewModel: ObservableObject {
    private var apiClient: APIClientProtocol
    @Published var isLoading: Bool = false
    
    init() {
        self.apiClient = APIClient()
    }
    
    func loadEmojis(context: NSManagedObjectContext) {
        self.isLoading = true

        apiClient.request("https://api.github.com/emojis", method: .get, parameters: nil)
        { [weak self] (result: Result<[String: String]?, Error>) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                data?.forEach({emoji in
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

}
