//
//  SignUpView.swift
//  Shop
//
//  Created by user285284 on 11/8/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var isOwner = false
    @State private var errorMessage: String?

    private let auth = AuthService.shared

    var body: some View {
        Form {
            Section("Create Account") {
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)

                SecureField("Password (Min 6 chars)", text: $password)

                TextField("Enter Display Name", text: $displayName)

                Toggle("I am a shop owner", isOn: $isOwner)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }

            Button("Sign Up") {
                print("Sign up clicked")

                // same guard flow as your teacher
                guard Validators.isEmailValid(email) else {
                    self.errorMessage = "Invalid Email"
                    return
                }

                guard Validators.isValidPassword(password) else {
                    self.errorMessage = "Invalid Password"
                    return
                }

                guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
                    self.errorMessage = "Display name is required"
                    return
                }
                // Tell AuthService to make a new user
                auth.signUp(
                    email: email,
                    password: password,
                    displayName: displayName,
                    role: isOwner ? "owner" : "customer"
                ) { result in
                    switch result {
                    case .success:
                        self.errorMessage = nil
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty || displayName.isEmpty)
        }
        .navigationTitle("Sign Up")
    }
}


#Preview {
    SignUpView()
}
