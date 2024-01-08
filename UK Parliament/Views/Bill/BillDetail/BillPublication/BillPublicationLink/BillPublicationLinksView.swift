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
                        ContextAwareNavigationLink(value: getNavigationTypeForFile(file: file)) {
                            FileTile(file: file)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func getNavigationTypeForFile(file: BillPublicationFile) -> NavigationItem {
        switch file.contentType {
        case "application/pdf":
            return .billPublicationPDFView(publication: publication, file: file)
        case "text/html":
            return ._404
        default:
            return ._404
        }
    }

    private struct FileTile: View {
        var file: BillPublicationFile
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(file.filename)
                        .bold()
                    Text(file.contentType)
                        .italic()
                }
                Spacer()
                Text(fileSizeString(fromBytes: file.contentLength))
            }
            .font(.footnote)
        }

        private func fileSizeString(fromBytes bytes: Int) -> String {
            let byteCountFormatter = ByteCountFormatter()
            byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
            byteCountFormatter.countStyle = .file
            return byteCountFormatter.string(fromByteCount: Int64(bytes))
        }
    }
}
