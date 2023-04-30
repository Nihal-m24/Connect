//
//  Extensions.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import Foundation
import SwiftUI

extension Color{
    static let themeCyan = Color("ThemeCyan")
    static let themeBlue = Color("ThemeBlue")
    static let themePink = Color("ThemePink")
    static let themeRed = Color("ThemeRed")
    static let themeTan = Color("ThemeTan")
}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
