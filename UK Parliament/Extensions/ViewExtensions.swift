import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLet<Content: View, T: Any>(_ variable: T?, transform: (Self, T) -> Content) -> some View {
        if let variable = variable {
            transform(self, variable)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifElse<TrueContent: View, FalseContent: View>(_ condition: Bool, trueTransform: (Self) -> TrueContent, falseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }

    @ViewBuilder
    func appMask() -> some View {
        self
            .mask {
                RoundedRectangle(cornerRadius: 15)
            }
    }

    @ViewBuilder
    func appOverlay() -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(UIColor.systemGray3), lineWidth: 3)
            }
    }

    @ViewBuilder
    func appBackground(colorScheme: ColorScheme) -> some View {
        self
            .background {
                Color(UIColor.systemBackground)
            }
    }

    @ViewBuilder
    func appShadow() -> some View {
        self
            .shadow(color: .secondary, radius: 0)
    }
}
