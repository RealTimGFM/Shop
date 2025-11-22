//
//  OwnerPanelView.swift
//  Shop
//
//  Created by user285284 on 11/11/25.
//

import SwiftUI

struct OwnerPanelView: View {
    var body: some View {
        List {
            NavigationLink("Add Store", destination: AddStoreView())
            NavigationLink("Add Product", destination: AddProductView())
            NavigationLink("My Products", destination: OwnerProductsView())
        }
        .navigationTitle("Owner Panel")
    }
}

#Preview {
    OwnerPanelView()
}
