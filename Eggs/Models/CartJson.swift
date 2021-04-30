


import Foundation

class CartItem: NSObject, NSCoding {
    let id,sellerId,branchId,branchItems: Int?
    var title, info, catName, brand, price, image: String?
    var count: Int?
    enum CodingKeys: String, CodingKey {
        case id, title,branchId
        case catName = "cat_name"
        case price, image, count,info,brand,sellerId
    }
    
    init(id: Int?, title: String?, catName: String?, price: String?, image: String?,count: Int?,info: String?,brand: String?,sellerId: Int?,branchId: Int?,branchItems: Int?) {
        self.id = id
        self.title = title
        self.catName = catName
        self.price = price
        self.image = image
        self.count = count
        self.info = info
        self.brand = brand
        self.sellerId = sellerId
        self.branchId = branchId
        self.branchItems = branchItems
    }
    func encode(with aCoder: NSCoder) {
         aCoder.encode(id, forKey: "id")
         aCoder.encode(title, forKey: "title")
         aCoder.encode(catName, forKey: "catName")
         aCoder.encode(price, forKey: "price")
         aCoder.encode(info, forKey: "info")
         aCoder.encode(brand, forKey: "brand")
         aCoder.encode(image, forKey: "image")
         aCoder.encode(count, forKey: "count")
         aCoder.encode(sellerId, forKey: "sellerId")
        aCoder.encode(branchId, forKey: "branchId")
        aCoder.encode(branchItems, forKey: "branchItems")
    }
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        catName = aDecoder.decodeObject(forKey: "catName") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        info = aDecoder.decodeObject(forKey: "info") as? String
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        count = aDecoder.decodeObject(forKey: "count") as? Int
        sellerId = aDecoder.decodeObject(forKey: "sellerId") as? Int
        branchId = aDecoder.decodeObject(forKey: "branchId") as? Int
        branchItems = aDecoder.decodeObject(forKey: "branchItems") as? Int
    }
    
}
