import SwiftUI

struct NoDataView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "rectangle.on.rectangle.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text("Nothing here")
                .font(.caption)
        }
    }
}
