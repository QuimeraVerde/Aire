//
//  Data.swift
//  Aire
//
//  Created by Pau Escalante on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//


let pollutantsConfig : Dictionary<String,ModelConfiguration> = [
    "pm10" : ModelConfiguration(title: "pm10",
                                fontSize: 3.0,
                                text: "PM10",
                                fullName: "Partículas PM10",
                                yOffset: 0.07,
                                ranges: [0,51,101,151,201,301]),
    "pm25" : ModelConfiguration(title: "pm25",
                                fontSize: 2.5,
                                text: "PM2.5",
                                fullName: "Partículas PM2.5",
                                yOffset: 0.05,
                                ranges: [0,51,101,151,201,301]),
    "co" : ModelConfiguration(title: "co",
                              fontSize: 4.0,
                              text: "CO",
                              fullName: "Monóxido de Carbono",
                              yOffset: 0.06,
                              ranges: [0,51,101,151,201,301]),
]

// Right now static, later receive from API
let pollutants : Dictionary<String,Pollutant> = [
    "pm10" : Pollutant(title: "pm10", value: Int(61*1.5)),
    "co" : Pollutant(title: "co", value: Int(110*1.5)),
    "pm25" : Pollutant(title: "pm25", value: Int(20*1.5))
]
