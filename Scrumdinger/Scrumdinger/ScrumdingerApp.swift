//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 20/09/23.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: DailyScrum.sampleData)
          
        }
    }
}
