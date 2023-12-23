import SwiftUI


struct ConstituenciesView: View {
    @StateObject var viewModel = ConstituenciesViewModel()
    @State var scrollItem: Constituency.ID?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : ""))
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.consituencies) { constituency in
                    NavigationLink {
                        ConstituencyDetailView(constituencyId: constituency.id)
                    } label: {
                        ConstituencyRow(consituency: constituency)
                            .padding(.horizontal)
                    }
                    .foregroundStyle(.primary)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .searchable(text: $viewModel.search, prompt: "Search for constituencies")
        .onSubmit(of: .search) {
            viewModel.nextData(reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Constituencies")
        .navigationBarTitleDisplayMode(.inline)
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { _, new in
            if new == viewModel.consituencies.last?.id {
                viewModel.nextData()
            }
        }
        .onAppear {
            if viewModel.consituencies.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }
}
