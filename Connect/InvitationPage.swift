//
//  InvitationPage.swift
//  Connect2.0
//
//  Created by Kevin Chin on 4/29/23.
//

import SwiftUI

struct InvitationPage: View {
    @State var user = UserModel(firstName: "Andrew", lastName: "Garfield", major: "Physics", image: "Avt2", social: "Sophmore")
    @EnvironmentObject var multipeerSession : MultipeerConnection
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack{
            //title
            Text("Invitation Request")
                .font(.largeTitle.bold())
                .foregroundColor(.themeTan)
                .padding()
                .padding(.top)
                .padding(.top)
            
           
            
            Image("Avt\((Int(user.image) ?? 0 ) + 1)")
                .resizable()
                .frame(width: 250, height: 250)
                .padding()
                .onAppear(){
                    print("Avt\(Int(user.image)! + 1)")
                }
            
            
            //Name TEXT
            Text("\(user.firstName) \(user.lastName)")
                .font(.title)
                .foregroundColor(.themeCyan)
                .frame(width: 250)
                .padding(.vertical, 7)
                .background(Color.themeTan)
                .cornerRadius(30)
                .padding(.bottom)
                
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.vertical)
           
            //Major TEXT
            Text("Major: \(user.major)")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(Color.themeCyan)
                .cornerRadius(30)
                
            
            //Comment this out if we plan to add YEAR
            //TEXT("Year:")
            
            //Social Media TEXT
            Text("Year: \(user.social)")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(Color.themeCyan)
                .cornerRadius(30)
                
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 75, height: 5)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.vertical)
           
            
            Spacer()
            
            HStack{

                //red button

                Button{
                    if (multipeerSession.invitationHandler != nil) {
                        multipeerSession.invitationHandler!(false, nil)
                    }
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {

                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 125))
                        .foregroundStyle(.white, .red)
                        .accentColor(.white)
                        .symbolRenderingMode(.palette)
                }
                .padding(.horizontal)

                Button{
                    if (multipeerSession.invitationHandler != nil) {
                        multipeerSession.invitationHandler!(true, multipeerSession.session)
                    }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 125))
                        .foregroundStyle(.white, .green)
                        .accentColor(.white)
                        .symbolRenderingMode(.palette)
                }
                .padding(.horizontal)
            }
            
            .padding(.bottom, 30)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.themeBlue)
        .onAppear(){
            self.user = getUser(peerID: multipeerSession.recvdInviteFrom?.displayName ?? "Andrew%Garfield%Physics%4%Sophmore")
            DispatchQueue.main.asyncAfter(deadline: .now() + 30.0){
                presentationMode.wrappedValue.dismiss()
            }
        }
    
    }
    
    func getUser(peerID: String)->UserModel{
        let userInfoArray = peerID.split(separator: "%")
        let firstName = userInfoArray[0]
        let lastName = userInfoArray[1]
        let major = userInfoArray[2]
        let image = userInfoArray[3]
        let social = userInfoArray[4]
        let user = UserModel(firstName: String(firstName), lastName: String(lastName), major: String(major), image: String(image), social: String(social))
        print(user)
        return user
    }
}

struct InvitationPage_Previews: PreviewProvider {
    static var previews: some View {
        InvitationPage()
        
    }
}

