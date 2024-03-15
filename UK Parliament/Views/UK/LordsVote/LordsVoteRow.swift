import SwiftUI

struct LordsVoteRow: View {
    var vote: LordsVote
    
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
                .accessibilityLabel(Text("Contents \(vote.authoritativeContentCount ?? 0), Not contents \(vote.authoritativeNotContentCount ?? 0)"))
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
