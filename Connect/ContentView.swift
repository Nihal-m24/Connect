//
//  ContentView.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import SwiftUI

struct ContentView: View {
    @State var hasSignedUp = UserDefaults.standard.bool(forKey: "SignUpStat")
    var body: some View {
        VStack {
            if(hasSignedUp){
                HomePage()
            } else {
                LoginPage()
               // LoginPageAlt()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
