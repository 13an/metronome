import SwiftUI

struct LongPressableButtonView: View {
    @State private var labelText: String = "nothing happens"

    var body: some View {
        VStack {
            LongPressableButton(tapAction: {
                labelText = "Pushed !"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { labelText = "nothing happens" }
            }, longPressAction: {
                labelText = "Long pressed !"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { labelText = "nothing happens" }
            }, label: {
                Text("Push me!")
            })
                .buttonStyle(.bordered)
                .padding()
            Text(labelText)
                .padding()
        }
    }
}

struct LongPressableButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LongPressableButtonView()
    }
}
