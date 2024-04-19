import SwiftUI

struct BillPublicationsView: View {
    @StateObject var viewModel: BillPublicationsViewModel
    var bill: Bill
    var stage: Stage?

    init(bill: Bill, stage: Stage? = nil) {
        self.bill = bill
        self.stage = stage
        self._viewModel = StateObject(wrappedValue: BillPublicationsViewModel(billId: bill.billId, stageId: stage?.stageId))
    }

    private var navigationTitle: String {
        "Publications, \(bill.shortTitle ?? "")"
    }

    var body: some View {
        Group {
            if viewModel.publications.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search by publication title"))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                withAnimation(.interactiveSpring) {
                    viewModel.sortOrderAscending.toggle()
                }
            } label: {
                Image(systemName: "chevron.up.circle")
                    .rotationEffect(.degrees(viewModel.sortOrderAscending ? 0 : 180))
                    .accessibilityLabel(Text(viewModel.sortOrderAscending ? "Sort by descending date" : "Sort by ascending date"))
            }
            .foregroundStyle(.primary)
        }
        .onAppear {
            viewModel.fetchPublications()
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<30) { _ in
                    DummyNavigationLink {
                        BillPublicationRowLoading()
                    }
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 10) {
                    ScrollView(.horizontal) {
                        HStack(alignment: .center) {
                            ForEach(viewModel.allPublicationTypes.sorted { $0 < $1 }) { type in
                                FilterCapsule(text: type)
                                    .environmentObject(viewModel)
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel(Text("Filter by \(type)"))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.bottom, 20)

                HStack {
                    Text("\(viewModel.filteredPublications.count) results")
                    if !viewModel.typeFilters.isEmpty {
                        Spacer()
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.typeFilters.removeAll()
                            }
                        } label: {
                            Label("Clear filters", systemImage: "trash")
                        }
                    }
                }
                .padding(.horizontal)

                LazyVStack(alignment: .leading) {
                    Divider()
                    ForEach(viewModel.filteredPublications) { publication in
                        billPulicationRow(publication)
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    func billPulicationRow(_ publication: BillPublication) -> some View {
        let links = publication.links ?? []
        let files = publication.files ?? []
        BillPublicationRow(publication: publication)
            .frame(maxWidth: .infinity)
            .if(!links.isEmpty || !files.isEmpty) { view in
                ContextAwareNavigationLink(value: .billPublicationLinksView(publication: publication)) {
                    view
                }
            }
    }
}

private struct FilterCapsule: View {
    var text: String

    @EnvironmentObject var viewModel: BillPublicationsViewModel

    var body: some View {
        Button {
            withAnimation {
                if viewModel.typeFilters.contains(text) {
                    viewModel.typeFilters.remove(text)
                } else {
                    viewModel.typeFilters.insert(text)
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .ifElse(viewModel.typeFilters.contains(text), trueTransform: { $0.fill(Color.accentColor) }, falseTransform: { $0.stroke(.primary, lineWidth: 3) })
                Text(text)
                    .ifElse(viewModel.typeFilters.contains(text), trueTransform: { $0.foregroundStyle(Color.white) }, falseTransform: { $0 })
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
            }
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
        }
        .foregroundStyle(.primary)
    }
}
