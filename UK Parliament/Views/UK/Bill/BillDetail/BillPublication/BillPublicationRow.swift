import SwiftUI
import SkeletonUI

struct BillPublicationRow: View {
    var publication: BillPublication

    var body: some View {
        VStack(alignment: .leading) {
            Text(publication.title ?? "")
                .bold()
            HStack {
                Text(publication.formattedDate)
                Spacer()
                Text(publication.publicationType?.name ?? "")
                    .italic()
            }
        }
        .font(.subheadline)
        .multilineTextAlignment(.leading)
    }
}

struct BillPublicationRowLoading: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("")
                .skeleton(with: true)
            Text("")
                .skeleton(with: true)
            Text("")
                .skeleton(with: true)
        }
        .frame(height: 40)
    }
}
