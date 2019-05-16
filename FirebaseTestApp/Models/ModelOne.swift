//
//  ModelOne.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelOne: NSObject, Mappable {
    
    var recycling = String()
    var location = String()
    var place = String()
    var id = String()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map){
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        place <- map["Place"]
        location <- map["Location"]
        recycling <- map["Recycling"]
        id <- map["id"]
    }
}
