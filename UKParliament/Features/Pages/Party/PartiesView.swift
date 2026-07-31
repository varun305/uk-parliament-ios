import SwiftUI
import SkeletonUI

struct PartiesView: View {
    @StateObject var viewModel = PartiesViewModel()

    var totalSeats: Int {
        viewModel.parties.compactMap { $0.total }.reduce(0, +)
    }

    var body: some View {
        Group {
            if viewModel.loading {
                LoadingView()
            } else {
                scrollView
            }
        }
        .navigationTitle(viewModel.house == .commons ? "House of Commons" : "House of Lords")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchData()
        }
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("House", selection: $viewModel.house) {
                    Text("Commons").tag(House.commons)
                    Text("Lords").tag(House.lords)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                distributionCard
                partiesCard
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    @ViewBuilder
    var distributionCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Seat distribution")
                    .font(.headline)
                Spacer()
                Text("\(totalSeats) seats")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top, 14)
            .padding(.bottom, 8)

            Divider()

            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(viewModel.parties, id: \.id) { party in
                        if let total = party.total, total > 0, totalSeats > 0 {
                            effectiveColor(for: party)
                                .frame(width: geo.size.width * Double(total) / Double(totalSeats))
                        }
                    }
                }
            }
            .frame(height: 32)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .padding(.vertical, 14)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    var partiesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Parties")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Divider()

            ForEach(viewModel.parties.indices, id: \.self) { index in
                let party = viewModel.parties[index]
                if index > 0 {
                    Divider().padding(.leading, 52)
                }
                partyRow(party)
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func partyRow(_ partyResult: PartyResultModel) -> some View {
        if let party = partyResult.party {
            let proportion = totalSeats > 0 ? Double(partyResult.total ?? 0) / Double(totalSeats) : 0

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(effectiveColor(for: partyResult))
                    Text(party.abbreviation?.uppercased() ?? "")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(party.fgColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(4)
                }
                .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 5) {
                    Text(party.name ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.systemFill))
                        .frame(height: 4)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(effectiveColor(for: partyResult))
                                    .frame(width: max(geo.size.width * proportion, 0), height: 4)
                            }
                        }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(partyResult.total ?? 0)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                    Text(String(format: "%.1f%%", proportion * 100))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    /// Returns the party's background colour, falling back to system gray for white/blank parties.
    func effectiveColor(for party: PartyResultModel) -> Color {
        let hex = party.party?.backgroundColour?.lowercased() ?? ""
        if hex == "ffffff" || hex.isEmpty {
            return Color(UIColor.systemGray3)
        }
        return Color(hexString: hex)
    }
}
