import Foundation
import CoreHaptics
import AVFoundation

class MetronomeController {
    // parameter of metronome
    var bpm: Double = 120.0

    // AudioSession
    private var audioSession: AVAudioSession

    // parameters of audio data
    private let audioResorceNames = "metronome-sound"
    private var audioURL: URL?
    private var audioResorceID: CHHapticAudioResourceID?

    // HapticEngine
    private var hapticEngine: CHHapticEngine!

    // whether the device supports Core Haptics
    private var supportsHaptics: Bool = false

    // HapticPatternPlayer
    private var hapticPatternPlayer: CHHapticAdvancedPatternPlayer?

    // parameter of HapticEvent
    private let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
    private let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
    private var hapticDuration: TimeInterval = TimeInterval(0.01)

    // parameter of AudioEvent
    private let audioVolume = CHHapticEventParameter(parameterID: .audioVolume, value: 1.0)
    private var audioDuration: TimeInterval {
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
    private func createAndStartHapticEngine() {
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

    // play metronome
    func play() {
        // check the device supports Core Haptics
        guard supportsHaptics else { return }

        do {
            // start HapticEngine
            try hapticEngine.start()

            // create HapticPattern
            let pattern = try createPattern()   // defined this function below

            // create Player
            hapticPatternPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
            hapticPatternPlayer!.loopEnabled = true

            // play metronome
            try hapticPatternPlayer!.start(atTime: CHHapticTimeImmediate)

        } catch let error {
            print("Haptic Playback Error: \(error)")
        }
    }

    // stop metronome
    func stop(){
        // check the device supports Core Haptics
        guard supportsHaptics else { return }

        // stop
        hapticEngine.stop()
    }

    // create HapticPattern
    private func createPattern() throws -> CHHapticPattern {
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
