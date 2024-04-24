import SwiftUI
import Charts

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    var vote: CommonsVote

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
        .onAppear {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    NavigationLink {
                        Text("")
                    } label: {
                        VoterRowLoading()
                    }
                    .disabled(true)
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @State private var grouping = Grouping.byParty

    @ViewBuilder
    var scrollView: some View {
        List {
            if let ayeCount = vote.ayeCount, let noCount = vote.noCount {
                HStack(alignment: .center) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                        Text("\(ayeCount)")
                            .font(.title)
                            .if(ayeCount > noCount) { $0.bold() }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Ayes \(ayeCount)"))
                    Spacer()
                    HStack {
                        Text("\(noCount)")
                            .font(.title)
                            .if(ayeCount < noCount) { $0.bold() }
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Noes \(noCount)"))
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }

            Picker("Group by", selection: $grouping.animation()) {
                Text("Group by party").tag(Grouping.byParty)
                Text("Group by member").tag(Grouping.byMember)
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)

            switch grouping {
            case .byParty:
                partiesView
            case .byMember:
                votesView
            }
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    var partiesView: some View {
        Section("Votes") {
            Chart {
                ForEach(viewModel.ayesGrouping, id: \.0) { party, number in
                    BarMark(
                        x: .value("Ayes", "Ayes"),
                        y: .value("Votes", number)
                    )
                    .foregroundStyle(by: .value("Party", "\(party.party), \(number)"))
                }
                ForEach(viewModel.noesGrouping, id: \.0) { party, number in
                    BarMark(
                        x: .value("Noes", "Noes"),
                        y: .value("Votes", number)
                    )
                    .foregroundStyle(by: .value("Party", "\(party.party), \(number)"))
                }
            }
            .chartForegroundStyleScale(range: graphColours())
            .chartLegend(.hidden)
            .frame(height: 300)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.ayesGrouping, id: \.0) { party, number in
                        legendRow(party, number)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    ForEach(viewModel.noesGrouping, id: \.0) { party, number in
                        legendRowRight(party, number)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func legendRow(_ party: PartyHashable, _ number: Int) -> some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color(hexString: party.partyColour ?? "0000000"))
            Text("\(party.party), \(number)")
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .foregroundStyle(.primary)
        .font(.footnote)
    }

    @ViewBuilder
    private func legendRowRight(_ party: PartyHashable, _ number: Int) -> some View {
        HStack {
            Text("\(party.party), \(number)")
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.primary)
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color(hexString: party.partyColour ?? "0000000"))
        }
        .font(.footnote)
    }

    private func graphColours() -> [Color] {
        viewModel.ayesGrouping.map {
            Color(hexString: $0.0.partyColour ?? "000000")
        } + viewModel.noesGrouping.map {
            Color(hexString: $0.0.partyColour ?? "000000")
        }
    }

    @ViewBuilder
    var votesView: some View {
        if let ayeTellers = viewModel.vote?.ayeTellers, ayeTellers.count > 0 {
            Section("Aye tellers") {
                ForEach(ayeTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }) { teller in
                    VoterNavigationLink(voter: teller)
                }
            }
        }

        if let noTellers = viewModel.vote?.noTellers, noTellers.count > 0 {
            Section("No tellers") {
                ForEach(noTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }) { teller in
                    VoterNavigationLink(voter: teller)
                }
            }
        }

        if let ayes = viewModel.vote?.ayes, ayes.count > 0 {
            Section("Ayes") {
                ForEach(ayes.sorted { $0.listAs ?? "" < $1.listAs ?? "" }) { aye in
                    VoterNavigationLink(voter: aye)
                }
            }
        }

        if let noes = viewModel.vote?.noes, noes.count > 0 {
            Section("Noes") {
                ForEach(noes.sorted { $0.listAs ?? "" < $1.listAs ?? "" }) { no in
                    VoterNavigationLink(voter: no)
                }
            }
        }
    }

    private struct VoterNavigationLink: View {
        var voter: CommonsVoter
        var body: some View {
            VoterRow(voter: voter)
                .ifLet(voter.memberId) { view, memberId in
                    ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                        view
                    }
                }
        }
    }
}

private enum Grouping {
    case byParty, byMember
}
