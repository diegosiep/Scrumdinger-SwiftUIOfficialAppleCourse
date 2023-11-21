//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 15/11/23.
//

import Foundation


// The class must be marked as @MainActor before it is safe to update the published scrums property from the asynchronous load() method.
@MainActor
class ScrumStore: ObservableObject {
    // An ObservableObject includes an objectWillChange publisher that emits when one of its @Published properties is about to change. Any view observing an instance of ScrumStore will render again when the scrums value changes.
    
    @Published var scrums: [DailyScrum] = []
    
    private static func fileURL() throws -> URL {
        if #available(iOS 16.0, *) {
            try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appending(path: "scrums.data")
        } else {
            // Fallback on earlier versions
            try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("scrums.data")
        }
    }
    
    func load() async throws {
        //        You store the task in a let constant so that later you can access values returned or catch errors thrown from the task.
        let task = Task<[DailyScrum], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
            return dailyScrums
        }
        let scrums = try await task.value
        self.scrums = scrums
    }
    
    //    Waiting for the task ensures that any error thrown inside the task will be reported to the caller. The underscore character indicates that you aren’t interested in the result of task.value.
    func save(scrums: [DailyScrum]) async throws {
        let task = Task {
            let data  = try JSONEncoder().encode(scrums)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
        
    }
    
}
