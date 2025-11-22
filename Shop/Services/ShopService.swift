//
//  ShopService.swift
//  Shop
//
//  Created by user285284 on 11/9/25.
//

import Foundation
import FirebaseFirestore

final class ShopService{
    static let shared = ShopService()
    private init() {}
    private let db = Firestore.firestore()
    
    func addStore(_ s: Store, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("stores").addDocument(from: s) { completion($0) }
        }
        catch {
            completion(error)
        }
    }
    func fetchStores(completion: @escaping ([Store]) -> Void){
        db.collection("stores").getDocuments{ snap, _ in
            let list = snap?.documents.compactMap{ try? $0.data(as: Store.self)} ?? []
            completion(list)
        }
    }
    func fetchStore(by id: String, completion: @escaping (Store?) -> Void) {
        db.collection("stores").document(id).getDocument { snap, _ in
            guard let snap = snap,
                  snap.exists,
                  let store = try? snap.data(as: Store.self) else {
                completion(nil)
                return
            }
            completion(store)
        }
    }

    func addProduct(_ p: Product, completion: @escaping (Error?) -> Void){
        do {
            _ = try db.collection("products").addDocument(from: p) {completion($0)}
        } catch{
            completion(error)
        }
    }
    //refresh UI automatically
    func listenProducts(for storeId: String? = nil, onChange:@escaping ([Product]) -> Void) -> ListenerRegistration{
        var q:Query = db.collection("products")
        // Only show products from a specific store if provided
        if let storeId{
            q = q.whereField("storeId", isEqualTo: storeId)
        }
        return q.addSnapshotListener{snap, _ in
            let list = snap?.documents.compactMap{ try? $0.data(as: Product.self)} ?? []
            onChange(list)
            
        }
    }
}
