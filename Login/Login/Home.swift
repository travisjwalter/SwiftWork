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
    @Binding var x : CGFloat
    
    var body: some View {
        // Navigationg view for navigation buttons
        NavigationView {
            // ZStack for image and text layout on the view
            ZStack {
                // Background image
                Image("CityBackground")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                // VStack for the local / visitor choice
                VStack {
                    // HStack for the header
                    HStack {
                        Button(action: {
                            withAnimation {
                                x = 0
                            }
                        }) {
                            // Hamburger button for user info and options slide over
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                        .offset(x: 60)
                        
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        
                        Text("Welcome!")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .offset(x: -15)
                        
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.top, 60)
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .ignoresSafeArea()
                        
                    Spacer()
                    
                    // Navigation button to the LocalChoice page, with the nav bar hidden.
                    NavigationLink(destination: LocalChoicePage()) {
                        Text("I am a local")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("Local"))
                            .cornerRadius(40)
                            .font(.title)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                    
                    Spacer()
                    
                    // Navigation button to the VisitorChoice page (not created yet), with the nav bar hidden.
                    NavigationLink(destination: LoginSignup()) {
                        Text("I am a visitor")
                            .frame(minWidth: 0, maxWidth: 300)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("Visitor"))
                            .cornerRadius(40)
                            .font(.title)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    }
                    
                    Spacer()
                }
                // for drag gesture
                .contentShape(Rectangle())
            }
        }.navigationBarHidden(true)
    }
    
}

struct HomePage : View {
    @State var width = UIScreen.main.bounds.width - 90
    @State var x = -UIScreen.main.bounds.width + 90
    @State var firstN = "User"
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Home(x: $x)
            
            SlideMenu()
                .shadow(color: Color.black.opacity(x != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
                .offset(x: x)
        }
        .gesture(DragGesture().onChanged({ (value) in
            withAnimation {
                if value.translation.width > 0 {
                    // disabling over drag
                    if x < 0 {
                        x = -width + value.translation.width
                    }
                } else {
                    if x != -width {
                        x = value.translation.width
                    }
                }
            }
        }).onEnded({ (Value) in
            withAnimation {
                // checking if half the value of menu is dragged means setting x to 0
                if -x < width / 2 {
                    x = 0
                } else {
                    x = -width
                }
            }
        }))
    }
}

// Menu view for the slide that is displayed when the user clicks the hamburger button of slides over
struct SlideMenu : View  {
    var edges =  UIApplication.shared.windows.first?.safeAreaInsets
    @State var show = true
    @State var firstN = "User"
    
    let userWork = UserWork()
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                
                // This should be the profile picture of the user but not wanting to start this yet
                Image("google")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .onAppear() {
                        userWork.writeFromUser { text in
                            self.firstN = text
                        }
                    }
                
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(self.firstN)")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                    }
                }
                
                Divider()
                    .padding(.top, 10)
                
                VStack(alignment: .leading) {
                    // Menu Buttons
                    Button(action: {
                        print("Show profile information")
                    }) {
                        Text("My Profile")
                    }
                    
                    Divider()
                    
                    // This is only for locals and will be changed accordingly once that view is completed!
                    Button(action: {
                        print("Show Pending Notification View")
                    }) {
                        Text("Pending")
                    }
                    
                    Divider()
                    
                    Button(action: {
                        print("Show Premium View")
                    }) {
                        Text("Premium")
                    }
                    
                    Divider()
                    
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                        UserDefaults.standard.set(false, forKey: "about")
                        NotificationCenter.default.post(name: Notification.Name("aboutChange"), object: nil)
                    }) {
                        Text("Logout")
                    }
                    
                    Divider()
                    
                    Button(action: {}) {
                        Text("Settings and privacy")
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    
                    Button(action: {}) {
                        Text("Help center")
                            .foregroundColor(.black)
                    }
                    .padding(.top, 20)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, edges!.top == 0 ? 15 : edges?.top)
            .padding(.bottom, edges!.bottom == 0 ? 15 : edges?.bottom)
            .frame(width: UIScreen.main.bounds.width - 90)
            .background(Color.white)
            .ignoresSafeArea(.all, edges: .vertical)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
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
