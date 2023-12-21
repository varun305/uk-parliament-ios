import SwiftUI

struct PartiesView: View {
    @StateObject var viewModel = PartiesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.loading {
                    ProgressView()
                } else {
                    List(viewModel.parties) { party in
                        PartyRow(partyResult: party)
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $viewModel.search)
            .navigationTitle(viewModel.house == .commons ? "House of Commons" : "House of Lords")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            viewModel.house = .commons
                            viewModel.fetchData()
                        } label: {
                            Label("House of Commons", image: "commons")
                        }

                        Button {
                            viewModel.house = .lords
                            viewModel.fetchData()
                        } label: {
                            Label("House of Lords", image: "lords")
                        }
                    } label: {
                        Image(viewModel.house == .commons ? "commons" : "lords")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
