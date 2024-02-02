import SwiftUI

struct MemberCommonsVoteRow: View {
    var memberVote: MemberCommonsVote
    var body: some View {
        VStack(alignment: .leading) {
            if let publishedDivision = memberVote.publishedDivision {
                CommonsVoteRow(vote: publishedDivision)
                    .padding(.bottom, 2)
            }
            if let memberVotedAye = memberVote.memberVotedAye {
                Group {
                    if memberVotedAye {
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(.secondary)
                            Text("Voted aye")
                        }
                        .foregroundStyle(.green)
                    } else {
                        HStack {
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundStyle(.secondary)
                            Text("Voted no")
                        }
                        .foregroundStyle(.red)
                    }
                }
                .bold()
            }
        }
    }
}
