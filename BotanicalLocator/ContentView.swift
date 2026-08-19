//
//  ContentView.swift
//  BotanicalLocator
//
//  Created by JIM WALEJKO on 8/13/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            
//            .listStyle(.plain)
//            .navigationTitle("Snack Spots:")
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
