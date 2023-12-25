import SwiftUI

struct BillPublicationsView: View {
    @StateObject var viewModel = BillPublicationsViewModel()
    var bill: Bill
    var stage: Stage?

    private var navigationTitle: String {
        "Publications, \(bill.shortTitle)"
    }

    var body: some View {
        Group {
            if viewModel.publications.count > 0 {
                List {
                    Section("\(viewModel.publications.count) results") {
                        ForEach(viewModel.publications) { publication in
                            if publication.links.count > 0 {
                                NavigationLink {
                                    BillPublicationLinksView(links: publication.links)
                                        .navigationTitle("Links, \(publication.title)")
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    BillPublicationRow(publication: publication)
                                }
                            } else {
                                BillPublicationRow(publication: publication)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            } else if viewModel.loading {
                ProgressView()
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchPublications(for: bill.billId, stageId: stage?.id)
        }
    }
}
