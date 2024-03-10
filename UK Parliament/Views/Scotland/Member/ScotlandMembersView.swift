import SwiftUI

struct ScotlandMembersView: View {
    @StateObject var viewModel = ScotlandMembersViewModel()

    var body: some View {
        Group {
            if viewModel.loading {
                loadingView
            } else if !viewModel.filteredMembers.isEmpty {
                scrollView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for an MSP")
        .autocorrectionDisabled(true)
        .navigationTitle("MSPs")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getData()
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
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
        List(viewModel.filteredMembers) { member in
            ScotlandMemberRow(member: member)
        }
        .listStyle(.grouped)
    }
}

#Preview {
    ScotlandMembersView()
}
