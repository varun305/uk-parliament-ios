import SwiftUI

struct MemberLordsVoteRow: View {
    var memberVote: MemberLordsVote
    var body: some View {
        VStack(alignment: .leading) {
            if let publishedDivision = memberVote.publishedDivision {
                LordsVoteRow(vote: publishedDivision)
                    .padding(.bottom, 2)
            }
            if let memberWasContent = memberVote.memberWasContent {
                Group {
                    if memberWasContent {
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(.secondary)
                            Text("Content")
                            Spacer()
                        }
                        .foregroundStyle(.green)
                    } else {
                        HStack {
                            Spacer()
                            Text("Not content")
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.red)
                    }
                }
                .bold()
            }
        }
    }
}
