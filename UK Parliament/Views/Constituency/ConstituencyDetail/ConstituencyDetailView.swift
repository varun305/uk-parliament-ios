import SwiftUI
import MapKit

struct ConstituencyDetailView: View {
    @StateObject var viewModel = ConstituencyDetailViewModel()
    var constituencyId: Int
    var memberLink: Bool = true

    var body: some View {
        Group {
            if let constituency = viewModel.constituency {
                List {
                    Section("Current MP") {
                        if memberLink {
                            membershipLink
                        } else {
                            membershipTile
                        }
                    }

                    if let geometry = viewModel.geometry {
                        Map {
                            MapPolygon(coordinates: viewModel.coordinates)
                                .stroke(constituency.member?.latestParty.bgColor ?? .white, lineWidth: 1)
                                .foregroundStyle((constituency.member?.latestParty.bgColor ?? .white).opacity(0.3))
                        }
                        .disabled(true)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .listRowBackground(Color.clear)
                        .mask {
                            RoundedRectangle(cornerRadius: 5)
                        }
                    }

                    Section("Past election results") {
                        resultsView
                    }
                }
                .navigationTitle(constituency.name)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchConstituency(for: constituencyId)
            viewModel.fetchGeometry(for: constituencyId)
            viewModel.fetchData(for: constituencyId)
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if let constituency = viewModel.constituency, let member = constituency.member {
            NavigationLink {
                MemberDetailView(memberId: member.id, constituencyLink: false)
            } label: {
                membershipTile
            }
        } else {
            membershipTile
        }
    }

    @ViewBuilder
    var membershipTile: some View {
        if let constituency = viewModel.constituency, let member = constituency.member {
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
                ConstituencyElectionDetailView(constituencyId: constituencyId, electionResult: result)
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
