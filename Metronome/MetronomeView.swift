import SwiftUI

struct MetronomeView: View {
    // parameters for displaying UI
    @State private var bpm: Int = 60
    @State private var isPlaying: Bool = false

    // experiment long pressable button
    @State private var longPressed = false
    @State private var timer: Timer?

    // instances of ViewController
    private var metronomeController = MetronomeController()

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
                .simultaneousGesture(
                    LongPressGesture().onEnded{ _ in
                        self.longPressed.toggle()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (Timer) in
                            self.bpm -= 1
                        })
                    }
                )
                .disabled(isPlaying)
                .padding(.trailing, 24)
                
                // speed-up-button
                Button(action: {
                    if longPressed {
                        longPressed = false
                    } else {
                        self.bpm += 1
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
                        })
                    }
                )
                .disabled(isPlaying)

            }


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
