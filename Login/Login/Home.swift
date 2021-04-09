//
//  Home.swift
//  Login
//
//  Home is the place the user is led to after successfull login or signup and currently only is a welcome
//  message with the user's name and the logout button.
//
//  Created by Travis Walter on 12/4/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct Home: View {
    @State var firstN = "User"
    
    let userWork = UserWork()
    
    var body: some View {
        VStack {
            Text("Home").onAppear() {
                userWork.writeFromUser{ text in
                    self.firstN = text
                }
            }
            
            Text("Welcome! \(self.firstN)")
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

// This class was created so that it could be used in a number of other views that need access to the database.
class UserWork {
    var ref = Database.database().reference()
    
    // This function gets the user from the database
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
    
    // This function adds user attributes to the real time firebase database
    func addUserAttributes(firstName: String, lastName: String, birthday: Date, gender: String, city: String, state: String, bio: String) {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    let bDayString = formatter.string(from: birthday)
                    
                    //print("User " + user.uid + " First Name " + firstName + " Last Name " + lastName)
                    self.ref.child("users").child(user.uid).setValue(["firstName": firstName, "lastName": lastName, "birthday": bDayString, "gender": gender, "city": city, "state": state, "bio": bio])
                }
            } else {
                // No user is signed in
                print("No user signed in")
            }
        }
    }
    
    // Function that writes from the database to a completionHandler
    func writeFromUser(completionHandler: @escaping (String) -> Void) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? [String: Any] {
                let firstName = value["firstName"] as? String ?? ""
                
                completionHandler(firstName)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
