//
//  Claudes_Web_WrapperApp.swift
//  Claudes Web Wrapper
//
//  Created by Michael Fluharty on 4/23/26.
//

import SwiftUI
import SwiftData

@main
struct Claudes_Web_WrapperApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
