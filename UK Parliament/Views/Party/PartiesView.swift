import SwiftUI

struct PartiesView: View {
    @StateObject var viewModel = PartiesViewModel()

    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.parties) { party in
                            Text("\(party.party.name) (\(party.total) members)")
                                .font(.footnote)
                                .bold()
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 10))], spacing: 5) {
                                ForEach(0..<party.total, id: \.self) { _ in
                                    if let color = party.party.backgroundColour, color != "ffffff" {
                                        Color(hexString: party.party.backgroundColour ?? "ffffff")
                                            .mask {
                                                RoundedRectangle(cornerRadius: 2)
                                            }
                                            .opacity(0.6)
                                    } else {
                                        RoundedRectangle(cornerRadius: 2)
                                            .stroke(.black, lineWidth: 1)
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
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
        .onAppear {
            viewModel.fetchData()
        }
    }
}
