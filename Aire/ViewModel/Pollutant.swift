//
//  Pollutant.swift
//  Aire
//
//  Created by Pau Escalante on 7/4/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

struct Pollutant {
    var aqi : Double = 0.0
    var count : Int = 0
    var title : String = ""
    init(title : String) {
        self.title = title
    }
    init(title : String, value: Int) {
        self.title = title
        self.count = value
    }
    init(rawValue : [String: Any]) {
        self.aqi = (rawValue["v"] as? Double)!
        self.count = Int(self.aqi * 10)
    }
}
