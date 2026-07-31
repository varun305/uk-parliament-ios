import SwiftUI
import SkeletonUI

struct PostsView: View {
    @StateObject var viewModel = PostsViewModel()
    @State var side = Side.government

    var activePosts: [Post] {
        side == .government ? viewModel.governmentPosts : viewModel.oppositionPosts
    }

    struct MemberPostEntry: Identifiable {
        var member: Member
        var memberId: Int
        var posts: [(post: Post, holder: PostHolderMemberModel)]
        var id: Int { memberId }
    }

    var coalescedEntries: [MemberPostEntry] {
        var map: [Int: MemberPostEntry] = [:]
        var order: [Int] = []
        for post in activePosts {
            for holder in post.postHolders ?? [] {
                guard let memberId = holder.member?.id,
                      let member = holder.member?.value else { continue }
                if map[memberId] == nil {
                    map[memberId] = MemberPostEntry(member: member, memberId: memberId, posts: [])
                    order.append(memberId)
                }
                map[memberId]?.posts.append((post: post, holder: holder))
            }
        }
        return order.compactMap { map[$0] }
    }

    var body: some View {
        Group {
            if viewModel.loading {
                LoadingView()
            } else {
                scrollView
            }
        }
        .navigationTitle(side == .government ? "Government posts" : "Opposition posts")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.getPosts(side: .government)
            viewModel.getPosts(side: .opposition)
        }
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("Side", selection: $side.animation()) {
                    Text("Government").tag(Side.government)
                    Text("Opposition").tag(Side.opposition)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                postsCard
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    @ViewBuilder
    var postsCard: some View {
        let entries = coalescedEntries
        if entries.isEmpty {
            NoDataView()
        } else {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(entries.indices, id: \.self) { index in
                    if index > 0 {
                        Divider().padding(.leading, 56)
                    }
                    memberRow(entries[index])
                }
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    func memberRow(_ entry: MemberPostEntry) -> some View {
        let content = HStack(spacing: 12) {
            MemberPictureView(member: entry.member)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 3) {
                Text(entry.member.nameDisplayAs ?? "")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                ForEach(entry.posts.indices, id: \.self) { i in
                    let item = entry.posts[i]
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.post.hansardName ?? "")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        if !item.holder.formattedStartDate.isEmpty {
                            Text("Since \(item.holder.formattedStartDate)")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.top, i == 0 ? 0 : 4)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)

        ContextAwareNavigationLink(value: .memberDetailView(memberId: entry.memberId)) {
            content
        }
        .foregroundStyle(.primary)
    }
}

enum Side {
    case government, opposition
}
