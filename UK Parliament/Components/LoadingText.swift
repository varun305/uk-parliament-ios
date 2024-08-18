import SwiftUI

struct LoadingText: View {
    @State private var isFaded = false
    
    var text: String
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .opacity(isFaded ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isFaded)
            .onAppear {
                isFaded = true
            }
    }
}
