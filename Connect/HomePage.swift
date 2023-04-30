//
//  HomePage.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct HomePage: View {
    //For Logic
    @State var firstName = UserDefaults.standard.string(forKey: "firstName") ?? "John"
    @State var lastName = UserDefaults.standard.string(forKey: "lastName") ?? "John"
    @State var major = UserDefaults.standard.string(forKey: "userMajor") ?? "John"
    @State var imageSelection = UserDefaults.standard.string(forKey: "imageSelection") ?? "0"
    @State var currentUser = UserModel(firstName: " ", lastName: " ", major: " ", image: "0")
    
    //Multipeer
    @ObservedObject var multipeerSession = MultipeerConnection(username: "User Setup#1")
    
    //For View
    @State var startAnimation = false
    @State var pulse1 = false
    @State var pulse2 = false
    @State var finishAnimation = false
    @State var foundPeople : [UserModel] = []
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init(firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "John", lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? "Doe", major: String = UserDefaults.standard.string(forKey: "userMajor") ?? "English", imageSelection: String = UserDefaults.standard.string(forKey: "imageSelection") ?? "0", currentUser: UserModel = UserModel(firstName: " ", lastName: " ", major: " ", image: "0"), multipeer: MultipeerConnection = MultipeerConnection(username: "User Setup#1")) {
        self.firstName = firstName
        self.lastName = lastName
        self.major = major
        self.imageSelection = imageSelection
        self.currentUser = UserModel(firstName: firstName, lastName: lastName, major: major, image: imageSelection)
        let broadcastID = "\(firstName)%\(lastName)%\(major)%\(Int.random(in: 10...99))"
        self.multipeerSession = MultipeerConnection(username: broadcastID)
    }
    
    var body: some View {
        ZStack{
            if(!multipeerSession.paired){
                VStack{
                    // Nav Bar..
                    HStack(spacing :10 ){
                        Text(finishAnimation ? "\(multipeerSession.availablePeers.count) people NearBy " : "Conect")
                            .font(.title2)
                            .fontWeight(.bold)
                            .animation(.none)
                        Spacer()
                        
                        Button(action:restartView, label: {
                            if finishAnimation{
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                        })
                    }
                    .padding()
                    .background(Color.white)
                    
                    ZStack{
                        //pulse 1 circle
                        Circle()
                            .stroke(Color.gray.opacity(0.5))
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse1 ? 3.3 : 0)
                            .opacity(pulse1 ? 0:1 )
                        //pulse 2 circle
                        Circle()
                            .stroke(Color.gray.opacity(0.5))
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse2 ? 3.3 : 0)
                            .opacity(pulse2 ? 0:1 )
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 130, height: 130)
                        // shadows
                            .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                        ZStack{
                            Circle()
                                .stroke(Color.blue,lineWidth: 1.4)
                                .frame(width: 30, height: 30)
                            
                            ZStack{
                                Circle()
                                    .trim(from: 0, to: 0.4)
                                    .stroke(Color.blue,lineWidth: 1.4)
                                
                                Circle()
                                    .trim(from: 0, to: 0.4)
                                    .stroke(Color.blue,lineWidth: 1.4)
                                    .rotationEffect(.init(degrees: -180))
                            }
                            
                        }
                        .frame(width:70, height: 70)
                        //rotate view
                        .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                        
                        if(!multipeerSession.availablePeers.isEmpty){
                            ForEach(foundPeople){peer in
                                Image(((Int(peer.image)! % 2) != 0) ? "Avt1" : "Avt2")
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
                    
                    if finishAnimation{
                        VStack {
                            
                            Capsule()
                                .fill(Color.gray.opacity(0.7))
                                .frame(width:50, height: 4)
                                .padding(.vertical,10 )
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false, content:{
                                HStack(spacing: 15){
                                    ForEach(foundPeople){peer in
                                        VStack(spacing: 15){
                                            Image(((Int(peer.image)! % 2) != 0) ? "Avt1" : "Avt2")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                            Text(peer.firstName)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            Button(action: {}, label: {
                                                Text("Choose")
                                                    .fontWeight(.semibold)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal,48)
                                                    .background(Color.blue)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(10)
                                            })
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                                .padding()
                                
                            })
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                .onEnded({ value in
                                    
                                                    if value.translation.height > 0 {
                                                        self.restartView()
                                                    }
                                                }))
                            
                        }
                        .background(Color.white)
                        .cornerRadius(25)
                        
                        .transition(.move(edge: .bottom ))
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color.black.opacity(0.05).ignoresSafeArea())
                .onAppear(perform: {
                    animateView()
                })
                .onReceive(timer){ _ in
                    verifyAndAddPeople()
                }
               
                
            } else{
                NavigationPage()
                    .environmentObject(multipeerSession)
            }
        }
    }
    
    func verifyAndAddPeople(){
        if foundPeople.count < multipeerSession.availablePeers.count{
            withAnimation{
                var people = getUser(peerID: multipeerSession.availablePeers[foundPeople.count].displayName)
                people.offset = firstFiveoffsets[foundPeople.count]

                foundPeople.append(people)
            }
        }
        
        if(foundPeople.count > 0){
            if(finishAnimation == false){
                withAnimation(.spring()){
                    finishAnimation.toggle()
                }
                
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
        let user = UserModel(firstName: String(firstName), lastName: String(lastName), major: String(major), image: String(image))
        return user
    }
    
    var firstFiveoffsets: [CGSize] = [
        CGSize(width: 100, height: 100),
        CGSize(width:-100, height: -100),
        CGSize(width: -50, height: 130),
        CGSize(width: 50, height: -130),
        CGSize(width:120, height:-50),
    ]
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
