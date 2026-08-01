import SwiftUI

struct BreathingDotsLoader: View {
    private let dotCount = 3
    private let dotSize: CGFloat = 10
    private let spacing: CGFloat = 14

    struct DotState: Identifiable {
        let id = UUID()
        var isAnimating = false
        let duration: Double = Double.random(in: 0.7...1.3)
        let delay: Double = Double.random(in: 0...0.5)
    }

    // Initialize state directly so SwiftUI knows the view count before rendering
    @State private var dotStates: [DotState] = (0..<3).map { _ in DotState() }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(dotStates) { dot in
                Circle()
                    .fill(Color.primary.opacity(0.85))
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(dot.isAnimating ? 1.0 : 0.4)
                    .opacity(dot.isAnimating ? 1.0 : 0.3)
                    .animation(
                        .easeInOut(duration: dot.duration)
                        .repeatForever(autoreverses: true)
                        .delay(dot.delay),
                        value: dot.isAnimating
                    )
            }
        }
        .onAppear {
            // Trigger state change after initial render frame
            for index in dotStates.indices {
                dotStates[index].isAnimating = true
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 10) {
            BreathingDotsLoader()

            Text("loading")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
