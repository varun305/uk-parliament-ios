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
                            Spacer()
                        }
                        .foregroundStyle(.green)
                    } else {
                        HStack {
                            Spacer()
                            Text("Voted no")
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
