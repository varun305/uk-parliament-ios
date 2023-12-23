import Foundation


class PostHolderMemberModel: Codable, Identifiable {
    var member: MemberValueModel
    var startDate: String
    var endDate: String?
    var layingMinisterName: String?
    var isPaid: Bool

    var id: Int {
        member.id
    }
}

class Department: Codable, Identifiable {
    var id: Int
    var name: String
    var url: String?
    var imageUrl: String
}

class Post: Codable, Identifiable {
    var type: Int
    var name: String
    var hansardName: String
    var id: Int
    var postHolders: [PostHolderMemberModel]
    var governmentDepartments: [Department]
}

class PostResultModel: Codable {
    var value: Post
}

class PostModel {
    public static var shared = PostModel()
    private init() {}

    public func getPosts(side: Side, _ completion: @escaping ([PostResultModel]?) -> Void) {
        let url = side == .government ? constructGovernmentPostsUrl() : constructOppositionPostsUrl()
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([PostResultModel].self, from: data)
                    completion(result)
                } catch let error {
                    print(error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    private func constructGovernmentPostsUrl() -> String {
        "https://members-api.parliament.uk/api/Posts/GovernmentPosts"
    }

    private func constructOppositionPostsUrl() -> String {
        "https://members-api.parliament.uk/api/Posts/OppositionPosts"
    }
}
