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
        .task {
            if let constituencyId = constituency.id {
                viewModel.fetchConstituency(for: constituencyId)
                viewModel.fetchGeometry(for: constituencyId)
                viewModel.fetchElectionResults(for: constituencyId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    Color(UIColor.secondarySystemGroupedBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 260)
                        .skeleton(with: true)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 4)
                        .skeleton(with: true)
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("").skeleton(with: true).frame(width: 200, height: 16)
                            Text("").skeleton(with: true).frame(width: 120, height: 12)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 0) {
                    Text("").skeleton(with: true).frame(width: 100, height: 14)
                        .padding(.horizontal)
                        .padding(.top, 14)
                        .padding(.bottom, 8)
                    Divider()
                    MemberRowLoading().padding(.horizontal)
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 0) {
                    Text("").skeleton(with: true).frame(width: 160, height: 14)
                        .padding(.horizontal)
                        .padding(.top, 14)
                        .padding(.bottom, 8)
                    Divider()
                    ForEach(0..<4) { i in
                        if i > 0 { Divider().padding(.leading) }
                        Text("").skeleton(with: true).frame(height: 10)
                            .padding(.horizontal)
                            .padding(.vertical, 14)
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .environment(\.isScrollEnabled, false)
    }

    private var mapConfig: MapConfiguration? {
        if let constituency = viewModel.constituency, let geometry = viewModel.geometry {
            return MapConfiguration(constituency: constituency, coordinates: geometry.flattenedCoordinates ?? [], party: constituency.member?.latestParty)
        }
        return nil
    }

    var partyColor: Color {
        Color(hexString: viewModel.constituency?.member?.latestParty?.backgroundColour ?? "888888")
    }

    @ViewBuilder
    var scrollView: some View {
        if let constituencyData = viewModel.constituency {
            ScrollView {
                VStack(spacing: 16) {
                    heroCard(constituency: constituencyData)
                    if let member = constituencyData.member, let memberId = member.id {
                        mpCard(member: member, memberId: memberId)
                    }
                    if !viewModel.electionResults.isEmpty {
                        electionResultsCard()
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    @ViewBuilder
    func heroCard(constituency: Constituency) -> some View {
        VStack(spacing: 0) {
            Group {
                if let config = mapConfig {
                    mapView(config)
                        .transition(.opacity)
                } else {
                    Color(UIColor.secondarySystemGroupedBackground)
                        .overlay {
                            ProgressView()
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 260)
            .clipped()
            .animation(.easeInOut(duration: 0.3), value: mapConfig != nil)

            Rectangle()
                .fill(partyColor)
                .frame(height: 4)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(constituency.name ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let startDate = constituency.startDate {
                        let formatted = startDate.convertToDate()
                        if !formatted.isEmpty {
                            Text("Constituency since \(formatted)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func mapView(_ config: MapConfiguration) -> some View {
        Map(interactionModes: []) {
            let formattedCoords = config.coordinates.map {
                $0.map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }
            }
            ForEach(0..<formattedCoords.count, id: \.self) { i in
                MapPolygon(coordinates: formattedCoords[i])
                    .stroke((config.party?.bgColor ?? Color.primary), lineWidth: 2)
                    .foregroundStyle((config.party?.bgColor ?? .primary).opacity(0.3))
            }
        }
    }

    @ViewBuilder
    func mpCard(member: Member, memberId: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Current MP")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Divider()

            ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                HStack {
                    MemberRow(member: member)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .foregroundStyle(.primary)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func electionResultsCard() -> some View {
        let results = viewModel.electionResults
        VStack(alignment: .leading, spacing: 0) {
            Text("Past election results")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Divider()

            ForEach(results.indices, id: \.self) { index in
                let result = results[index]
                if index > 0 {
                    Divider().padding(.leading)
                }
                ContextAwareNavigationLink(value: .constituencyElectionDetailView(constituency: constituency, election: result)) {
                    HStack {
                        Text(result.formattedDate)
                            .lineLimit(1)
                            .font(.callout)
                        Spacer()
                        PartyTaggedText(text: result.result?.uppercased() ?? "", party: result.winningParty)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .foregroundStyle(.primary)
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
