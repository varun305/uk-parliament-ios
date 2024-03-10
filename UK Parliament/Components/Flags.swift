import SwiftUI

struct UKFlag: View {
    var body: some View {
        ZStack {
            Color.white
            Image("gb")
        }
        .mask {
            Circle()
        }
        .overlay {
            Circle()
                .stroke(lineWidth: 1)
        }
        .frame(maxWidth: 20, maxHeight: 20)
    }
}

struct ScotlandFlag: View {
    var body: some View {
        ZStack {
            Color.white
            Image("sc")
        }
        .mask {
            Circle()
        }
        .overlay {
            Circle()
                .stroke(lineWidth: 1)
        }
        .frame(maxWidth: 20, maxHeight: 20)
    }
}

#Preview {
    HStack(spacing: 20) {
        UKFlag()
        ScotlandFlag()
    }
}
