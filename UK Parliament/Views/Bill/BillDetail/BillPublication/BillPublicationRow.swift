import SwiftUI

struct BillPublicationRow: View {
    var publication: BillPublication

    var body: some View {
        VStack(alignment: .leading) {
            Text(publication.title ?? "")
            Text(publication.publicationType?.name ?? "")
                .italic()
            Text(publication.formattedDate)
                .bold()
        }
        .font(.subheadline)
    }
}
