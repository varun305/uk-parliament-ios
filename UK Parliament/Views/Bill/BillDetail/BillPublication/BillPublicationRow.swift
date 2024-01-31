import SwiftUI
import SkeletonUI

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
