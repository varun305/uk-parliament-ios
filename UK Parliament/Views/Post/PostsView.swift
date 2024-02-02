import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsViewModel()
    @State var side = Side.government

    var body: some View {
        List {
            Picker("Side", selection: $side.animation()) {
                Text("Government").tag(Side.government)
                Text("Opposition").tag(Side.opposition)
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)

            ForEach(side == .government ? viewModel.governmentPosts : viewModel.oppositionPosts) { post in
                Section(post.hansardName ?? "") {
                    ForEach(post.postHolders ?? []) { holder in
                        if let memberId = holder.member?.id, let member = holder.member?.value {
                            ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                                MemberRow(member: member)
                            }
                        } else if let member = holder.member?.value {
                            MemberRow(member: member)
                        } else {
                            EmptyView()
                        }
                        HStack {
                            Text("from \(holder.formattedStartDate)")
                        }
                        .font(.footnote)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle(side == .government ? "Government posts" : "Opposition posts")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getPosts(side: .government)
            viewModel.getPosts(side: .opposition)
        }
    }
}

enum Side {
    case government, opposition
}
