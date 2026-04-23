import SwiftUI
import SwiftSoup
import SkeletonUI

struct LordsVoteDetailView: View {
    @StateObject var viewModel = LordsVoteDetailViewModel()
    var vote: LordsVote

    var formattedDate: String {
        vote.date?.convertToDate() ?? ""
    }

    var body: some View {
        Group {
            if viewModel.vote != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .ifLet(vote.title) { $0.navigationTitle("Votes, \($1)") }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section {
                Text("").skeleton(with: true).frame(height: 10)
            }
            Section {
                Text("").skeleton(with: true).frame(height: 200)
            }
            Section {
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
            }
        }
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        if let detailedVote = viewModel.vote {
            let contentsCount = detailedVote.authoritativeContentCount ?? vote.authoritativeContentCount ?? 0
            let notContentsCount = detailedVote.authoritativeNotContentCount ?? vote.authoritativeNotContentCount ?? 0
            let majority = abs(contentsCount - notContentsCount)
            let contentsWon = contentsCount >= notContentsCount

            ScrollView {
                VStack(spacing: 16) {
                    if let amendmentNotes = detailedVote.amendmentMotionNotes {
                        amendmentNotesCard(html: amendmentNotes)
                    }
                    heroCard(vote: detailedVote, contentsCount: contentsCount, notContentsCount: notContentsCount, contentsWon: contentsWon)
                    statsRow(contentsCount: contentsCount, notContentsCount: notContentsCount, majority: majority)
                    if !viewModel.contentsGrouping.isEmpty {
                        partySection(title: "Contents votes by party", grouping: viewModel.contentsGrouping, total: contentsCount)
                    }
                    if !viewModel.notContentsGrouping.isEmpty {
                        partySection(title: "Not contents votes by party", grouping: viewModel.notContentsGrouping, total: notContentsCount)
                    }
                    viewAllVotesCard(detailedVote: detailedVote)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    @State private var notesExpanded = false

    @ViewBuilder
    func amendmentNotesCard(html: String) -> some View {
        let string = getAttributedString(from: html)
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    notesExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("Amendment motion notes")
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(notesExpanded ? 180 : 0))
                }
                .padding()
            }

            if notesExpanded {
                Divider()
                    .padding(.horizontal)
                Text(string)
                    .font(.subheadline)
                    .textSelection(.enabled)
                    .padding()
            }
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func heroCard(vote: LordsVote, contentsCount: Int, notContentsCount: Int, contentsWon: Bool) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(contentsWon ? Color.lords : Color(UIColor.systemGray))
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        if !formattedDate.isEmpty {
                            Text(formattedDate)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let number = vote.number {
                            Text("Division No. \(number)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text(contentsWon ? "CONTENTS WON" : "NOT CONTENTS WON")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(contentsWon ? Color.lords : Color(UIColor.systemGray))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                Divider()

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Contents")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(contentsCount.formatted())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(contentsWon ? Color.lords : .primary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Not Contents")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(notContentsCount.formatted())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(!contentsWon ? Color(UIColor.systemGray) : .primary)
                    }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func statsRow(contentsCount: Int, notContentsCount: Int, majority: Int) -> some View {
        HStack(spacing: 10) {
            statCard(title: "Contents", value: contentsCount.formatted(), color: Color.lords)
            statCard(title: "Not Contents", value: notContentsCount.formatted(), color: Color(UIColor.systemGray))
            statCard(title: "Majority", value: majority.formatted(), color: .primary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.callout)
                .fontWeight(.bold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .foregroundStyle(color)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    func partySection(title: String, grouping: [(PartyHashable, Int)], total: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 4)

            ForEach(grouping.indices, id: \.self) { index in
                let (party, count) = grouping[index]
                if index > 0 {
                    Divider().padding(.leading, 16)
                }
                partyRow(party: party, count: count, total: total)
            }

            Spacer().frame(height: 6)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func partyRow(party: PartyHashable, count: Int, total: Int) -> some View {
        let share: Double = total > 0 ? Double(count) / Double(total) : 0
        let partyColor = Color(hexString: party.partyColour ?? "888888")

        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(partyColor)
                        .frame(width: 10, height: 10)
                        .padding(.top, 3)
                    Text(party.party)
                        .font(.subheadline)
                }
                Spacer()
                Text(count.formatted())
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.systemFill))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(partyColor)
                        .frame(width: max(geo.size.width * share, share > 0 ? 4 : 0), height: 5)
                }
            }
            .frame(height: 5)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    func viewAllVotesCard(detailedVote: LordsVote) -> some View {
        ContextAwareNavigationLink(value: .allVotesView(allVotes: vote)) {
            HStack {
                Label("View all votes", image: "vote")
                    .labelStyle(SquircleLabelStyle(color: Color.lords))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
        .foregroundStyle(.primary)
    }

    private func getAttributedString(from html: String) -> AttributedString {
        guard let document = try? SwiftSoup.parse(html) else { return AttributedString("") }

        func traverseNodes(_ node: Node, attributedString: inout AttributedString) {
            if let textNode = node as? TextNode {
                var text = AttributedString(textNode.text())
                if let parent = node.parent(), parent.nodeName() == "b" || parent.nodeName() == "strong" {
                    text = AttributedString(textNode.text())
                    text.font = .body.bold()
                } else if let parent = node.parent(), parent.nodeName() == "i" || parent.nodeName() == "em" {
                    text = AttributedString(textNode.text())
                    text.font = .body.italic()
                }
                attributedString += text
            } else if node.nodeName() == "br" {
                attributedString += AttributedString("\n")
            } else {
                for child in node.getChildNodes() {
                    traverseNodes(child, attributedString: &attributedString)
                }
                if node.nodeName() == "p" {
                    attributedString += AttributedString("\n")
                }
            }
        }

        var attributedString = AttributedString("")
        traverseNodes(document, attributedString: &attributedString)

        return attributedString
    }
}
