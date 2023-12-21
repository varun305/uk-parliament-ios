import SwiftUI

struct PartiesView: View {
    @StateObject var viewModel = PartiesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.loading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack {
                            Divider()
                            ForEach(viewModel.parties) { party in
                                PartyRow(partyResult: party)
                                    .padding(.horizontal)
                                Divider()
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.house == .commons ? "House of Commons" : "House of Lords")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Picker("House", selection: $viewModel.house) {
                        Label("House of Commons", image: "commons").tag(House.commons)
                        Label("House of Lords", image: "lords").tag(House.lords)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
