//
//  AddStoreView.swift
//  Shop
//
//  Created by user285284 on 11/11/25.
//

import SwiftUI

struct AddStoreView: View {
    @State private var name = ""
    @State private var lat = ""
    @State private var lon = ""
    @State private var address = ""
    @State private var msg: String?
    var body: some View {
        Form {
            Section("Store") {
                TextField("Name", text: $name)
                TextField("Latitude", text: $lat).keyboardType(.decimalPad)
                TextField("Longitude", text: $lon).keyboardType(.decimalPad)
                TextField("Address (optional)", text: $address)
            }
            if let m = msg {
                Text(m).foregroundStyle(.green)
            }
            Button("Save Store") {
                // Try converting text into real numbers
                guard let la = Double(lat),
                        let lo = Double(lon)
                else
                {
                    msg = "Invalid coordinates";
                    return
                }
                //Make a store object to push to firebase
                    let s = Store(
                        id: nil,
                        name: name,
                        latitude: la,
                        longitude: lo,
                        address: address.isEmpty ? nil : address
                    )
                    ShopService.shared.addStore(s)
                {
                    err in
                    msg = err == nil ? "Saved!" : err!.localizedDescription
                }
            }
            // No store if you don't fill 
            .disabled(name.isEmpty || lat.isEmpty || lon.isEmpty)
        }
        .navigationTitle("Add Store")
    }
}

#Preview {
    AddStoreView()
}
