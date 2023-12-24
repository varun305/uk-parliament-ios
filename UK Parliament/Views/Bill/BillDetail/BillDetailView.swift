import SwiftUI

struct BillDetailView: View {
    @StateObject var viewModel = BillDetailViewModel()
    var bill: Bill

    var body: some View {
        Group {
            if let bill = viewModel.bill {
                List {
                    VStack(alignment: .center) {
                        if let longTitle = bill.longTitle {
                            Text(longTitle)
                                .font(.caption)
                                .padding(.top, 3)
                        }
                    }
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)

                    if let sponsors = bill.sponsors {
                        Section("Sponsors") {
                            ForEach(sponsors.sorted { $0.sortOrder < $1.sortOrder }, id: \.member.id) { sponsor in
                                NavigationLink {
                                    MemberDetailView(memberId: sponsor.member.memberId)
                                } label: {
                                    SponsorRow(sponsor: sponsor)
                                }
                            }
                        }
                    }

                    Section("Last update") {
                        Text(bill.lastUpdate.convertToDate())
                    }

                    Section("Current stage") {
                        HStack {
                            Text(bill.currentStage.description)
                            Spacer()

                            if bill.currentHouse == "Commons" {
                                CommonsBadge()
                            } else if bill.currentHouse == "Lords" {
                                LordsBadge()
                            }
                        }
                        NavigationLink {
                            Text("All stages")
                        } label: {
                            Text("See all stages")
                                .foregroundStyle(.secondary)
                                .italic()
                                .font(.footnote)
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
