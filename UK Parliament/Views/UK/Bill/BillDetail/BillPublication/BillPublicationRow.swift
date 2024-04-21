import SwiftUI
import SkeletonUI

struct BillPublicationRow: View {
    var publication: BillPublication

    init(publication: BillPublication, linkItem: Binding<String?>) {
        self.publication = publication
        self._linkItem = linkItem
    }

    var texts: [(String, String)] {
        return (publication.files?.compactMap { file in
            if let filetype = file.contentType, let publicationId = publication.id, let fileId = file.id {
                return (filetype, constructFetchFileUrl(publicationId: publicationId, fileId: fileId))
            } else {
                return nil
            }
        } ?? []) + (publication.links?.compactMap { link in
            if let filetype = link.contentType, let url = link.url {
                return (filetype, url)
            } else {
                return nil
            }
        } ?? [])
    }

    private func constructFetchFileUrl(publicationId: Int, fileId: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Publications/\(publicationId)/Documents/\(fileId)/Download"
    }

    @Binding var linkItem: String?

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(publication.title ?? "")
                    .bold()
                Text(publication.formattedDate)
                    .font(.subheadline)
            }
            .multilineTextAlignment(.leading)
            .accessibilityElement(children: .combine)
            Spacer()
            
            if texts.count == 1 {
                Button {
                    linkItem = texts[0].1
                } label: {
                    Text("Open")
                        .bold()
                }
                .buttonStyle(.bordered)
            } else if texts.count > 1 {
                Menu {
                    ForEach(texts, id: \.1) { filetype, link in
                        Button {
                            linkItem = link
                        } label: {
                            Label(filetypeToString[filetype, default: filetype], systemImage: "doc.fill")
                        }
                    }
                } label: {
                    Text("Open")
                        .bold()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var filetypeToString = [
        "application/pdf": "PDF",
        "text/html": "HTML",
        "text/xml": "XML",
    ]
}

struct BillPublicationRowLoading: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("")
                .skeleton(with: true)
            HStack {
                Text("")
                    .skeleton(with: true)
                Spacer()
                Text("")
                    .skeleton(with: true)
            }
        }
        .frame(height: 40)
    }
}
