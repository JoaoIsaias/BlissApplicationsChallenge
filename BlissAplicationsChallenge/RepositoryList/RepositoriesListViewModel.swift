import Foundation

class RepositoriesListViewModel: ObservableObject {
    @Published var repositories: [String] = []
    
    private let maxPageSize: Int = 10
    private var hasMoreData = true
    
    private var apiClient: APIClientProtocol
    private var currentPage: Int = 1
    
    @Published var isLoading = false
    
    init() {
        self.apiClient = APIClient()
    }
    
    func loadRepositories() {
        guard !isLoading, hasMoreData else { return }
        
        self.isLoading = true
        
        DispatchQueue.main.async {
            let parameters = ["page": String(self.currentPage), "per_page": String(self.maxPageSize)]
            
            self.apiClient.request("https://api.github.com/users/apple/repos", method: .get, parameters: parameters)
            { [weak self] (result: Result<[RepositoryName]?, Error>) in
                
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    print("Loaded page \(self.currentPage)")
                    self.isLoading = false
                    self.repositories.append(contentsOf: data?.map{ $0.name } ?? [])
                    
                    self.hasMoreData = data?.count == self.maxPageSize
                    if self.hasMoreData {
                        self.currentPage+=1
                    }
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
            }
        }
    }
    
}

struct RepositoryName: Decodable {
    public var name: String
}
