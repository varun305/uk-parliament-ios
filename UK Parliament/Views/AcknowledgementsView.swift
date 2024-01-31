import SwiftUI


struct AcknowledgementsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("© App developer. All rights reserved.")

            Group {
                Text("This product makes use of the UK Parliament API")
                    .foregroundStyle(.secondary)
                Link("Open Parliament Licence", destination: URL(string: "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence")!)
                    .italic()
            }
            .padding(.top)
        }
        .font(.footnote)
        .padding()
        .navigationTitle("Acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
    }
}
