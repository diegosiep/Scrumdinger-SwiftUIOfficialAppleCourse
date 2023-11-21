//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 20/09/23.
//

//  Using 'xcrun simctl get_app_container booted 'BUNDLE IDENTIFIER data' while running an iOS simulator, will allow you to see the path to the folder where data is saved.

import SwiftUI

@main
struct ScrumdingerApp: App {
    @StateObject private var store = ScrumStore()
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $store.scrums, saveaction: {
                Task {
                    do {
                        try await store.save(scrums: store.scrums)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                    
                }
            })
                .task {
                    do {
                        try await store.load()
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
        }
      
    }
}
