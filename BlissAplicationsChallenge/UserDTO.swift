import Foundation
import CoreData

public struct UserDTO: Decodable {
    public var login: String?
    public var userId: Int64
    public var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case userId = "id"
        case avatarUrl = "avatar_url"
    }
}
