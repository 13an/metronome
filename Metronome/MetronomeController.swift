import Foundation
import CoreHaptics
import AVFoundation

class MetronomeController: MetronomeHapticFeedback {
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
}
