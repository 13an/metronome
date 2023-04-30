//
//  aaaaa.swift
//  Metronome
//
//  Created by 13an on 2023/05/01.
//

import Foundation
import CoreHaptics
import AVFoundation

class BPMControlHapticFeedback {
    // HapticEngine
    private var hapticEngine: CHHapticEngine!
    
    // whether the device supports Core Haptics
    private var supportsHaptics: Bool = false
    
    // HapticPatternPlayer
    private var hapticPatternPlayer: CHHapticAdvancedPatternPlayer?
    
    // parameter of HapticEvent
    private let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
    private let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)
    private var hapticDuration: TimeInterval = TimeInterval(0.01)
    
    init(){
        //　check the device supports Core Haptics
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics

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
            hapticEngine = try CHHapticEngine()
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

            // add HapticEvent to eventList
            eventList.append(CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0))
            eventList.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: self.hapticDuration))

            // create and return HapticPattern
            let hapticPattern = try CHHapticPattern(events: eventList, parameters: [])
            return hapticPattern

        } catch let error {
            throw error
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
}
