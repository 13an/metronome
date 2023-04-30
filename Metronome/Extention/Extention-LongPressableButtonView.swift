import SwiftUI

struct LongPressableButton<Label>: View  where Label: View{
    var tapAction: (() -> Void)?
    var longPressAction: (() -> Void )?
    var label: (() -> Label)
    @State private var longPressed = false

    init(tapAction: (() -> Void)? = nil, longPressAction: (() -> Void)? = nil, label: @escaping (() -> Label) ) {
        self.tapAction = tapAction
        self.longPressAction = longPressAction
        self.label = label
    }

    var body: some View {
        Button(action: {
            if longPressed {
                longPressAction?()
                longPressed = false
            } else {
                tapAction?()
            }
        }, label: {
            label()
        })
            .simultaneousGesture(
                LongPressGesture().onEnded{ _ in
                    longPressed = true
                }
            )
            .padding()
    }
}
