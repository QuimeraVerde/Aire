//
//  VectorExtension.swift
//  Aire
//
//  Created by Pau Escalante on 2/16/19.
//  Copyright © 2019 QuimeraVerde. All rights reserved.
//

import Foundation
import SceneKit

public extension SCNVector3 {
    public func distance(receiver:SCNVector3) -> Float {
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
    
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
