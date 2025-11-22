//
//  AddProductView.swift
//  Shop
//
//  Created by user285284 on 11/12/25.
//

import SwiftUI

struct AddProductView: View {
    @State private var name = ""
    @State private var price = ""
    @State private var stores: [Store] = []
    @State private var selectedStoreId: String?
    @State private var msg: String?
    
    var body: some View {
        Form{
            Section("Product"){
                TextField("Name", text: $name)
                TextField("Price", text: $price).keyboardType(.decimalPad)
                
                Picker("Store", selection: $selectedStoreId){
                    Text("Select a store").tag(String?.none)
                    ForEach(stores){ s in
                        Text(s.name).tag(s.id)
                    }
                }
            }
            if let m = msg {Text(m).foregroundStyle(.green)}
            Button("Save Product"){
                guard let pr = Double(price) else {msg = "Invalid price"; return}
                // No store = no product
                guard let sid = selectedStoreId else {msg = "Please select a store"; return}
                let p = Product(
                    id: nil,
                    name: name,
                    price : pr,
                    image: nil,
                    storeId: sid)
                ShopService.shared.addProduct(p) {
                    err in
                    msg = err == nil ? "Saved!" : err!.localizedDescription
                }
            }
            .disabled(name.isEmpty || price.isEmpty || selectedStoreId == nil)
        }
        .navigationTitle("Add Product")
        .onAppear{
            // Grab all stores asap
            ShopService.shared.fetchStores
            {
                self.stores = $0;
                //Auto get first store, i could do the other way but im lazy =_=
                selectedStoreId = $0.first?.id
            }
        }
    }
}

#Preview {
    AddProductView()
}
