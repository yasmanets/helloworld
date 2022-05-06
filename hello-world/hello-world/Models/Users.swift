//
//  UserModel.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import Foundation

struct Users: Codable {
    let id: Int?
    let name: String?
    let birthdate: String?
}

extension Users {
    func toDictionary() -> [String: Any] {
        return ["id": self.id as Any, "name": self.name as Any, "birthdate": self.birthdate as Any]
    }
}
