//
//  ModelThird.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import Foundation
import ObjectMapper

class ModelThird: NSObject, Mappable {
    
    var clasification = String()
    var name = String()
    var type = String()
    var id = String()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map){
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        clasification <- map["ClasificationOf"]
        name <- map["Name"]
        type <- map["TypeOfData"]
        id <- map["id"]
    }
}
