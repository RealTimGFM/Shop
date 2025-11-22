//
//  ContentView.swift
//  Shop
//
//  Created by user285284 on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    //global auth variable, update UI when this change.
    @StateObject private var auth = AuthService.shared
    var body: some View {
        Group {
            if auth.currentUser == nil{
                NavigationStack{
                    LoginView()
                }
            } else {
                OnBoardingScreenView()
            }
        }
        //try to find out who is trying to login 
        .onAppear{
            auth.fetchCurrentAppUser{ _ in}
        }
    }
}
	
#Preview {
    ContentView()	
}
