//
//  OwnerProductsView.swift
//  Shop
//
//  Created by user285284 on 11/13/25.
//

import SwiftUI
import FirebaseFirestore

struct OwnerProductsView: View {
    @State private var items: [Product] = []
    @State private var listener: ListenerRegistration?
    @State private var stores: [Store] = []
    
    var body: some View {
        List {
            ForEach(items) { p in
                VStack(alignment: .leading, spacing: 4) {
                    Text(p.name)
                        .font(.headline)
                    
                    Text(String(format: "$%.2f", p.price))
                        .foregroundColor(.gray)
                    
                    // Use store name if we can find it, otherwise fall back to storeId
                    Text("Store: \(storeName(for: p.storeId))")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            // Swipe to delete
            .onDelete(perform: deleteRows)
        }
        .navigationTitle("My Products")
        .onAppear {
            listener = ShopService.shared.listenProducts(onChange: { self.items = $0 })
            
            //load all stores
            ShopService.shared.fetchStores { list in
                self.stores = list
            }
        }
        .onDisappear {
            listener?.remove()
        }
    }
    
    // Look up store name from the store list
    private func storeName(for id: String) -> String {
        if let store = stores.first(where: { $0.id == id }) {
            return store.name
        }
        return id
    }
    
    private func deleteRows(at offsets: IndexSet) {
        let ids = offsets.compactMap { items[$0].id }
        let batch = Firestore.firestore().batch()
        
        for id in ids {
            let ref = Firestore.firestore().collection("products").document(id)
            // Fire and forget.
            batch.deleteDocument(ref)
        }
        batch.commit(completion: nil)
    }
}

#Preview {
    OwnerProductsView()
}
