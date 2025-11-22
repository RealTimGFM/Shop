//
//  HomeScreenView.swift
//  Shop
//
//  Created by user285284 on 10/7/25.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {

                // Top bar icons
                HStack {
                    Image(systemName: "line.3.horizontal")
                    Spacer()
                    Image(systemName: "cart.badge.plus")
                }
                .font(.system(.title3))
                Text("Hey \(AuthService.shared.currentUser?.displayName ?? "")")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Find fresh fruits that you want")

                
                // Top Selling
                Text("Top Selling")
                    .font(.title)
                    .fontWeight(.bold)
                TopSellingView()
                // STORES CAROUSEL
                Text("Stores")
                    .font(.title2)
                    .fontWeight(.bold)
                ProductListView()


                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Owner panel (only for owners)
            ToolbarItem(placement: .topBarTrailing) {
                if AuthService.shared.currentUser?.role == "owner" {
                    NavigationLink("Owner", destination: OwnerPanelView())
                }
            }
            // Logout
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") { _ = AuthService.shared.signOut() }
            }
        }
    }
}

#Preview {
    NavigationStack { HomeScreenView() }
}
