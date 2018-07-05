//
//  ModelConfiguration.swift
//  Aire
//
//  Created by Pau Escalante on 7/4/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

struct ModelConfiguration {
    var fontSize : Float = 0.0
    var title : String = ""
    var text : String = ""
    var fullName: String = ""
    var yOffset: Float = 0.0
    // ranges of how dangerous each aqi can get
    var aqiRanges = [Int]()
    init(title : String) {
        self.title = title
    }
    init(title : String, fontSize: Float, text: String, fullName: String, yOffset: Float, ranges: [Int]) {
        self.title = title
        self.fontSize = fontSize
        self.text = text
        self.yOffset = yOffset
        self.fullName = fullName
        self.aqiRanges = ranges
    }

    // gets range of color level for visualization of aqi
    func getRange(aqiValue: Int) -> String{
        // aqiValue is not negative
        for i in 0..<aqiRanges.count {
            if aqiValue < aqiRanges[i] {
                return String(i)
            }
        }
        // reached end of array and did not find a situable range (out of range)
        return String(aqiRanges.count)
    }
}
