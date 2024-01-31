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

            ForEach(side == .government ? viewModel.governmentPosts : viewModel.oppositionPosts) { post in
                Section(post.hansardName) {
                    ForEach(post.postHolders) { holder in
                        ContextAwareNavigationLink(value: .memberDetailView(memberId: holder.member.id)) {
                            MemberRow(member: holder.member.value)
                        }
                        HStack {
                            Text("from \(holder.startDate.convertToDate())")
                            if holder.isPaid {
                                Spacer()
                                Text("Paid role")
                            }
                        }
                        .font(.footnote)
                    }
                }
            }
        }
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
