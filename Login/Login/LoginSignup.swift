//
//  LoginSignup.swift
//  Login
//
//  LoginSignup does exactly what is says, handles all user interaction with logging into the app or
//  registering them
//  if they are new. Google Firbase is used to manage the workflow for login and registration.
//
//  Created by Travis Walter on 11/30/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

// View struct for the Login / Signup page, which is called by ContentView's navigation button
struct LoginSignup: View {
    
    // State variable for the status of the login process
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    // State variable for the about you status of the registration process
    @State var about = UserDefaults.standard.value(forKey: "about") as? Bool ?? false
    
    // Body of the view
    var body: some View {
        // This VStack loads different views depending on the state of the States above
        // If the user goes through the registration workflow, the "about" State is set to true which will load the AboutYou view
        // which allows the app to further populate the realtime database for the user.
        //
        // If the "about" State is set to false and the user is logged in, the "status" State will be equal to true, which will load
        // the Home view.
        //
        // If the "about" State is set to false and the user is not logged in, the "status" State will be equal to false, which will
        // load the Login view.
        VStack {
            if !about {
                if status {
                    Home()
                } else {
                    Login()
                }
            } else {
                AboutYou()
            }
        }.animation(.spring())
        .onAppear {
            // Change state of "status" state
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) {
                (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                self.status = status
            }
            // Change state of "about" state
            NotificationCenter.default.addObserver(forName: NSNotification.Name("aboutChange"), object: nil, queue: .main) {
                (_) in
                
                let about = UserDefaults.standard.value(forKey: "about") as? Bool ?? false
                self.about = about
            }
        }
    }
}

// This struct loads the preview as the LoginSignup view.
struct LoginSignup_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignup()
    }
}

// This struct defines the login view which contains the sign in area, sign up area, and the forgot password button
struct Login: View {
    // State definitions for login work flow
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var show = false
    @State var alert = false
    
    var body: some View {
        VStack {
            Text("Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top,.bottom], 20)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    HStack {
                        TextField("Enter Your Username", text: $user)
                    }
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    SecureField("Enter Your Password", text: $pass)
                    Divider()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                }
            }.padding(.horizontal, 6)
            .sheet(isPresented: $show) {
                ForgotPass(show: self.$show)
            }
            
            Button(action: {
                
                signInWithEmail(email: self.user, password: self.pass) { (verified, status) in
                    
                    if !verified {
                        self.msg = status
                        self.alert.toggle()
                    } else {
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                Text("Sign In")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            }
            .background(Color.red)
            .clipShape(Capsule())
            .padding(.top, 45)
            
            BottomView()
        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

// This struct defines the button view of the login / signup page, which includes the Sign up button
struct BottomView: View {
    @State var show = false
    
    var body: some View {
        VStack {
            //GoogleSignView().frame(width: 150, height: 55)
            
            HStack(spacing: 8) {
                Text("Don't Have An Account?")
                    .foregroundColor(Color.gray.opacity(0.5))
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Text("Sign Up")
                }.foregroundColor(.blue)
            }.padding(.top, 25)
        }.sheet(isPresented: $show) {
            Signup(show: self.$show)
        }
    }
}

// This struct defines the signup view flow and calls the function signUpWithEmail to accomplish this
struct Signup: View {
    // State definitions for Signup work flow
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    @Binding var show: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign Up")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding([.top,.bottom], 20)
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Username")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.black.opacity(0.75))
                        HStack {
                            TextField("Enter Your Email", text: $user)
                        }
                        Divider()
                    }
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.black.opacity(0.75))
                        SecureField("Enter Your Password", text: $pass)
                        Divider()
                    }
                }.padding(.horizontal, 6)
                
                Button(action: {
                    
                    // Function call to signUpWithEmail, which adds the user name and password to firebase
                    signUpWithEmail(email: self.user, password: self.pass) { (verified, status) in
                        if !verified {
                            self.msg = status
                            self.alert.toggle()
                        } else {
                            // Set "about" state to true so that the AboutYou view will be displayed
                            UserDefaults.standard.set(true, forKey: "about")
                            self.show.toggle()
                            NotificationCenter.default.post(name: Notification.Name("aboutChange"), object: nil)
                        }
                    }
                    
                }) {
                    Text("Continue")
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width - 120)
                        .padding()
                }
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.top, 45)
                
                Button(action: { self.show = false }) {
                    Text("Go Back")
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width - 120)
                        .padding()
                }
                .background(Color.gray)
                .clipShape(Capsule())
                .padding(.top, 5)
            }.padding()
            .alert(isPresented: $alert) {
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        
            }.navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

// This struct defines the view flow for forgot password functionality
// which is defined in the resetPasswordWithEmail function
struct ForgotPass: View {
    // State definitions for Signup work flow
    @State var user = ""
    @State var msg = ""
    @State var alert = false
    @Binding var show: Bool
    
    var body: some View {
        VStack {
            Text("Forgot Password?")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top,.bottom], 20)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    HStack {
                        TextField("Enter Your Email", text: $user)
                    }
                    Divider()
                }
            }.padding(.horizontal, 6)
            
            Button(action: {
                // Function call to resetPasswordWithEmail that init the workflow in firebase to reset the users password
                resetPasswordWithEmail(email: self.user)
                
            }) {
                Text("Reset Password")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            }
            .background(Color.red)
            .clipShape(Capsule())
            .padding(.top, 45)
            
            Button(action: { self.show = false }) {
                Text("Go Back")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            }
            .background(Color.gray)
            .clipShape(Capsule())
            .padding(.top, 5)
        }.padding()
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
    
        }
    }
}

//struct GoogleSignView: UIViewRepresentable {
//    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
//        let button = GIDSignInButton()
//        button.colorScheme = .dark
//        if(GIDSignIn.sharedInstance()?.presentingViewController==nil) {
//            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
//        }
//        return button
//    }
//
//    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {
//
//    }
//}

// This function handles the workflow for signup through firebase and only takes an email and a password to create the user.
func signUpWithEmail(email: String, password: String, completion: @escaping (Bool,String) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
        if err != nil {
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

// This function handles the workflow for signin through firebase and only takes an email and a password to authenticate the user.
func signInWithEmail(email: String, password: String, completion: @escaping (Bool,String) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
        if err != nil {
            completion(false,(err?.localizedDescription)!)
            return
        }
        
        completion(true,(res?.user.email)!)
    }
}

// This function handles the reseting of the user's password through firebase and only takes a user's email
func resetPasswordWithEmail(email: String) {
    Auth.auth().sendPasswordReset(withEmail: email) { err in
        if err != nil {
            print((err?.localizedDescription)!)
            return
        }
        print("User Password Reset")
    }
}
