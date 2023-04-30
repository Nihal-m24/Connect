//
//  LoginPage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct LoginPage: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var major = ""
    @State private var social = ""
    @State private var wrongName: Float = 0
    @State private var wrongMajor: Float  = 0
    @State private var showingLoginScreen = false
    
    @State var chosen_pfp = 0
    
    var body: some View {
        VStack{
            Text("Sign Up")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
                .offset(y: 50)
            
            Spacer()
            
            VStack(alignment: .leading){
                Text("First Name")
                    .font(.title3)
                    .foregroundColor(.white)
                
                TextField("First Name", text: self.$firstName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongName))
                
                Text("Last Name")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.top)
                
                TextField("Last Name", text: self.$lastName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongName))
                
                Text("Last Name")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.top)
                
                TextField("Last Name", text: self.$lastName)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.white.opacity(0.25))
                    .cornerRadius(10)
                    .border(.red, width: CGFloat(wrongName))
            }
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.themeCyan)
    }
    
    func authenticateUser(name: String, major: String) {
        if name.lowercased() != "" {
            wrongName = 0
            if major.lowercased() != "" {
                wrongMajor = 0
                if chosen_pfp != 0{
                    showingLoginScreen = true
                }
            } else {
                wrongMajor = 2
            }
        } else {
            wrongName = 2
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
