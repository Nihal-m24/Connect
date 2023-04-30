//
//  NavigationPage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI
import NearbyInteraction

struct NavigationPage: View {
    @EnvironmentObject var multipeerSession : MultipeerConnection
    @EnvironmentObject var nearbyInteraction : NearbyInteractionManager
    @Environment(\.presentationMode) var presentationMode
    @State var degree  = 0.0
    @State var distance : Float = 15.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var connectedUser = UserModel(firstName: "John", lastName: "Doe", major: "English", image: "1", social: "@IG")
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
                .padding(.top, 50)
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
            
            
            HStack{
                Image(systemName: "arrow.up")
                    .font(.system(size: 320))
                    .foregroundColor(.themeTan)
            }
            .rotationEffect(Angle(degrees: getAngle()))
            .animation(.spring(), value: getAngle())
            
            Text("Get Closer For Directions")
                .font(.title3)
                .foregroundColor(.themeTan)
                .opacity(getAngle() == 0.0 ? 1.0 : 0.0)
                .animation(.spring(), value: getAngle())
            
            HStack{
                Text("\(convertMeters(distance: nearbyInteraction.object?.distance ?? 99.00))")
                    .foregroundColor(.themeRed)
                    .font(.title3)
                    .frame(width: 50)
                
                Text("Feet Away")
                    .foregroundColor(.themeRed)
                    .font(.title3)
            }
            .frame(width: UIScreen.main.bounds.width / 2)
            .padding(.vertical, 7)
            .padding(.horizontal)
            .background(Color.themeBlue)
            .cornerRadius(30)
            .padding(.vertical)
            .offset(y: 100)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.themeCyan)
        .onAppear(){
            multipeerSession.shareDiscoveryToken(data: multipeerSession.mySessionToken!)
        }
        .onChange(of: multipeerSession.peerSessionToken) { token in
            nearbyInteraction.start(token: token!)
        }
        .onDisappear(){
            multipeerSession.session.disconnect()
        }
    
   }
    
    func convertMeters(distance: Float)->String{
        let feet = distance * 3.28 * 10.0
        let answer = String(format: "%.2f", feet)
        return answer
    }
    
    func getAngle()->Double{
        let degree = (Double(nearbyInteraction.object?.direction?[0] ?? 0.00) * 100.0)  - (Double(nearbyInteraction.object?.direction?[1] ?? 0.00) * 100.0)
        
        return degree
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
