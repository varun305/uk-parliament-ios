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
                            if publication.links.count + publication.files.count > 0 {
                                ContextAwareNavigationLink(value: .billPublicationLinksView(publication: publication)) {
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
