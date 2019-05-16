//
//  ModelTwo.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelTwo: NSObject, Mappable {
    
    var name = String()
    var reusable = String()
    var id = String()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map){
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["Name"]
        reusable <- map["Reusable"]
        id <- map["id"]
    }
}
