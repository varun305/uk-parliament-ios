import SwiftUI
import SafariServices

struct BillPublicationsView: View {
    @StateObject var viewModel: BillPublicationsViewModel
    var bill: Bill
    var stage: Stage?

    init(bill: Bill, stage: Stage? = nil) {
        self.bill = bill
        self.stage = stage
        self._viewModel = StateObject(wrappedValue: BillPublicationsViewModel(billId: bill.billId, stageId: stage?.id))
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
            Menu {
                Button {
                    withAnimation(.interactiveSpring) {
                        viewModel.sortOrderAscending = true
                    }
                } label: {
                    Label("Oldest first", systemImage: viewModel.sortOrderAscending ? "checkmark" : "")
                }
                Button {
                    withAnimation(.interactiveSpring) {
                        viewModel.sortOrderAscending = false
                    }
                } label: {
                    Label("Newest first", systemImage: viewModel.sortOrderAscending ? "" : "checkmark")
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            .foregroundStyle(.primary)
        }
        .task {
            viewModel.fetchPublications()
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<8) { _ in
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
                if viewModel.publications.count > 1 {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Filter by type")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        ScrollView(.horizontal) {
                            HStack(alignment: .center) {
                                ForEach(viewModel.allPublicationTypes.sorted { $0 < $1 }) { type in
                                    FilterCapsule(
                                        text: type,
                                        isSelected: viewModel.typeFilters.contains(type)
                                    ) {
                                        withAnimation {
                                            if viewModel.typeFilters.contains(type) {
                                                viewModel.typeFilters.remove(type)
                                            } else {
                                                viewModel.typeFilters.insert(type)
                                            }
                                        }
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel(Text("Filter by \(type)"))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.bottom, 20)
                }

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

                if viewModel.filteredPublications.isEmpty {
                    ContentUnavailableView {
                        Label("No results", systemImage: "doc.text.magnifyingglass")
                    } description: {
                        Text("No publications match your current search or filters.")
                    } actions: {
                        if !viewModel.typeFilters.isEmpty || !viewModel.search.isEmpty {
                            Button("Clear all") {
                                withAnimation {
                                    viewModel.typeFilters.removeAll()
                                    viewModel.search = ""
                                }
                            }
                        }
                    }
                    .padding(.top, 40)
                } else {
                    LazyVStack(alignment: .leading) {
                        Divider()
                        ForEach(viewModel.filteredPublications) { publication in
                            billPulicationRow(publication)
                                .foregroundStyle(.primary)
                            Divider()
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .fullScreenCover(item: $linkItem) { link in
            WebView(url: URL(string: link)!)
                .ignoresSafeArea()
        }
    }

    @State var linkItem: String?

    @ViewBuilder
    func billPulicationRow(_ publication: BillPublication) -> some View {
        BillPublicationRow(publication: publication, linkItem: $linkItem)
            .padding(.horizontal)
    }
}

private struct FilterCapsule: View {
    var text: String
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .ifElse(isSelected, trueTransform: { $0.fill(Color.accentColor) }, falseTransform: { $0.stroke(.primary, lineWidth: 3) })
                Text(text)
                    .ifElse(isSelected, trueTransform: { $0.foregroundStyle(Color.white) }, falseTransform: { $0 })
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
