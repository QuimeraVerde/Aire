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
    var yOffset: Float = 0.0
    init(title : String) {
        self.title = title
    }
    init(title : String, fontSize: Float, text: String, yOffset: Float) {
        self.title = title
        self.fontSize = fontSize
        self.text = text
        self.yOffset = yOffset
    }
}
