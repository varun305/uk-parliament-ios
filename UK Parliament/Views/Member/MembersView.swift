import SwiftUI

struct MembersView: View {
    @StateObject var viewModel = MembersViewModel()
    @State var scrollItem: Member.ID?
    private var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.members) { member in
                    NavigationLink {
                        MemberDetailView(member: member)
                    } label: {
                        MemberRow(member: member)
                            .padding(.horizontal)
                    }
                    .foregroundStyle(.primary)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .searchable(text: $viewModel.search)
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
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { _, new in
            if new == viewModel.members.last?.id {
                viewModel.nextData()
            }
        }
        .onAppear {
            if viewModel.members.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }
}
