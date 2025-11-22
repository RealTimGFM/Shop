//
//  LoginView.swift
//  Shop
//
//  Created by user285284 on 11/8/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    private let auth = AuthService.shared

    var body: some View {
        Form {
            Section("Sign In") {
                TextField("Enter Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            }

            Button("Login") {
                print("Login clicked")

                guard Validators.isEmailValid(email) else {
                    self.errorMessage = "Invalid Email"
                    return
                }

                guard Validators.isValidPassword(password) else {
                    self.errorMessage = "Invalid Password"
                    return
                }

                auth.login(email: email, password: password) { result in
                    switch result {
                    case .success:
                        self.errorMessage = nil
                    case .failure(let failure):
                        self.errorMessage = failure.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty)

            Section {
                NavigationLink("Create an account", destination: SignUpView())
            }
        }
        .navigationTitle("Sign In")
    }
}

#Preview {
    LoginView()
}
