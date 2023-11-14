//
//  NewScrumSheet.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 13/11/23.
//

import SwiftUI

struct NewScrumSheet: View {
    @State private var newScrum = DailyScrum.emptyScrum
    @Binding var isPresentingNewScrumView: Bool
    @Binding var scrums: [DailyScrum]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                DetailEditView(scrum: $newScrum)
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                isPresentingNewScrumView = false
                                scrums.append(newScrum)
                            }
                        }
                    })
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                DetailEditView(scrum: $newScrum)
                    .toolbar(content: {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                isPresentingNewScrumView = false
                                scrums.append(newScrum)
                            }
                        }
                    })
            }
        }
    }
}

#Preview {
    NewScrumSheet(isPresentingNewScrumView: .constant(true), scrums: .constant(DailyScrum.sampleData))
}
