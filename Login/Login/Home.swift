//
//  Home.swift
//  Login
//
//  Created by Travis Walter on 12/4/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct Home: View {
    @State var firstN = ""
    
    let userWork = UserWork()
    init() {
        let first = userWork.writeFromUser
        _firstN = State(initialValue: first)
    }
    
    var body: some View {
        VStack {
            Text("Home")
            //Text("Welcome! \(self.firstN)")
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                UserDefaults.standard.set(false, forKey: "about")
                NotificationCenter.default.post(name: Notification.Name("aboutChange"), object: nil)
            }) {
                Text("Logout")
            }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

class UserWork {
    var ref = Database.database().reference()
    
    func getUser() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let email = user.email
                    print("User " + uid + "Email" + email!)
                }
            } else {
                // No user is signed in
                print("No user signed in")
            }
        }
    }
    
    func addUserAttributes(firstName: String, lastName: String, birthday: Date, gender: String, city: String, state: String, bio: String) {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    //print("User " + user.uid + " First Name " + firstName + " Last Name " + lastName)
                    self.ref.child("users").child(user.uid).setValue(["firstName": firstName])
                }
            } else {
                // No user is signed in
                print("No user signed in")
            }
        }
    }
    
    func writeFromUser(completionHandler: @escaping (String) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? [String: Any] {
                print(value)
                let firstName = value["firstName"] as? String ?? ""
                
                print(firstName)
                completionHandler(firstName)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
