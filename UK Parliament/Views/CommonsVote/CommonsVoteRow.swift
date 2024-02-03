import SwiftUI
import SkeletonUI

struct CommonsVoteRow: View {
    var vote: CommonsVote

    var body: some View {
        VStack(alignment: .leading) {
            Text(vote.title ?? "")
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
            if let number = vote.number, let date = vote.date {
                Text("Division \(number) on \(date.convertToDate())")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct CommonsVoteRowLoading: View {
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
        .frame(height: 80)
    }
}
