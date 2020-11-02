


import Foundation

class CartProduct: Codable {
    let id: Int?
    let title, catID, catName, sectionName: String?
    let volumeName, sizeName, price: String?
    let rate: Int?
    let image: String?
    let typeName, weightName: String?
    var count: Int?
    enum CodingKeys: String, CodingKey {
        case id, title
        case catID = "cat_id"
        case catName = "cat_name"
        case sectionName = "section_name"
        case volumeName = "volume_name"
        case sizeName = "size_name"
        case price, rate, image, count
        case typeName = "type_name"
        case weightName = "weight_name"
    }
    
    init(id: Int?, title: String?, catID: String?, catName: String?, sectionName: String?, volumeName: String?, sizeName: String?, price: String?, rate: Int?, image: String?, typeName: String?, weightName: String?,count: Int?) {
        self.id = id
        self.title = title
        self.catID = catID
        self.catName = catName
        self.sectionName = sectionName
        self.volumeName = volumeName
        self.sizeName = sizeName
        self.price = price
        self.rate = rate
        self.image = image
        self.typeName = typeName
        self.weightName = weightName
        self.count = count
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(catName, forKey: .catName)
        try container.encode(catID, forKey: .catID)
        try container.encode(sectionName, forKey: .sectionName)
        try container.encode(volumeName, forKey: .volumeName)
        try container.encode(sizeName, forKey: .sizeName)
        try container.encode(price, forKey: .price)
        try container.encode(rate, forKey: .rate)
        try container.encode(image, forKey: .image)
        try container.encode(typeName, forKey: .typeName)
        try container.encode(weightName, forKey: .weightName)
        try container.encode(count, forKey: .count)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        rate = try container.decode(Int.self, forKey: .rate)
        catName = try container.decode(String.self, forKey: .catName)
        sectionName = try container.decode(String.self, forKey: .sectionName)
        volumeName = try container.decode(String.self, forKey: .volumeName)
        sizeName = try container.decode(String.self, forKey: .sizeName)
        price = try container.decode(String.self, forKey: .price)
        typeName = try container.decode(String.self, forKey: .typeName)
        image = try container.decode(String.self, forKey: .image)
        weightName = try container.decode(String.self, forKey: .weightName)
        title = try container.decode(String.self, forKey: .title)
        catID = try container.decode(String.self, forKey: .catID)
        count = try container.decode(Int.self, forKey: .count)
    }
}
