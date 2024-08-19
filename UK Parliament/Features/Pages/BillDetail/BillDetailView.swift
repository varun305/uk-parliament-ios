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
        .task {
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
        }
        .environment(\.isScrollEnabled, false)
    }
    
    var houseColor: Color {
        if bill.currentHouse?.lowercased() == "commons" {
            Color.commons
        } else if bill.currentHouse?.lowercased() == "lords" {
            Color.lords
        } else {
            Color.accentColor
        }
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

                if let sponsors = bill.sponsors, !sponsors.isEmpty {
                    Section("Sponsors") {
                        ForEach(sponsors) { sponsor in
                            if sponsor.member != nil {
                                SponsorRow(sponsor: sponsor)
                                    .ifLet(sponsor.member?.memberId) { view, memberId in
                                        ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                            view
                                        }
                                    }
                            }
                        }
                    }
                }

                if let _ = bill.lastUpdate {
                    Section("Last update") {
                        Label(bill.formattedDate, systemImage: "calendar")
                            .labelStyle(SquircleLabelStyle(color: houseColor))
                    }
                }

                Section {
                    ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: nil)) {
                        Label("View publications", image: "article")
                            .labelStyle(SquircleLabelStyle(color: houseColor))
                    }
                }

                if let currentStage = bill.currentStage {
                    Section("Current stage") {
                        BillStageRow(stage: currentStage)
                        ContextAwareNavigationLink(value: .billStagesView(bill: bill)) {
                            Label("See all stages", systemImage: "list.bullet")
                                .labelStyle(SquircleLabelStyle(color: houseColor))
                        }
                    }
                }
            }
        }
    }
}
