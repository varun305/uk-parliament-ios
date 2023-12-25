import SwiftUI

struct CommonsVoteRow: View {
    var vote: CommonsVote

    var body: some View {
        VStack(alignment: .leading) {
            Text(vote.title)
                .bold()
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundStyle(.secondary)
                    Text("\(vote.ayeCount)")
                }
                Spacer()
                HStack {
                    Text("\(vote.noCount)")
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 2)
            Text("Division \(vote.number) on \(vote.date.convertToDate())")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
