import SwiftUI
import Foundation
import CoreHaptics
import AVFoundation

struct MetronomeView: View {
    // parameters for displaying UI
    @State private var bpm: Int = 60
    @State private var isPlaying: Bool = false

    // long pressable button
    @State private var longPressed = false
    @State private var timer: Timer?

    // instances of ViewController
    private var metronomeController = MetronomeController()
    private var coreHapticsController = MetronomeHapticFeedback()
    private var bpmControlView = BPMControlView()

    var body: some View {
        VStack {
            // BPMControlView
            bpmControlView

            // play/stop button
            if isPlaying == false {
                Button(action: {
                    metronomeController.bpm = Double(self.bpm)
                    metronomeController.play()
                    isPlaying = true
                }) {
                    Text("Start")
                        .font(.system(size: 60))
                }
            } else {
                Button(action: {
                    metronomeController.stop()
                    isPlaying = false
                }) {
                    Text("Stop")
                        .font(.system(size: 60))
                }
            }
        }
    }
}

struct MetronomeView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
