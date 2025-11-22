//
//  Store.swift
//  Shop
//
//  Created by user285284 on 11/7/25.
//

import Foundation
import FirebaseFirestore

struct Store: Identifiable, Codable{
    @DocumentID var id: String?
    var name: String
    var latitude: Double
    var longitude: Double
    var address: String?
}
