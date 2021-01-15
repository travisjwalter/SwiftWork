//
//  SecondView.swift
//  Login
//
//  Created by Travis Walter on 11/30/20.
//

import SwiftUI

struct SecondView: View {
    var body: some View {
        Text("Hello, Second View!")
            .font(.largeTitle)
            .fontWeight(.medium)
            .foregroundColor(Color.blue)
            .navigationBarHidden(true)
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
