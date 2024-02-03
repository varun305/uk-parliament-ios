import Foundation

@MainActor class PostsViewModel: ObservableObject {
    @Published var governmentPosts: [Post] = []
    @Published var oppositionPosts: [Post] = []

    public func getPosts(side: Side) {
        PostModel.shared.getPosts(side: side) { posts in
            if let posts = posts {
                Task { @MainActor in
                    if side == .government {
                        self.governmentPosts = posts.compactMap { $0.value }
                    } else {
                        self.oppositionPosts = posts.compactMap { $0.value }
                    }
                }
            }
        }
    }
}

