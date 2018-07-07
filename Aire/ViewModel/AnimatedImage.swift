//
//  AnimatedImage.swift
//  Aire
//
//  Created by Pau Escalante on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit

struct AnimatedImage {
    var fileName : String = ""
    var count : Int = 20
    var duration: Double = 2.5
    
    init(title : String, count: Int) {
        self.fileName = title
        self.count = count
    }
    
    func createImageArray() -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for imageCount in 0..<self.count {
            let imageName = self.fileName + "-" + String(imageCount) + ".png"
            let image = UIImage(imageLiteralResourceName: imageName)
            
            imageArray.append(image)
        }
        
        return imageArray
    }
}
