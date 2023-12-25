import SwiftUI

struct BillsView: View {
    @StateObject var viewModel = BillsViewModel()
    @State var scrollItem: Bill.ID?
    var member: Member?

    var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var navTitle: String {
        if let member = member {
            "Bills, \(member.nameDisplayAs)"
        } else {
            "Bills"
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.bills) { bill in
                    ContextAwareNavigationLink(value: .billDetailView(bill: bill), addChevron: true) {
                        BillRow(bill: bill)
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.primary)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search bills")
        .onSubmit(of: .search) {
            viewModel.nextData(memberId: member?.id, reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(memberId: member?.id, reset: true)
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { _, new in
            if new == viewModel.bills.last?.id {
                viewModel.nextData(memberId: member?.id)
            }
        }
        .onAppear {
            if viewModel.bills.isEmpty {
                viewModel.nextData(memberId: member?.id, reset: true)
            }
        }
    }
}
