//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 20/09/23.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    @State private var scrums = DailyScrum.sampleData
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $scrums)

        }
    }
}
