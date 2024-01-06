import SwiftUI

struct BillPublicationLinksView: View {
    var publication: BillPublication
    var links: [BillPublicationLink] {
        publication.links
    }
    var files: [BillPublicationFile] {
        publication.files
    }

    var body: some View {
        List {
            if links.count > 0 {
                Section("Links") {
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
            if files.count > 0 {
                Section("Files") {
                    ForEach(files) { file in
                        NavigationLink {
                            BillPublicationFileView(publication: publication, file: file)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(file.filename)
                                    .bold()
                                Text(file.contentType)
                                    .italic()
                            }
                            .font(.footnote)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}
