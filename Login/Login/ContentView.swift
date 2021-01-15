//
//  ContentView.swift
//  Login
//
//  This is the landing page for the user when they first enter the app.
//
//  Created by Travis Walter on 11/30/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("CityBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Logo")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        
                    Spacer()
                    NavigationLink(destination: LoginSignup()) {
                        Text("Get Started!")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(40)
                            .font(.title)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
