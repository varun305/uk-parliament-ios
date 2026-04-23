import Foundation
import SwiftUI

class PostsViewModel: ObservableObject {
    @Published var governmentPosts: [Post] = []
    @Published var oppositionPosts: [Post] = []
    @Published var loading = false

    private var fetchedSides: Set<Int> = []

    public func getPosts(side: Side) {
        withAnimation { loading = true }
        PostModel.shared.getPosts(side: side) { posts in
            if let posts = posts {
                Task { @MainActor in
                    if side == .government {
                        self.governmentPosts = posts.compactMap { $0.value }
                    } else {
                        self.oppositionPosts = posts.compactMap { $0.value }
                    }
                    self.fetchedSides.insert(side == .government ? 0 : 1)
                    if self.fetchedSides.count >= 2 {
                        withAnimation { self.loading = false }
                    }
                }
            }
        }
    }
}
