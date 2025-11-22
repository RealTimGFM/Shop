//
//  AppUser.swift
//  Shop
//
//  Created by user285284 on 11/7/25.
//

import Foundation
import FirebaseFirestore

struct AppUser: Identifiable {
    var id: String
    var email: String
    var role: String
    var displayName: String
}
