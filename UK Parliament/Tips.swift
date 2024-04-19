import TipKit
import SwiftUI

struct HelpTip: Tip {
    var title: Text {
        Text("Can't find what you're looking for?")
    }

    var message: Text? {
        Text("Use the help menu to learn how to use this app")
    }
}
