//
//  ProductListView.swift
//  Shop
//
//  Created by user285284 on 11/13/25.
//

import SwiftUI
import FirebaseFirestore

struct ProductListView: View {
    @State private var stores: [Store] = []

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(stores) { s in
                    NavigationLink(destination: StoreDetailView(store: s)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.name)
                                .font(.headline)

                            if let addr = s.address, !addr.isEmpty {
                                Text(addr)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            } else {
                                Text(
                                    String(
                                        format: "Lat: %.3f, Lon: %.3f",
                                        s.latitude,
                                        s.longitude
                                    )
                                )
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 200, height: 120)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            ShopService.shared.fetchStores { stores in
                self.stores = stores
            }
        }
    }
}

#Preview {
    ProductListView()
}
