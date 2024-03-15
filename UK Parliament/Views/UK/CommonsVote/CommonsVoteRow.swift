import SwiftUI
import SkeletonUI

struct CommonsVoteRow: View {
    var vote: CommonsVote

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(vote.title ?? "")
                    .multilineTextAlignment(.leading)
                    .bold()
                HStack(alignment: .center) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundStyle(.secondary)
                        Text("\(vote.ayeCount ?? 0)")
                    }
                    Spacer()
                    HStack {
                        Text("\(vote.noCount ?? 0)")
                        Image(systemName: "hand.thumbsdown.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 2)
                .accessibilityLabel(Text("Ayes \(vote.ayeCount ?? 0), Noes \(vote.noCount ?? 0)"))
                if let number = vote.number, let date = vote.date {
                    Text("Division \(number) on \(date.convertToDate())")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .accessibilityHidden(true)
        }
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
    }
}

struct CommonsVoteRowLoading: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text("")
                .skeleton(with: true)
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .skeleton(with: true)
                    Text("0")
                        .skeleton(with: true)
                }
                .frame(width: 50)
                Spacer()
                HStack {
                    Text("0")
                        .skeleton(with: true)
                    Image(systemName: "hand.thumbsdown.fill")
                        .skeleton(with: true)
                }
                .frame(width: 50)
            }
            .padding(.vertical, 2)
            Text("Division")
                .skeleton(with: true)
        }
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
        .frame(height: 90)
    }
}
