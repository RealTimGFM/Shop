//
//  AuthService.swift
//  Shop
//
//  Created by user285284 on 11/7/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService: ObservableObject {
    static let shared = AuthService()

    let db = Firestore.firestore()

    // Signed-in user for the UI
    @Published var currentUser: AppUser?

    private init() {}

    func signUp(
        email: String,
        password: String,
        displayName: String,
        role: String = "customer",
        completion: @escaping (Result<AppUser, Error>) -> Void
    ) {
        // Ask frebase auth to create the account
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Auth signUp error:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(SimpleError("Unable to create the user")))
                return
            }

            let uid = user.uid

            let appUser = AppUser(
                id: uid,
                email: email,
                role: role,
                displayName: displayName
            )
            let data: [String: Any] = [
                "email": email,
                "role": role,
                "displayName": displayName
            ]
            // Save user
            self.db.collection("users").document(uid).setData(data) { error in
                if let error = error {
                    print("Firestore user save error:", error.localizedDescription)
                    completion(.failure(error))
                    return
                }

                DispatchQueue.main.async {
                    self.currentUser = appUser
                }
                completion(.success(appUser))
            }
        }
    }
    //find out who is logged in and keep logging in.
    // SIMPLE: if someone logged in already, it saved as current user in the app and tell the app to keep log me in as this current user.
    func fetchCurrentAppUser(
        completion: @escaping (Result<AppUser?, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async { self.currentUser = nil }
            completion(.success(nil))
            return
        }

        db.collection("users").document(uid).getDocument { snap, error in
            if let error = error {
                print("Fetch user error:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            guard let snap = snap, snap.exists, let data = snap.data() else {
                completion(.success(nil))
                return
            }

            let appUser = AppUser(
                id: snap.documentID,
                email: data["email"] as? String ?? "",
                role: data["role"] as? String ?? "customer",
                displayName: data["displayName"] as? String ?? ""
            )

            DispatchQueue.main.async {
                self.currentUser = appUser
            }
            completion(.success(appUser))
        }
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<AppUser, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Auth login error:", error.localizedDescription)
                completion(.failure(error))
                return
            }

            // After sign in, pull AppUser from Firestore
            self.fetchCurrentAppUser { res in
                switch res {
                case .success(let appUserOpt):
                    if let appUser = appUserOpt {
                        completion(.success(appUser))
                    } else {
                        completion(.failure(SimpleError("Unable to fetch User Details")))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func signOut() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async { self.currentUser = nil }
            return .success(())
        } catch {
            print("Sign out error:", error.localizedDescription)
            return .failure(error)
        }
    }
}

struct SimpleError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }

    var errorDescription: String? { message }
}
