//
//  LoginPage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct LoginPageAlt: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var major = ""
    @State var social = ""
    @State var avatarSelection = "2"
    
    @State var firstNameMissing = false
    @State var lastNameMissing = false
    @State var majorMissing = false
    @State var socialMissing = false
    @State var avatarMissing = false
    
    @State var completed = false
    
    var body: some View {
        ZStack{
           
            VStack{
                Text("Sign Up")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color.themeTan)
                    .padding()
                    .padding(.top, 50)
                
               
                
                VStack(alignment: .center){
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                        .foregroundColor(Color.themeBlue)
                        .cornerRadius(30)
                   
                    TextField("First Name", text: self.$firstName)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                   
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                        .foregroundColor(Color.themeBlue)
                        .cornerRadius(30)
                    
                    TextField("Appleseeds", text: self.$lastName)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                        .foregroundColor(Color.themeBlue)
                        .cornerRadius(30)
                        
                    
                    TextField("English", text: self.$major)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                        .foregroundColor(Color.themeBlue)
                        .cornerRadius(30)
                        
                    
                    TextField("@IG", text: self.$social)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                        .foregroundColor(Color.themeBlue)
                        .cornerRadius(30)
                        
                }
                .padding(.top)
                .padding(.top)
                
                HStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width / 3 + 7, height: UIScreen.main.bounds.width / 3 + 7)
                            .cornerRadius(10)
                            .opacity(avatarSelection == "0" ? 1.0 : 0.0)
                       
                        
                        Image("Avt1")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                    }
                    .onTapGesture {
                        self.avatarSelection = "0"
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width / 3 + 7, height: UIScreen.main.bounds.width / 3 + 7)
                            .cornerRadius(10)
                            .opacity(avatarSelection == "1" ? 1.0 : 0.0)
                       
                        
                        Image("Avt2")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                    }
                    .onTapGesture {
                        self.avatarSelection = "1"
                    }
                    
                }
                .padding()
                .border(self.avatarMissing ?  Color.white : Color.clear, width: 2)
                
                Button{
                    checkInput()
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.themeRed)
                        .font(.title.bold())
                        
                        
                }
                .frame(width: UIScreen.main.bounds.width - 75)
                .padding(.vertical, 7)
                .background(Color.themeBlue)
                .cornerRadius(10)
                .shadow(radius: 2)
                
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.themeCyan)
        .fullScreenCover(isPresented: self.$completed) {
            HomePage()
        }
    }
    
    func checkInput(){
        withAnimation {
            if(self.firstName == ""){
                self.firstNameMissing = true
            } else {
                self.firstNameMissing = false
            }
            
            if(self.lastName == ""){
                self.lastNameMissing = true
            } else {
                self.lastNameMissing = false
            }
            
            if(self.major == ""){
                self.majorMissing = true
            } else {
                self.majorMissing = false
            }
            
            if(self.social == ""){
                self.socialMissing = true
            } else {
                self.socialMissing = false
            }
            
            if(self.avatarSelection == "2"){
                self.avatarMissing = true
            } else {
                self.avatarMissing = false
            }
        }
        
        if(!firstNameMissing && !lastNameMissing && !majorMissing && !socialMissing && !avatarMissing){
            UserDefaults.standard.set(firstName, forKey: "firstName")
            UserDefaults.standard.set(lastName, forKey: "lastName")
            UserDefaults.standard.set(major, forKey: "userMajor")
            UserDefaults.standard.set(avatarSelection, forKey: "imageSelection")
            UserDefaults.standard.set(social, forKey: "userSocial")
            UserDefaults.standard.set(true, forKey: "SignUpStat")
            
            self.completed = true
        }
    }
}

struct LoginPageAlt_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageAlt()
    }
}
