
import Foundation

// MARK: - Welcome
class profileJson: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: profileData?
    
    init(status: Bool?, code: Int?, message: String?, data: profileData?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class profileData: Codable {
    let userID: Int?
    let username, name, email: String?
    let avatar: String?
    let totalOrders, acceptedOrders, refusedOrders: Int?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username, name, email, avatar
        case totalOrders = "total_orders"
        case acceptedOrders = "accepted_orders"
        case refusedOrders = "refused_orders"
    }
    
    init(userID: Int?, username: String?, name: String?, email: String?, avatar: String?, totalOrders: Int?, acceptedOrders: Int?, refusedOrders: Int?) {
        self.userID = userID
        self.username = username
        self.name = name
        self.email = email
        self.avatar = avatar
        self.totalOrders = totalOrders
        self.acceptedOrders = acceptedOrders
        self.refusedOrders = refusedOrders
    }
}
