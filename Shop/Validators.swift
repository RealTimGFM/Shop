//
//  Validators.swift
//  Shop
//
//  Created by user285284 on 11/9/25.
//

import Foundation
enum Validators{
    static func isEmailValid(_ email: String) -> Bool{
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    static func isValidPassword(_ password: String) -> Bool{
        return password.count >= 6
    }
}
