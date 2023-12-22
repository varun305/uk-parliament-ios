import SwiftUI


struct ConstituenciesView: View {
    @StateObject var viewModel = ConstituenciesViewModel()
    @State var scrollItem: Constituency.ID?

    @State var showFilterView = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("\(viewModel.numResults) results")
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.consituencies) { constituency in
                    ConstituencyRow(consituency: constituency)
                        .padding(.horizontal)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .navigationTitle("Constituencies")
        .navigationBarTitleDisplayMode(.inline)
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { old, new in
            if new == viewModel.consituencies.last?.id {
                viewModel.nextData()
            }
        }
        .onAppear {
            if viewModel.consituencies.isEmpty {
                viewModel.nextData()
            }
        }
    }
}
