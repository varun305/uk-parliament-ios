import SwiftUI

struct ConstituenciesView: View {
    @StateObject var viewModel = ConstituenciesViewModel()
    @State var scrollItem: Constituency.ID?

    var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.consituencies) { constituency in
                    ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency), addChevron: true) {
                        ConstituencyRow(consituency: constituency)
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.primary)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter a name or postcode")
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
