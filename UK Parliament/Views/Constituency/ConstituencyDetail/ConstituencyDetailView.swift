import SwiftUI
import MapKit

private struct MapConfiguration: Identifiable {
    var constituency: Constituency
    var coordinates: [[[Double]]]
    var party: PartyModel?

    var id: Int {
        constituency.id
    }
}

struct ConstituencyDetailView: View {
    @StateObject var viewModel = ConstituencyDetailViewModel()
    var constituencyId: Int
    var memberLink: Bool = true
    @State private var mapConfig: MapConfiguration?

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
        .toolbar {
            if let constituency = viewModel.constituency, let geometry = viewModel.geometry {
                Button {
                    mapConfig = MapConfiguration(constituency: constituency, coordinates: geometry.flattenedCoordinates, party: constituency.member?.latestParty)
                } label: {
                    Image(systemName: "map.fill")
                }
            }
        }
        .sheet(item: $mapConfig) { config in
            NavigationStack {
                Map {
                    ForEach(0..<config.coordinates.count, id: \.self) { i in
                        MapPolygon(coordinates: viewModel.coordinates[i])
                            .stroke((config.party?.bgColor ?? .white), lineWidth: 1)
                            .foregroundStyle((config.party?.bgColor ?? .white).opacity(0.5))
                    }
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .navigationTitle(config.constituency.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            mapConfig = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                }
            }
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

                    PartyTaggedText(text: result.result.uppercased(), party: result.winningParty)
                }
            }
        }
    }

    private func convertDate(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}
