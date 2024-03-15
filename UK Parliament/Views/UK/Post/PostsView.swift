import SwiftUI

struct PostsView: View {
    @StateObject var viewModel = PostsViewModel()
    @State var side = Side.government

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 20) {
                Picker("Side", selection: $side.animation()) {
                    Text("Government").tag(Side.government)
                    Text("Opposition").tag(Side.opposition)
                }
                .pickerStyle(.segmented)

                ForEach(side == .government ? viewModel.governmentPosts : viewModel.oppositionPosts) { post in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(post.hansardName ?? "")
                            .padding(.leading, 10)
                            .font(.callout)
                            .bold()
                        ForEach(post.postHolders ?? []) { holder in
                            if let member = holder.member?.value {
                                MemberRow(member: member)
                                    .ifLet(member.id) { view, memberId in
                                        ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) { view }
                                    }
                                    .foregroundStyle(.primary)
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .padding()
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
