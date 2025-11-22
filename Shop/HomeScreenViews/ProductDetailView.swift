//
//  ProductDetailView.swift
//  Shop
//
//  Created by user285284 on 11/15/25.
//

import SwiftUI

struct ProductDetailView: View {
    let prod: Product
    @State private var store: Store?
    @State private var isLoadingStore = true
    var body: some View {
        VStack(spacing: 12) {
            Text(prod.name)
                .font(.title)
                .bold()
                .italic()

            Text(String(format: "$%.2f", prod.price))

            if isLoadingStore {
                Text("Loading store info…")
                    .foregroundColor(.gray)
            } else if let s = store {
                Text("Store: \(s.name)")
                    .font(.headline)

                if let addr = s.address, !addr.isEmpty {
                    Text(addr)
                        .font(.subheadline)
                }

                Text(String(format: "Location: %.4f, %.4f", s.latitude, s.longitude))
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                Text("Store information unavailable")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Product")
        .onAppear {
            loadStore()
        }
    }
    // go ask firestore for data
    private func loadStore() {
        isLoadingStore = true
        ShopService.shared.fetchStore(by: prod.storeId) { s in
            DispatchQueue.main.async {
                self.store = s
                self.isLoadingStore = false
            }
        }
    }
}
#Preview {
    // dummy preview
    ProductDetailView(
        prod: Product(id: nil, name: "Apple", price: 1.99, image: nil, storeId: "demo")
    )
}
