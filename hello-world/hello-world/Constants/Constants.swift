//
//  Constants.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import Foundation

class Constants {
    
    enum HttpMethods: String {
        case GET, POST, PUT, DELETE
    }
    
    static let API_BASE_URL    = "https://hello-world.innocv.com/api/"
    static let USER_ENDPOINT   = "User"
    
    static let FULLDATE = "yyyy-MM-dd'T'HH:mm:ss"
    static let DATE = "dd-MM-yyyy"
}
