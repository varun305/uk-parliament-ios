import SwiftUI

struct LordsVoteRow: View {
    var vote: LordsVote
    var body: some View {
        VStack(alignment: .leading) {
            Text(vote.title ?? "")
                .bold()
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundStyle(.secondary)
                    Text("\(vote.authoritativeContentCount ?? 0)")
                }
                Spacer()
                HStack {
                    Text("\(vote.authoritativeNotContentCount ?? 0)")
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
