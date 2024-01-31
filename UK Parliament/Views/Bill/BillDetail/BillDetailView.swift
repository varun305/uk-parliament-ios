import SwiftUI

struct BillDetailView: View {
    @StateObject var viewModel = BillDetailViewModel()
    var bill: Bill

    var body: some View {
        Group {
            if let bill = viewModel.bill {
                List {
                    HStack(alignment: .center) {
                        if let longTitle = bill.longTitle {
                            Spacer()
                            Text(longTitle)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)

                    if let sponsors = bill.sponsors {
                        Section("Sponsors") {
                            ForEach(sponsors.sorted { $0.sortOrder < $1.sortOrder }, id: \.member.id) { sponsor in
                                if let memberId = sponsor.member.memberId {
                                    ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                        SponsorRow(sponsor: sponsor)
                                    }
                                } else {
                                    SponsorRow(sponsor: sponsor)
                                }
                            }
                        }
                    }

                    Section("Last update") {
                        Text(bill.lastUpdate.convertToDate())
                    }

                    Section("Current stage") {
                        BillStageRow(stage: bill.currentStage)
                        ContextAwareNavigationLink(value: .billStagesView(bill: bill)) {
                            Text("See all stages")
                                .foregroundStyle(.secondary)
                                .italic()
                                .font(.footnote)
                        }
                    }

                    Section {
                        ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: nil)) {
                            Text("All publications")
                        }
                    }
                }
            } else if viewModel.loading {
                ProgressView()
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle(bill.shortTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchData(for: bill.billId)
        }
    }
}
