//
//  Product.swift
//  Shop
//
//  Created by user285284 on 11/7/25.
//

import Foundation
import FirebaseFirestore

struct Product: Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var price: Double
    var image: String?
    var storeId: String
}
