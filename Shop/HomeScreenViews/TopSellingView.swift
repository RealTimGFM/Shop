//  TopSellingView.swift
//  Shop
//
//  Created by user285284 on 10/7/25.
//

import SwiftUI
import FirebaseFirestore

struct TopSellingView: View {
    @State private var items: [Product] = []
    @State private var listener: ListenerRegistration?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(items) { p in
                    NavigationLink(destination: ProductDetailView(prod: p)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(p.name)
                                .font(.headline)
                            Text(String(format: "$%.2f", p.price))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(width: 160, height: 120)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 4)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            // Start listening to changes
            listener = ShopService.shared.listenProducts { items = $0 }
        }
        .onDisappear {
            listener?.remove()
        }
    }
}

#Preview {
    NavigationStack {
        TopSellingView()
    }
}
