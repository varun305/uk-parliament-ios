import SwiftUI

struct MembersView: View {
    @StateObject var viewModel = MembersViewModel()
    @State var scrollItem: Member.ID?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Divider()
                ForEach(viewModel.members) { member in
                    MemberRow(member: member)
                        .padding(.horizontal)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .navigationTitle(viewModel.house == .commons ? "MPs" : "Lords")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker("House", selection: $viewModel.house) {
                    Label("House of Commons", image: "commons").tag(House.commons)
                    Label("House of Lords", image: "lords").tag(House.lords)
                }
            }
        }
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { old, new in
            if new == viewModel.members.last?.id {
                viewModel.nextData()
            }
        }
        .onAppear {
            if viewModel.members.isEmpty {
                viewModel.nextData()
            }
        }
    }
}
