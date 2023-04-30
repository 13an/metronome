import SwiftUI

struct MetronomeView: View {
    // parameters for displaying UI
    @State private var bpm: Int = 60
    @State private var isPlaying: Bool = false

    // instances of ViewController
    private var metronomeController = MetronomeController()

    var body: some View {
        VStack {
            Text("BPM")
                .font(.system(size: 20))

            // display BPM
            Text(String(bpm))
                .font(.system(size: 68))

            // bpm-controller
            HStack {
                // slow-down-button
                Button(action: {
                        self.bpm -= 1
                }, label: {
                    Image(systemName: "minus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48.0, height: 48.0)
                })
                .disabled(isPlaying)
                .padding(.trailing, 24)
                
                // speed-up-button
                Button(action: {
                        self.bpm += 1
                }, label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48.0, height: 48.0)
                })
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeView()
    }
}
