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
                        NavigationLink {
                            MemberDetailView(memberId: holder.member.id)
                        } label: {
                            MemberRow(member: holder.member.value)
                        }
                        HStack {
                            Text("from \(convertDate(from: holder.startDate))")
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

    private func convertDate(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? dateFormatter2.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}

enum Side {
    case government, opposition
}
