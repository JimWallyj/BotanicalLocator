//
//  Moment.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/18/26.
//
//  Moment forms the foundation for storing, displaying, and managing people’s entries throughout the app.

import Foundation
import SwiftData
import UIKit

//
@Model  //  so the type can be saved and queried

class Moment {
    var title: String
    var note: String
    var imageData: Data?
    var timestamp: Date
    
    //  Initialize:
    init(title: String, note: String, imageData: Data? = nil, timestamp: Date = .now) {
            self.title = title
            self.note = note
            self.imageData = imageData
            self.timestamp = timestamp
        }
    
    //  Property that converts the image data into a UIImage for display:
    var image: UIImage? {
        imageData.flatMap {  //  initialize a UIImage only when the data is non-optional.
            UIImage(data: $0)
        }
    }
}



