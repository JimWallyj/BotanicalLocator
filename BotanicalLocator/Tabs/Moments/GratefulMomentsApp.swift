//
//  GratefulMomentsApp.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/24/26.
//

// import Foundation
import SwiftUI
import SwiftData

@main
struct GratefulMomentsApp: App {
    let dataContainer = DataContainer()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
