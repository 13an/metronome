import Foundation
import CoreHaptics
import AVFoundation

class MetronomeHapticFeedback {
    // parameter of metronome
    var bpm: Double = 120.0
    
    // AudioSession
    var audioSession: AVAudioSession

    // parameters of audio data
    let audioResorceNames = "metronome-sound"
    var audioURL: URL?
    var audioResorceID: CHHapticAudioResourceID?
    
    // HapticEngine
    var hapticEngine: CHHapticEngine!
    
    // whether the device supports Core Haptics
    var supportsHaptics: Bool = false
    
    // HapticPatternPlayer
    var hapticPatternPlayer: CHHapticAdvancedPatternPlayer?
    
    // parameter of HapticEvent
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
    var hapticDuration: TimeInterval = TimeInterval(0.01)
    
    // parameter of AudioEvent
    let audioVolume = CHHapticEventParameter(parameterID: .audioVolume, value: 1.0)
    var audioDuration: TimeInterval {
        TimeInterval(60.0 / bpm)
    }
    
    init(){
        // AudioSession settings
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set and activate audio session category.")
        }

        //　check the device supports Core Haptics
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics

        // import audio data
        if let path = Bundle.main.path(forResource: audioResorceNames, ofType: "mp3") {
            audioURL = URL(fileURLWithPath: path)
        } else {
            print("Error: Failed to find audioURL")
        }

        createAndStartHapticEngine()    // define this function below
    }

    // create and start Engine
    func createAndStartHapticEngine() {
        // check the device supports Core Haptics
        guard supportsHaptics else {
            print("This device does not support CoreHaptics")
            return
        }

        // pass AudioSession and create HapticEngine
        do {
            hapticEngine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }

        // start HapticEngine
        do {
            try hapticEngine.start()
        } catch let error {
            print("Engin Start Error: \(error)")
        }
    }

    // create HapticPattern
    func createPattern() throws -> CHHapticPattern {
        do {
            var eventList: [CHHapticEvent] = []

            // get AudioResorceID
            audioResorceID = try self.hapticEngine.registerAudioResource(audioURL!)

            // add HapticEvent to eventList
            eventList.append(CHHapticEvent(audioResourceID: audioResorceID!, parameters: [audioVolume], relativeTime: 0, duration: self.audioDuration))
            eventList.append(CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0))
            eventList.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: self.hapticDuration))

            // create and return HapticPattern
            let hapticPattern = try CHHapticPattern(events: eventList, parameters: [])
            return hapticPattern

        } catch let error {
            throw error
        }
    }
}

