import SwiftUI

struct BillPublicationLinksView: View {
    var links: [BillPublicationLink]

    var body: some View {
        List {
            Section("\(links.count) results") {
                ForEach(links) { link in
                    VStack(alignment: .leading) {
                        Text(link.title)
                            .bold()
                        Text(link.contentType)
                            .italic()
                        Link("Go to content", destination: URL(string: link.url)!)
                            .foregroundColor(.accentColor)
                    }
                    .font(.footnote)
                }
            }
        }
        .listStyle(.plain)
    }
}
