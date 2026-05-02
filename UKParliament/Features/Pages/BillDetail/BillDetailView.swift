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
            ScrollView {
                VStack(spacing: 16) {
                    if let longTitle = bill.longTitle {
                        Text(longTitle)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    if let sponsors = bill.sponsors {
                        let validSponsors = sponsors.filter { $0.member != nil }
                        if !validSponsors.isEmpty {
                            MinimalSection(title: "Sponsors") {
                                ForEach(validSponsors.indices, id: \.self) { index in
                                    let sponsor = validSponsors[index]
                                    if index > 0 {
                                        Divider().padding(.leading, 16)
                                    }
                                    if let memberId = sponsor.member?.memberId {
                                        ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                            HStack {
                                                SponsorRow(sponsor: sponsor)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundStyle(.tertiary)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                        }
                                        .foregroundStyle(.primary)
                                    } else {
                                        SponsorRow(sponsor: sponsor)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                    }
                                }
                            }
                        }
                    }

                    if let _ = bill.lastUpdate {
                        MinimalSection(title: "Last Update") {
                            HStack {
                                Label(bill.formattedDate, systemImage: "calendar")
                                    .labelStyle(SquircleLabelStyle(color: houseColor))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                        }
                    }

                    MinimalSection(title: "Publications") {
                        ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: nil)) {
                            DetailLinkRow(title: "View publications", image: "article", color: houseColor)
                        }
                        .foregroundStyle(.primary)
                    }

                    if let currentStage = bill.currentStage {
                        MinimalSection(title: "Current Stage") {
                            HStack {
                                BillStageRow(stage: currentStage)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            Divider().padding(.leading, 16)
                            ContextAwareNavigationLink(value: .billStagesView(bill: bill)) {
                                DetailLinkRow(title: "See all stages", image: "list.bullet", isSystemImage: true, color: houseColor)
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
