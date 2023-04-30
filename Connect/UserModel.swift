//
//  UserModel.swift
//  Connect
//
//  Created by Nihal Memon on 4/29/23.
//

import Foundation
import UIKit
import SwiftUI

struct UserModel : Identifiable{
    let id = UUID().uuidString
    
    var firstName : String
    var lastName : String
    var major : String
    var image : String
    var offset: CGSize = CGSize(width: 0, height: 0)
    var social : String 
}

