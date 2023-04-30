import SwiftUI
import Foundation
import CoreHaptics
import AVFoundation

struct BPMControlView: View {
    // parameters for displaying UI
    @State private var bpm: Int = 60
    @State private var isPlaying: Bool = false
    
    // long pressable button
    @State private var longPressed = false
    @State private var timer: Timer?

    // instances of ViewController
    private var metronomeController = MetronomeController()
    private var bpmControlHapticFeedback = BPMControlHapticFeedback()
    
    var body: some View {
        VStack {
            Text("BPM")
                .font(.system(size: 20))

            // display BPM
            Text(String(bpm))
                .font(.system(size: 68))
            
            // bpm-control: experiment long pressable button
            HStack {
                // slow-down-button
                Button(action: {
                    if longPressed {
                        longPressed = false
                    } else {
                        self.bpm -= 1
                        bpmControlHapticFeedback.play()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.longPressed = false
                        timer?.invalidate()
                        timer = nil
                    }
                }, label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48.0, height: 48.0)
                })
                .disabled(isPlaying)
                .simultaneousGesture(
                    LongPressGesture().onEnded{ _ in
                        self.longPressed.toggle()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                            self.bpm -= 1
                            bpmControlHapticFeedback.play()
                        })
                    }
                )
                .padding(.trailing, 24)
                
                // speed-up-button
                Button(action: {
                    if longPressed {
                        longPressed = false
                    } else {
                        self.bpm += 1
                        bpmControlHapticFeedback.play()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.longPressed = false
                        timer?.invalidate()
                        timer = nil
                    }
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48.0, height: 48.0)
                })
                .simultaneousGesture(
                    LongPressGesture().onEnded{ _ in
                        self.longPressed.toggle()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                            self.bpm += 1
                            bpmControlHapticFeedback.play()
                        })
                    }
                )
                .disabled(isPlaying)
            }
        }
    }
}

struct BPMControlView_Previews: PreviewProvider {
    static var previews: some View {
        BPMControlView()
    }
}

