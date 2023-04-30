//
//  LoginPage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct LoginPage: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var major = ""
    @State var social = ""
    @State var avatarSelection = "-1"
    
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
                    .foregroundColor(.white)
                    .padding()
                    .padding(.top)
                    .offset(y: 25)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("First Name")
                        .font(.title3)
                        .foregroundColor(.themeCyan)
                        .padding(.top)
                        .padding(.leading, 5)
                    
                    TextField("Johnny", text: self.$firstName)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .border(self.firstNameMissing ?  Color.themeRed : Color.themeCyan, width: 2)
                    
                        
                    Text("Last Name")
                        .font(.title3)
                        .foregroundColor(.themeCyan)
                        .padding(.top)
                        .padding(.leading, 5)
                    
                    TextField("Appleseeds", text: self.$lastName)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .border(self.lastNameMissing ?  Color.themeRed : Color.themeCyan, width: 2)
                    
                    Text("Major")
                        .font(.title3)
                        .foregroundColor(.themeCyan)
                        .padding(.top)
                        .padding(.leading, 5)
                    
                    TextField("English", text: self.$major)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .border(self.majorMissing ?  Color.themeRed : Color.themeCyan, width: 2)
                    
                    Text("Year")
                        .font(.title3)
                        .foregroundColor(.themeCyan)
                        .padding(.top)
                        .padding(.leading, 5)
                    
                    TextField("Sophmore", text: self.$social)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .border(self.socialMissing ?  Color.themeRed : Color.themeCyan, width: 2)
                }
                
                HStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(0...5, id: \.self){index in
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width / 3 + 7, height: UIScreen.main.bounds.width / 3 + 7)
                                        .cornerRadius(10)
                                        .opacity(avatarSelection == "\(index)" ? 1.0 : 0.0)
                                   
                                    
                                    Image("Avt\(index + 1)")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(10)
                                    
                                }
                                .onTapGesture {
                                    self.avatarSelection = "\(index)"
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                    
                }
                .padding()
                .border(self.avatarMissing ?  Color.white : Color.clear, width: 2)
                
                Button{
                    checkInput()
                } label: {
                    Text("Sign Up")
                        .foregroundColor(.themeCyan)
                        .font(.title3)
                        
                        
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                .padding(.vertical, 7)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.themeBlue)
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
            
            if(self.avatarSelection == "-1"){
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

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
