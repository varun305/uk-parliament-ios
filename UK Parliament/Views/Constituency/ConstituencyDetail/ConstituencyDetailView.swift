import SwiftUI

struct ConstituencyDetailView: View {
    @StateObject var viewModel = ConstituencyDetailViewModel()
    var constituency: Constituency
    var memberLink: Bool = true

    var body: some View {
        List {
            Section("Current MP") {
                if memberLink {
                    membershipLink
                } else {
                    membershipTile
                }
            }

            Section("Past election results") {
                resultsView
            }
        }
        .navigationTitle(constituency.name)
        .onAppear {
            viewModel.fetchData(for: constituency)
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if let member = constituency.member {
            NavigationLink {
                MemberDetailView(member: member, constituencyLink: false)
            } label: {
                membershipTile
            }
        } else {
            membershipTile
        }
    }

    @ViewBuilder
    var membershipTile: some View {
        if let member = constituency.member {
            HStack {
                Text(member.nameDisplayAs)
                    .bold()
                Spacer()
                MemberPictureView(member: member)
                    .frame(width: 30, height: 30)
            }
        } else {
            Text("No member found")
                .italic()
        }
    }

    @ViewBuilder
    var resultsView: some View {
        ForEach(viewModel.electionResults) { result in
            NavigationLink {
                ConstituencyElectionDetailView(consituency: constituency, electionResult: result)
            } label: {
                HStack {
                    Text(convertDate(from: result.electionDate))
                        .lineLimit(1)
                        .font(.callout)

                    Spacer()

                    Text(result.result.uppercased())
                        .bold()
                        .foregroundStyle(Color(hexString: result.winningParty.foregroundColour ?? "000000"))
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color(hexString: result.winningParty.backgroundColour ?? "ffffff"))
                        }
                }
            }
        }
    }

    private func convertDate(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}
