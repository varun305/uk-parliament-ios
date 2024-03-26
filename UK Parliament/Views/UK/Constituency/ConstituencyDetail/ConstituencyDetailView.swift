import SwiftUI
import MapKit
import SkeletonUI

struct ConstituencyDetailView: View {
    @StateObject var viewModel = ConstituencyDetailViewModel()
    var constituency: Constituency

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
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 50)
            }
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

    @State var showMapView = false
    private var mapConfig: MapConfiguration? {
        if let constituency = viewModel.constituency, let geometry = viewModel.geometry {
            return MapConfiguration(constituency: constituency, coordinates: geometry.flattenedCoordinates ?? [], party: constituency.member?.latestParty)
        }
        return nil
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section("Current MP") {
                membershipLink
            }
            if let config = mapConfig {
                Section {
                    Button {
                        showMapView = true
                    } label: {
                        Label("View on a map", systemImage: "map.fill")
                    }
                    .foregroundStyle(.primary)
                    .sheet(isPresented: $showMapView) {
                        mapSheet(config)
                    }
                }
            }
            Section("Past election results") {
                resultsView
            }
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    func mapSheet(_ config: MapConfiguration) -> some View {
        NavigationStack {
            mapView(config)
                .ignoresSafeArea(.all, edges: .bottom)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showMapView = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundStyle(.primary)
                    }
                }
        }
    }

    @ViewBuilder
    func mapView(_ config: MapConfiguration) -> some View {
        Map(interactionModes: [.all]) {
            let formattedCoords = config.coordinates.map {
                $0.map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }
            }
            ForEach(0..<formattedCoords.count, id: \.self) { i in
                MapPolygon(coordinates: formattedCoords[i])
                    .stroke((config.party?.bgColor ?? .white), lineWidth: 1)
                    .foregroundStyle((config.party?.bgColor ?? .white).opacity(0.5))
            }
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if let member = viewModel.constituency?.member, let memberId = member.id {
            ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                MemberRow(member: member)
            }
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
