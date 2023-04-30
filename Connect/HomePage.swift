//
//  HomePage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI
import MultipeerConnectivity

struct HomePage: View {
    //For Logic
    @State var firstName = UserDefaults.standard.string(forKey: "firstName") ?? "John"
    @State var lastName = UserDefaults.standard.string(forKey: "lastName") ?? "Doe"
    @State var major = UserDefaults.standard.string(forKey: "userMajor") ?? "English"
    @State var imageSelection = UserDefaults.standard.string(forKey: "imageSelection") ?? "0"
    @State var social = UserDefaults.standard.string(forKey: "userSocial") ?? "none"
    @State var currentUser = UserModel(firstName: " ", lastName: " ", major: " ", image: "0", social: " ")
    
    //Multipeer
    @ObservedObject var multipeerSession = MultipeerConnection(username: "User Setup#1")
    
    //Nearby Interaction
    @State var nearbyInteraction = NearbyInteractionManager()
    
    //For View
    @State var startAnimation = false
    @State var pulse1 = false
    @State var pulse2 = false
    @State var finishAnimation = false
    @State var foundPeople : [UserModel] = []
    @State var reqSent = false
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init(firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "John",
         lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? "Doe",
         major: String = UserDefaults.standard.string(forKey: "userMajor") ?? "English",
         imageSelection: String = UserDefaults.standard.string(forKey: "imageSelection") ?? "0",
         social: String = UserDefaults.standard.string(forKey: "userSocial") ?? "none",
         currentUser: UserModel = UserModel(firstName: " ", lastName: " ", major: " ", image: "0", social: ""),
         multipeer: MultipeerConnection = MultipeerConnection(username: "User Setup#1")) {
        self.firstName = firstName
        self.lastName = lastName
        self.major = major
        self.imageSelection = imageSelection
        self.social = social
        self.currentUser = UserModel(firstName: firstName, lastName: lastName, major: major, image: imageSelection, social: social)
        let broadcastID = "\(firstName)%\(lastName)%\(major)%\(imageSelection)%\(social)"
        self.multipeerSession = MultipeerConnection(username: broadcastID)
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            if(!multipeerSession.paired){
                VStack{
                    // Nav Bar..
                    HStack(spacing :10 ){
                        Text(finishAnimation ? "\(multipeerSession.availablePeers.count) Peer Found " : "Locating...")
                            .foregroundColor(Color.white)
                            .font(.title2)
                            .fontWeight(.bold)
                            .animation(.none)
                        Spacer()
                        
                        Button(action:restartView, label: {
                            if finishAnimation{
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        })
                    }
                    .padding()
                    .background(Color.themeCyan)
                    .offset(y: 25)
                    
                    ZStack{
                        //pulse 1 circle
                        Circle()
                            .stroke(Color.themeTan.opacity(0.5))
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse1 ? 3.3 : 0)
                            .opacity(pulse1 ? 0:1 )
                        //pulse 2 circle
                        Circle()
                            .stroke(Color.themeTan.opacity(0.5))
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse2 ? 3.3 : 0)
                            .opacity(pulse2 ? 0:1 )
                        
                        Circle()
                            .fill(Color.themeTan)
                            .frame(width: 130, height: 130)
                        // shadows
                            .shadow(color: Color.themeBlue.opacity(0.07), radius: 5, x: 5, y: 5)
                        ZStack{
                            Circle()
                                .stroke(Color.themeBlue,lineWidth: 1.4)
                                .frame(width: 30, height: 30)
                            
                            ZStack{
                                Circle()
                                    .trim(from: 0, to: 0.4)
                                    .stroke(Color.themeBlue,lineWidth: 1.4)
                                
                                Circle()
                                    .trim(from: 0, to: 0.4)
                                    .stroke(Color.themeBlue,lineWidth: 1.4)
                                    .rotationEffect(.init(degrees: -180))
                            }
                            
                        }
                        .frame(width:70, height: 70)
                        //rotate view
                        .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                        
                        if(!multipeerSession.availablePeers.isEmpty){
                            ForEach(foundPeople){peer in
                                Image("Avt\(Int(peer.image)! + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(4)
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(peer.offset)
                            }
                        }
                        
                    }
                    .frame(maxHeight: .infinity)
                    
                    
                    if foundPeople.count > 0{
                        Spacer()
                        
                        VStack {
                            
                            Capsule()
                                .fill(Color.gray.opacity(0.7))
                                .frame(width:50, height: 4)
                                .padding(.vertical,10 )
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false, content:{
                                HStack(spacing: 15){
                                    ForEach(foundPeople){peer in
                                        VStack(spacing: 15){
                                            Image("Avt\(Int(peer.image)! + 1)")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .shadow(radius: 2)
                                            
                                            Text("\(peer.firstName) \(peer.lastName)")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.themeTan)
                                            
                                            
                                            
                                            Button{
                                                self.sendRequest(idOfPeer: peer.id)
                                            } label: {
                                                if(self.reqSent) {
                                                    
                                                    HStack{
                                                        ProgressView()
                                                            .tint(Color.white)
                                                        
                                                        Text("Requested")
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.white)
                                                    }
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal,48)
                                                    .background(Color.themeCyan)
                                                    .cornerRadius(10)
                                                        
                                                } else {
                                                    Text("Connect")
                                                        .fontWeight(.semibold)
                                                        .padding(.vertical, 10)
                                                        .padding(.horizontal,48)
                                                        .background(Color.themeCyan)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                }
                                                
                                            }
                                        }
                                        .padding()
                                        .background(Color.themeBlue)
                                        .cornerRadius(25)
                                    }
                                }
                                .padding()
                                .padding(.bottom, 25)
                            })
                            
                        }
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                        .background(Color.white)
                        .cornerRadius(25)
                        .transition(.move(edge: .bottom ))
                      //  .padding(.bottom, 17)
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .background(Color.themeCyan)
                .onAppear(perform: {
                    animateView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                        nearbyInteraction.setup()
                        let tokenData = nearbyInteraction.discoveryTokenData
                        multipeerSession.mySessionToken = tokenData
                    }
                })
                .onReceive(timer){ time in
                    verifyAndAddPeople()
                    
                }
                .onDisappear(){
                    self.foundPeople.removeAll()
                }
                .onChange(of: multipeerSession.recvdInvite) { newValue in
                    print("Recieved Invitation")
                }
                
            } else{
                NavigationPage()
                    .environmentObject(multipeerSession)
                    .environmentObject(nearbyInteraction)
            }
        }
        .fullScreenCover(isPresented: self.$multipeerSession.recvdInvite) {
            InvitationPage()
                .environmentObject(multipeerSession)
        }
    }
    
    func sendRequest(idOfPeer: String){
        var index = 0
        
        for i in 0...foundPeople.count - 1{
            let idOfUser = foundPeople[i].id
            if(idOfPeer == String(describing: idOfUser)){
                index = i
            }
        }
        
        let peer = multipeerSession.availablePeers[index]
        multipeerSession.serviceBrowser.invitePeer(peer, to: multipeerSession.session, withContext: nil, timeout: 30)
        
        print("Invited: \(peer.displayName)")
        withAnimation {
            self.reqSent.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 30){
                self.reqSent.toggle()
            }
        }
        
    }
    
    func verifyAndAddPeople(){
        if foundPeople.count < multipeerSession.availablePeers.count{
            withAnimation{
                var people = getUser(peerID: multipeerSession.availablePeers[foundPeople.count].displayName)
                people.offset = firstFiveoffsets[foundPeople.count % 6]

                foundPeople.append(people)
            }
        }
        
        if(foundPeople.count > 0){
            if(finishAnimation == false){
                withAnimation(.spring()){
                    finishAnimation.toggle()
                }
                
            }
        } else{
            if(finishAnimation == true){
                restartView()
            }
            
        }
    }
    
    func restartView(){
        withAnimation(Animation.linear(duration: 0.6)){
            finishAnimation.toggle()
            startAnimation = false
            pulse1 = false
            pulse2 = false

        }

        if !finishAnimation{
            withAnimation{foundPeople.removeAll()}
            animateView()
        }
    }
    
    func animateView(){
        //spinning inner blue circle
        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
            startAnimation.toggle()
        }
        //expanding circle wave
        withAnimation(Animation.linear(duration:1.7).delay(-0.1).repeatForever(autoreverses: false)){
            pulse1.toggle()
        }
        //2nd pulse animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            withAnimation(Animation.linear(duration:1.7).delay(-0.1).repeatForever(autoreverses: false)){
                pulse2.toggle()
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
        return user
    }
    
    var firstFiveoffsets: [CGSize] = [
        CGSize(width: 100, height: 100),
        CGSize(width:-100, height: -100),
        CGSize(width: -50, height: 130),
        CGSize(width: 50, height: -130),
        CGSize(width:120, height:-50),
        CGSize(width:-120, height:50),
    ]
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
