import SwiftUI

struct MembersView: View {
    @StateObject var viewModel: MembersViewModel
    private var resultsText: String {
        "\(viewModel.totalResults) results"
    }

    var body: some View {
        Group {
            if viewModel.loading && viewModel.items.isEmpty {
                loadingView
            } else if !viewModel.items.isEmpty {
                scrollView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search " + (viewModel.house == .commons ? "MPs" : "lords"))
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle(viewModel.house == .commons ? "MPs" : "Lords")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
        .toolbarBackground(viewModel.house == .commons ? Color.commons.opacity(0.1) : Color.lords.opacity(0.1))
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<10) { _ in
                    DummyNavigationLink {
                        MemberRowLoading()
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
            Section(resultsText) {
                ForEach(viewModel.items) { member in
                    Group {
                        if let memberId = member.id {
                            ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                MemberRow(member: member)
                            }
                        } else {
                            MemberRow(member: member)
                        }
                    }
                    .onAppear(perform: { onScrollEnd(member: member )})
                }
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(member: Member) {
        if member == viewModel.items.last {
            viewModel.nextData()
        }
    }
}
