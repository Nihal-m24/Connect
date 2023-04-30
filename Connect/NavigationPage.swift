//
//  NavigationPage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct NavigationPage: View {
    @EnvironmentObject var multipeerSession : MultipeerConnection
    @State var degree  = 0.0
    @State var distance = 15
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var connectedUser = UserModel(firstName: "John", lastName: "Doe", major: "English", image: "1")
    var body: some View {
        VStack{
            HStack{
                Button{
                    multipeerSession.session.disconnect()
                } label: {
                    HStack{
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text("Disconnect")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    
                }
                .padding()
                Spacer()
            }
            
            HStack{
                Text("\(getUserName(peerID:multipeerSession.session.connectedPeers[0].displayName))")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 7)
            .padding(.horizontal)
            .background(Color.themeBlue)
            .cornerRadius(30)
            .padding(.vertical)
            
            Spacer()
            
            
            HStack{
                Image(systemName: "arrow.up")
                    .font(.system(size: 220))
                    .foregroundColor(.themeCyan)
                    .onReceive(timer){time in
                        changeDegree() 
                    }
            }
            .rotationEffect(Angle(degrees: degree))
            
            HStack{
                Text("\(distance)")
                    .foregroundColor(.themeTan)
                    .font(.title3)
                    .frame(width: 30)
                
                Text("Feet Away")
                    .foregroundColor(.themeTan)
                    .font(.title3)
            }
            .frame(width: UIScreen.main.bounds.width / 3)
            .padding(.vertical, 7)
            .padding(.horizontal)
            .background(Color.themeBlue)
            .cornerRadius(30)
            .padding(.vertical)
            
            Spacer()
        }
        .background(Color.themeTan)
    }
    
    func changeDegree(){
        withAnimation(.spring()) {
            self.degree += Double(Int.random(in: -100...100))
            self.distance += Int.random(in: -3...3)
            if(distance < 0){
                distance = 1
            }
        }
   }
    
    func getUserName(peerID: String)->String{
        let userInfoArray = peerID.split(separator: "%")
        let name = "\(userInfoArray[0]) \(userInfoArray[1])"
        return name
    }
}

struct NavigationPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPage()
    }
}
