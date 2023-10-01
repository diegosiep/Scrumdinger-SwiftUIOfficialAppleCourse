//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 01/10/23.
//

import SwiftUI

struct DetailView: View {
    let scrum: DailyScrum
    var body: some View {
        List {
            Section {
                NavigationLink(destination: MeetingView()) {
                    Label(title: { Text("Start Meeting") }, icon: { Image(systemName: "timer") })
                        .accessibilityLabel("Tap to start meeting button")
                        .font(.headline)
                        .foregroundStyle(Color.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(scrum.lengthInMinutes)")
                }
                .accessibilityElement(children: .combine)
                if #available(iOS 16.0, *) {
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(scrum.theme.name)
                            .padding(4)
                            .foregroundStyle(scrum.theme.accentColor)
                            .background(scrum.theme.mainColor)
                            .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 4, bottomLeading: 4, bottomTrailing: 4, topTrailing: 4)))
                    }
                    .accessibilityElement(children: .combine)
                } else {
                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(scrum.theme.name)
                            .padding(4)
                            .foregroundStyle(scrum.theme.accentColor)
                            .background(scrum.theme.mainColor)
                            .cornerRadius(4)    
                    }
                    .accessibilityElement(children: .combine)
                }
            } header: {
                Text("Meeting Info")
            }
            
            Section {
                ForEach(scrum.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } header: {
                Text("Attendees")
            }

        }
        .navigationTitle(scrum.title)
        
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            DetailView(scrum: DailyScrum.sampleData[0])
        }
    } else {
        // Fallback on earlier versions
        NavigationView {
            DetailView(scrum: DailyScrum.sampleData[0])
        }
    }
}
