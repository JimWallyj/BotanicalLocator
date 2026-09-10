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
    
    //  Initialize the properties that represet each entry:
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

extension Moment {
    //  Declare variables for the sample images to be imported into the asset catalog.
    static let sample = sampleData[0]
    static let longTextSample = sampleData[1]
    static let imageSample = sampleData[4]

//  Add a set of sample entries for previews and testing.
    static let sampleData = [
        Moment(
            title: "🍅🥳",
            note: "Picked my first homegrown tomato!"
        ),
        Moment(
            title: "Passed the test!",
            note: "The chem exam was tough, but I think I did well 🙌 I’m so glad I reached out to Guillermo and Lee for a study session. It really helped!",
            imageData: UIImage(named: "Study")?.pngData()  //  convert images to data in PNG format, because that’s the format PhotosPicker provides.
        ),
        Moment(
            title: "Down time",
            note: "So grateful for a relaxing evening after a busy week.",
            imageData: UIImage(named: "Relax")?.pngData()
        ),
        Moment(
            title: "Family ❤️",
            note: ""
        ),
        Moment(
            title: "Rock on!",
            note: "Went to a great concert with Blair 🎶",
            imageData: UIImage(named: "Concert")?.pngData()
        )
    ]
}



