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
                            ForEach(sponsors) { sponsor in
                                if let memberId = sponsor.member?.memberId {
                                    ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                        SponsorRow(sponsor: sponsor)
                                    }
                                } else {
                                    SponsorRow(sponsor: sponsor)
                                }
                            }
                        }
                    }

                    if let _ = bill.lastUpdate {
                        Section("Last update") {
                            Text(bill.formattedDate)
                        }
                    }

                    if let currentStage = bill.currentStage {
                        Section("Current stage") {
                            BillStageRow(stage: currentStage)
                            ContextAwareNavigationLink(value: .billStagesView(bill: bill)) {
                                Text("See all stages")
                                    .foregroundStyle(.secondary)
                                    .italic()
                                    .font(.footnote)
                            }
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
        .navigationTitle(bill.shortTitle ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let billId = bill.billId {
                viewModel.fetchData(for: billId)
            }
        }
    }
}
