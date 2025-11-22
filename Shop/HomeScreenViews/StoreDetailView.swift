//
//  StoreDetailView.swift
//  Shop
//
//  Created by user285284 on 11/16/25.
//

import SwiftUI
import FirebaseFirestore

struct StoreDetailView: View {
    let store: Store

    @State private var products: [Product] = []
    @State private var listener: ListenerRegistration?

    var body: some View {
        List {
            // STORE INFO
            Section(header: Text("Store")) {
                Text(store.name)
                    .font(.headline)

                if let addr = store.address, !addr.isEmpty {
                    Text(addr)
                }

                Text(
                    String(
                        format: "Location: %.4f, %.4f",
                        store.latitude,
                        store.longitude
                    )
                )
                .font(.caption)
                .foregroundColor(.gray)
            }

            // PRODUCTS IN THIS STORE
            Section(header: Text("Products")) {
                if products.isEmpty {
                    Text("No products found for this store.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(products) { p in
                        NavigationLink(destination: ProductDetailView(prod: p)) {
                            HStack {
                                Text(p.name)
                                Spacer()
                                Text(String(format: "$%.2f", p.price))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(store.name)
        .onAppear {
            startListening()
        }
        .onDisappear {
            listener?.remove()
        }
    }
    //filter the store by storeid
    private func startListening() {
        guard let id = store.id else { return }
        listener = ShopService.shared.listenProducts(for: id) { items in
            DispatchQueue.main.async {
                self.products = items
            }
        }
    }
}

#Preview {
    // Dummy preview data
    let s = Store(
        id: "demo",
        name: "Demo Store",
        latitude: 696.0,
        longitude: -696.0,
        address: "69 Urmom St"
    )
    return NavigationStack {
        StoreDetailView(store: s)
    }
}
