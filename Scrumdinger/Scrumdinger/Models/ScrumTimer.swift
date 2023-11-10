//
//  ScrumTimer.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 31/10/23.
//

import Foundation


// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.


final class ScrumTimer: ObservableObject {
    
    //   A struct to keep track of meeting attendees during a meeting.
    
    struct Speaker: Identifiable {
        let name: String
        var isComplete: Bool
        let id = UUID()
        
    }
    
    @Published var activeSpeaker = ""
    @Published var secondsElapsed = 0
    @Published var secondsRemaining = 0
    
    //    A 'private(set)' means that the 'setter' is private while the 'getter' is still accessible outside of the 'private' keyword restrictions.
    private(set) var speakers: [Speaker] = []
    
    private(set) var lengthInMinutes: Int
    
    var speakerChangedAction: (() -> Void)?
    
    private weak var timer: Timer?
    private var timerStopped = false
    private var frequency: TimeInterval { 1.0 / 60.0 }
    private var lengthInSeconds: Int { lengthInMinutes * 60 }
    private var secondsPerSpeaker: Int { (lengthInMinutes * 60 / speakers.count)}
    private var secondsElapsedForSpeaker: Int = 0
    private var speakerIndex: Int = 0
    private var speakerText: String { return "Speaker \(speakerIndex + 1):" + speakers[speakerIndex].name }
    private var startDate: Date?
    
    /*
     Initialize a new timer. Initializing a time with no arguments creates a ScrumTimer with no attendees and zero length.
     Use `startScrum()` to start the timer.
     
     - Parameters:
     
     - lengthInMinutes: The meeting length.
     -  attendees: A list of attendees for the meeting.
     
     */
    
    init(lengthInMinutes: Int = 0, attendees: [DailyScrum.Attendee] = []) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
    }
    
    func startScrum() {
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { [weak self] timer in
            self?.update()
        })
        timer?.tolerance = 0.1
        changeToSpeaker(at: 0)
        
    }
    
    func stopScrum()  {
        timer?.invalidate()
        timerStopped = true
    }
    
    //    Advance timer to next speaker
    //    Done in the MainActor because we're updating the app's UI.
    
    func skipSpeaker() {
        Task { @MainActor in
            changeToSpeaker(at: speakerIndex + 1)
        }
        
    }
    
    private func changeToSpeaker(at index: Int) {
        if index > 0 {
            let previousIndexIndex = index - 1
            speakers[previousIndexIndex].isComplete = true
        }
        secondsElapsedForSpeaker = 0
        guard index < speakers.count else { return }
        speakerIndex = index
        activeSpeaker = speakerText
        secondsElapsed = index * secondsPerSpeaker
        secondsRemaining =  lengthInSeconds - secondsElapsed
        startDate = Date()
    }
    
    
    
    /*     Methods and variables are isolated by default inside Actors.
     The 'nonisolated' keyword indicates that code inside a method (or computed property for example), is not reading or writing any of the mutable state inside the actor. This enables us to call methods from non-async contexts.
     If you try to run this code in a playground:
     */
    
    
    //    actor AppleActor {
    //
    //        private var string: String = "Hello"
    //        func printSomething() {
    //            print("something")
    //        }
    //
    //    }
    //
    //    var actor = AppleActor()
    //    actor.printSomething()
    
    /*
     The code will not run, warning you of trying to run an actor-isolated method (i.e. outside of the method).
     Adding the nonisolated keyword to printSomething() method will allow you to use this method without having to encapsulate this method call inside of a Task (i.e. less code).
     
     */
    
    
    
    private func update() {
        Task { @MainActor in
            guard let startDate, !timerStopped else { return }
            let secondsElapsed = Int(Date().timeIntervalSince1970 - startDate.timeIntervalSince1970)
            secondsElapsedForSpeaker = secondsElapsed
            self.secondsElapsed = secondsPerSpeaker * speakerIndex + secondsElapsedForSpeaker
            guard secondsElapsed <= secondsPerSpeaker else { return }
            secondsRemaining = max(lengthInSeconds - self.secondsElapsed, 0)
            if secondsElapsedForSpeaker >= secondsPerSpeaker {
                changeToSpeaker(at: speakerIndex + 1)
                speakerChangedAction?()
            }
            
        }
        
    }
    
    /*
     Reset the timer with a new meeting length and new attendees.
     
     - Parameters:
     - lengthInMinutes: The meeting length.
     - attendees: The name of each attendee.
     */
    
    func reset(lengthInMinutes: Int, attendees: [DailyScrum.Attendee]) {
        self.lengthInMinutes = lengthInMinutes
        self.speakers = attendees.speakers
        secondsRemaining = lengthInSeconds
        activeSpeaker = speakerText
        
    }
}

extension Array<DailyScrum.Attendee> {
    var speakers: [ScrumTimer.Speaker] {
        if isEmpty {
            return [ScrumTimer.Speaker(name: "Speaker 1", isComplete: false)]
        } else {
            return map { ScrumTimer.Speaker(name: $0.name, isComplete: false) }
        }
    }
}

