//
//  DataContainer.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/19/26.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

@Observable  //  Make the data container observable and add it to the environment to support previews.  The @Observable macro tells SwiftUI to watch the DataContainer for changes.
@MainActor  //  Ensures that any interactions with the container from the views happen on the main thread, which is required for UI updates.
//  Declare a class to set up SwiftData and load data at startup.
class DataContainer {
    let modelContainer: ModelContainer


    var context: ModelContext {
        modelContainer.mainContext
    }


    init(includeSampleMoments: Bool = false) {
        //An in-memory model container, providing the Moment type to SwiftData.
        let schema = Schema([
            Moment.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleMoments)
        //let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            //  Called after creating the model container
            if includeSampleMoments{
                loadSampleMoments()
            }
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    //  Function preloads the sample data declared in Moment.
    private func loadSampleMoments() {
        for moment in Moment.sampleData {
            context.insert(moment)
        }
    }
}

//  With the .sampleDataContainer() convenience modifier, we don’t need to manually create a data container in every preview: We can add .sampleDataContainer() to provide the sample data.

private let sampleContainer = DataContainer(includeSampleMoments: true)

extension View {
    func sampleDataContainer() -> some View {
        self
        //  Add the container to the environment so the model container and any future properties on DataContainer are available through the view hierarchy.
            .environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
