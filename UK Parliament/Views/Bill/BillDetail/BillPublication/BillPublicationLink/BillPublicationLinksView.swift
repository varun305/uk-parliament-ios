import SwiftUI
import SafariServices

struct BillPublicationLinksView: View {
    var publication: BillPublication
    var links: [BillPublicationLink] {
        publication.links ?? []
    }
    var files: [BillPublicationFile] {
        publication.files ?? []
    }

    @State var linkItem: String? = nil

    var body: some View {
        List {
            if let description = publication.publicationType?.description {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.caption)
                }
            }
            if links.count > 0 {
                Section("Links") {
                    ForEach(links) { link in
                        Button {
                            linkItem = link.url
                        } label: {
                            VStack(alignment: .leading) {
                                Text(link.title ?? "")
                                    .bold()
                                Text(link.contentType ?? "")
                                    .italic()
                            }
                            .font(.footnote)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            if files.count > 0 {
                Section("Files") {
                    ForEach(files) { file in
                        Button {
                            if let publicationId = publication.id, let fileId = file.id {
                                linkItem = constructFetchFileUrl(publicationId: publicationId, fileId: fileId)
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(file.filename ?? "")
                                    .bold()
                                Text(file.contentType ?? "")
                                    .italic()
                            }
                            .font(.footnote)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
        }
        .navigationTitle(publication.publicationType?.name ?? "")
        .listStyle(.grouped)
        .fullScreenCover(item: $linkItem) { link in
            WebView(url: URL(string: link)!)
                .ignoresSafeArea()
        }
    }

    private func constructFetchFileUrl(publicationId: Int, fileId: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Publications/\(publicationId)/Documents/\(fileId)/Download"
    }
}

struct WebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
