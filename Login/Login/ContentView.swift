//
//  ContentView.swift
//  Login
//
//  This is the landing page for the user when they first enter the app.
//
//  Created by Travis Walter on 11/30/20.
//

import SwiftUI

// View for the landing page at the start of the page.
struct ContentView: View {
    var body: some View {
        // Navigationg view for navigation buttons and back buttons
        NavigationView {
            // ZStack for image and text layout on the view
            ZStack {
                // Background image
                Image("CityBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                // VStack for the Logo and the Get Started button
                VStack {
                    // Logo placeholder
                    Text("Logo")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        
                    Spacer()
                    
                    // Navigation button to the login/signup page, with the nav bar hidden.
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

// Preview content runner
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
