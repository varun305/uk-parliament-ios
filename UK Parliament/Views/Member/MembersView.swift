import SwiftUI

struct MembersView: View {
    @StateObject var viewModel = MembersViewModel()
    private var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var body: some View {
        Group {
            if viewModel.members.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search " + (viewModel.house == .commons ? "MPs" : "lords"))
        .onSubmit(of: .search) {
            viewModel.nextData(reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle(viewModel.house == .commons ? "MPs" : "Lords")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker("House", selection: $viewModel.house) {
                    Label("House of Commons", image: "commons").tag(House.commons)
                    Label("House of Lords", image: "lords").tag(House.lords)
                }
            }
        }
        .onAppear {
            if viewModel.members.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
        .toolbarBackground(viewModel.house == .commons ? Color.commons.opacity(0.1) : Color.lords.opacity(0.1))
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<10) { _ in
            NavigationLink {
                Text("")
            } label: {
                MemberRowLoading()
            }
            .disabled(true)
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section(resultsText) {
                ForEach(viewModel.members) { member in
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
        .listStyle(.plain)
    }

    private func onScrollEnd(member: Member) {
        if member == viewModel.members.last {
            viewModel.nextData()
        }
    }
}
