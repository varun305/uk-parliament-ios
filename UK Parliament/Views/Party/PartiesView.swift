import SwiftUI

struct PartiesView: View {
    @StateObject var viewModel = PartiesViewModel()

    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                scrollView
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
        .onAppear {
            viewModel.fetchData()
        }
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.parties) { party in
                    if let _party = party.party {
                        Text("\(_party.name ?? "") (\(party.total ?? 0) members)")
                            .font(.footnote)
                            .bold()
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 10))], spacing: 5) {
                            ForEach(0..<(party.total ?? 0), id: \.self) { _ in
                                if let color = _party.backgroundColour, color != "ffffff" {
                                    Color(hexString: _party.backgroundColour ?? "ffffff")
                                        .mask {
                                            RoundedRectangle(cornerRadius: 2)
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(.black, lineWidth: 1)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .padding(.bottom)
                    } else {
                        EmptyView()
                    }
                }
            }
            .padding(.top)
            .padding(.horizontal)
        }
    }
}
