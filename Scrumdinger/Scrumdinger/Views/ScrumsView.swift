//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 01/10/23.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    let scrumTimer = ScrumTimer(lengthInMinutes: 10, attendees: [DailyScrum.Attendee(name: "Mary")])
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List($scrums) { $scrum in
                    NavigationLink(destination: DetailView(scrum: $scrum)) {
                        CardView(scrum: scrum)
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .toolbar {
                    Button(action: {
                        scrumTimer.startScrum()
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Scrum")
                }
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                List($scrums) { $scrum in
                    NavigationLink(destination: DetailView(scrum: $scrum)) {
                        CardView(scrum: scrum)
                    }
                    .listRowBackground(scrum.theme.mainColor)
                }
                .navigationTitle("Daily Scrums")
                .toolbar {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Scrum")
                }
            }
        }
    }
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData))
}
