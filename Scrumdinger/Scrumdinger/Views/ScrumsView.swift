//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 01/10/23.
//

import SwiftUI

struct ScrumsView: View {
    @Binding var scrums: [DailyScrum]
    @Environment(\.scenePhase) private var scenePhase // SwiftUI indicates the current operational state of your app’s Scene instances with a scenePhase Environment value. You’ll observe this value and save user data when it becomes inactive.
    @State private var isPresentingNewScrumView = false
    let saveaction: ()-> Void
    let scrumTimer = ScrumTimer(lengthInMinutes: 10, attendees: [DailyScrum.Attendee(name: "Mary")])
    var body: some View {
        if #available(iOS 17.0, *) {
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
                        isPresentingNewScrumView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Scrum")
                }
            }
            .sheet(isPresented: $isPresentingNewScrumView) {
                NewScrumSheet(isPresentingNewScrumView: $isPresentingNewScrumView, scrums: $scrums)
            }
            .onChange(of: scenePhase) { phase, _ in
                if phase == .inactive { saveaction() } // Call saveAction() if the scene is moving to the inactive phase. '.onChange(of: )' can be used with any observable property
            }
            
        } else {
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
                            isPresentingNewScrumView = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New Scrum")
                    }
                }
                .sheet(isPresented: $isPresentingNewScrumView) {
                    NewScrumSheet(isPresentingNewScrumView: $isPresentingNewScrumView, scrums: $scrums)
                }
                .onChange(of: scenePhase, perform: { phase in
                    if phase == .inactive { saveaction() }
                })
                
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
                        Button(action: {
                            isPresentingNewScrumView = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New Scrum")
                    }
                    
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .sheet(isPresented: $isPresentingNewScrumView) {
                    NewScrumSheet(isPresentingNewScrumView: $isPresentingNewScrumView, scrums: $scrums)
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive { saveaction() }
                }
                
            }
        }
    }
}

#Preview {
    ScrumsView(scrums: .constant(DailyScrum.sampleData), saveaction: {})
}
