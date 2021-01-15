//
//  AboutYou.swift
//  Login
//
//  Created by Travis Walter on 12/14/20.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct AboutYou: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var birthday = Date()
    @State var genders = ["Male", "Female", "Other"]
    @State var selectedGenderIndex = 0
    @State var city = ""
    @State var state = ""
    @State var bio = ""
    
    var body: some View {
        VStack {
            Text("About You")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top,.bottom], 20)
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("First Name")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    HStack {
                        TextField("Enter Your First Name", text: $firstName)
                    }
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Last Name")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    TextField("Enter Your Last Name", text: $lastName)
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Birthday")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    DatePicker("", selection: $birthday, displayedComponents: .date)
                        .labelsHidden()
                    //Text("You Selected \(self.birthday)") (Will need to format date with https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    Picker(selection: $selectedGenderIndex, label: Text("")) {
                        ForEach(0 ..< genders.count) {
                            Text(self.genders[$0])
                        }
                    }
                    //Text("You Selected \(self.genders[selectedGenderIndex])")
                    Divider()
                }.pickerStyle(SegmentedPickerStyle())
                VStack(alignment: .leading) {
                    Text("City")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    TextField("Enter Your City", text: $city)
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("State")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    TextField("Enter Your State", text: $state)
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("Bio")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.75))
                    TextField("Enter Your Bio", text: $bio)
                    Divider()
                }
            }.padding(.horizontal, 6)
            Button(action: {
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                UserDefaults.standard.set(false, forKey: "about")
                NotificationCenter.default.post(name: Notification.Name("aboutChange"), object: nil)
                let gender = self.genders[selectedGenderIndex]
                UserWork().addUserAttributes(firstName: firstName, lastName: lastName, birthday: birthday, gender: gender, city: city, state: state, bio: bio)
            }) {
                Text("Submit")
                    .foregroundColor(Color.white)
                    .frame(width: UIScreen.main.bounds.width - 120)
                    .padding()
            }
            .background(Color.red)
            .clipShape(Capsule())
            .padding(.top, 45)
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct AboutYou_Previews: PreviewProvider {
    static var previews: some View {
        AboutYou()
    }
}
