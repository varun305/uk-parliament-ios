import SwiftUI
import SkeletonUI

struct BillDetailView: View {
    @StateObject var viewModel = BillDetailViewModel()
    var bill: Bill

    var body: some View {
        Group {
            if viewModel.bill != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
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

    @ViewBuilder
    var loadingView: some View {
        List {
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    ForEach(0..<5) { _ in
                        Text("")
                            .skeleton(with: true)
                            .frame(height: 10)
                    }
                }
                Spacer()
            }
            .multilineTextAlignment(.center)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)

            Section {
                NavigationLink {
                    Text("")
                } label: {
                    MemberRowLoading()
                }
                .disabled(true)

                NavigationLink {
                    Text("")
                } label: {
                    MemberRowLoading()
                }
                .disabled(true)
            }

            Section {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
            }

            Section {
                BillStageRowLoading()
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
            }

            Section {
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
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
                .listSectionSeparator(.hidden)

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
                        }
                    }
                }

                Section {
                    ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: nil)) {
                        Text("All publications")
                    }
                }
            }
            .listStyle(.grouped)
        }
    }
}
