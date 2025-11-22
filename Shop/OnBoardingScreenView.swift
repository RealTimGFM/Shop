//
//  OnBoardingScreenView.swift
//  Shopping App
//
//  Created by user285284 on 10/7/25.
//

import SwiftUI

struct OnBoardingScreenView: View {
    var body: some View {
        NavigationView{
            VStack(spacing: 30){
                Spacer()
                //big beautiful picture, for nothing
                Image("img")
                    .resizable()
                    .scaledToFill()
                    .padding()
                VStack(alignment: .leading, spacing: 10){
                    Text("Order Your Favorite Fruits")
                        .fontWeight(.bold)
                        .font(.system(.largeTitle))
                    Text("Eat fresh fruits and try to be healthy.")
                        .font(.system(.title3))
                        .foregroundStyle(.black.opacity(0.7))
                }
                Spacer()
                // big beautiful button
                NavigationLink(destination: HomeScreenView()) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("6"))
                        .frame(width: 280, height: 60, alignment: .trailing)
                        .overlay {
                            HStack(spacing: 10) {
                                Text("Next")
                                    
                                    .font(.title)
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.right")
                            }.foregroundStyle(.black)
                        }
                    
                }
                Spacer()
            }
            
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        
    }
}

#Preview {
    OnBoardingScreenView()
}
