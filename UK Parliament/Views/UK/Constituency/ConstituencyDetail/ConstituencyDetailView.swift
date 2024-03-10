import SwiftUI
import MapKit
import SkeletonUI

private struct MapConfiguration: Identifiable {
    var constituency: Constituency
    var coordinates: [[[Double]]]
    var party: PartyModel?

    var id: Int? {
        constituency.id
    }
}

struct ConstituencyDetailView: View {
    @StateObject var viewModel = ConstituencyDetailViewModel()
    var constituency: Constituency

    @State private var mapConfig: MapConfiguration?

    var body: some View {
        Group {
            if viewModel.constituency != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .navigationTitle(viewModel.constituency?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let constituencyId = constituency.id {
                viewModel.fetchConstituency(for: constituencyId)
                viewModel.fetchGeometry(for: constituencyId)
                viewModel.fetchElectionResults(for: constituencyId)
            }
        }
        .toolbar {
            if let constituency = viewModel.constituency, let geometry = viewModel.geometry {
                Button {
                    mapConfig = MapConfiguration(constituency: constituency, coordinates: geometry.flattenedCoordinates ?? [], party: constituency.member?.latestParty)
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
                .navigationTitle(config.constituency.name ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            mapConfig = nil
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
            }
            Section("") {
                ForEach(0..<4) { _ in
                    DummyNavigationLink {
                        Text("")
                            .skeleton(with: true)
                            .frame(height: 10)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section("Current MP") {
                membershipLink
            }

            Section("Past election results") {
                resultsView
            }
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    var membershipLink: some View {
        if let constituency = viewModel.constituency, let memberId = constituency.member?.id {
            ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
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
                Text(member.nameDisplayAs ?? "")
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
        ForEach(viewModel.electionResults.sorted { $0.electionDate ?? "" > $1.electionDate ?? "" }) { result in
            ContextAwareNavigationLink(value: .constituencyElectionDetailView(constituency: constituency, election: result)) {
                HStack {
                    Text(result.formattedDate)
                        .lineLimit(1)
                        .font(.callout)
                    Spacer()
                    PartyTaggedText(text: result.result?.uppercased() ?? "", party: result.winningParty)
                }
            }
        }
    }
}
