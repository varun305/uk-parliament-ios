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

    var body: some View {
        VStack(alignment: .leading) {
            Text(publication.title ?? "")
                .bold()
            Text(publication.formattedDate)
                .font(.subheadline)
            HStack(alignment: .center) {
                ForEach(texts, id: \.1) { filetype, url in
                    linkCapsule(filetype, url)
                        .frame(maxWidth: 130)
                }
                Spacer()
            }
        }
        .multilineTextAlignment(.leading)
    }

    @Binding var linkItem: String?

    @ViewBuilder
    private func linkCapsule(_ filetype: String, _ url: String) -> some View {
        Button {
            linkItem = url
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary, lineWidth: 3)
                HStack {
                    Image(systemName: "doc.fill")
                    Text("Open " + filetypeToString[filetype, default: filetype])
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 7)
            }
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
        }
        .foregroundStyle(.primary)
    }

    private var filetypeToString = [
        "application/pdf": "pdf",
        "text/html": "link",
        "text/xml": "xml",
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
