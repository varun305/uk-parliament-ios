import Foundation

enum NavigationItem: Hashable, Codable {
    case _404
    case partiesView
    case membersView
    case memberDetailView(memberId: Int)
    case memberContactView(member: Member)
    case memberInterestsView(member: Member)
    case constituenciesView
    case constituencyDetailView(constituency: Constituency)
    case constituencyElectionDetailView(constituency: Constituency, election: ElectionResult)
    case postsView
    case billsView(member: Member?)
    case billDetailView(bill: Bill)
    case billStagesView(bill: Bill)
    case billPublicationsView(bill: Bill, stage: Stage?)
    case billPublicationLinksView(publication: BillPublication)
    case commonsVotesView
    case commonsVoteDetailView(vote: CommonsVote)
    case memberCommonsVotesView(member: Member)

    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        switch (lhs, rhs) {
        case (._404, ._404),
            (.partiesView, .partiesView),
            (.membersView, .membersView),
            (.constituenciesView, .constituenciesView),
            (.postsView, .postsView),
            (.commonsVotesView, .commonsVotesView):
            return true
        case let (.memberDetailView(member1), .memberDetailView(member2)):
            return member1 == member2
        case let (.memberContactView(member1), .memberContactView(member2)),
            let (.memberInterestsView(member1), .memberInterestsView(member2)):
            return member1 == member2
        case let (.constituencyDetailView(constituency1), .constituencyDetailView(constituency2)):
            return constituency1 == constituency2
        case let (.constituencyElectionDetailView(constituency1, election1), .constituencyElectionDetailView(constituency2, election2)):
            return constituency1 == constituency2 && election1 == election2
        case let (.billsView(member1), .billsView(member2)):
            return member1 == member2
        case let (.billDetailView(bill1), .billDetailView(bill2)):
            return bill1 == bill2
        case let (.billStagesView(bill1), .billStagesView(bill2)):
            return bill1 == bill2
        case let (.billPublicationsView(bill1, stage1), .billPublicationsView(bill2, stage2)):
            return bill1 == bill2 && stage1 == stage2
        case let (.billPublicationLinksView(publication1), .billPublicationLinksView(publication2)):
            return publication1 == publication2
        case let (.commonsVoteDetailView(vote1), .commonsVoteDetailView(vote2)):
            return vote1 == vote2
        case let (.memberCommonsVotesView(member1), .memberCommonsVotesView(member2)):
            return member1 == member2
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        switch self {
        case ._404:
            hasher.combine(-1)
        case .partiesView:
            hasher.combine(0)
        case .membersView:
            hasher.combine(1)
        case .memberDetailView(let member):
            hasher.combine(2)
            hasher.combine(member) // Ensure Member is also Hashable
        case .memberContactView(let member):
            hasher.combine(3)
            hasher.combine(member)
        case .memberInterestsView(let member):
            hasher.combine(4)
            hasher.combine(member)
        case .constituenciesView:
            hasher.combine(5)
        case .constituencyDetailView(let constituency):
            hasher.combine(6)
            hasher.combine(constituency)
        case .constituencyElectionDetailView(let constituency, let election):
            hasher.combine(7)
            hasher.combine(constituency)
            hasher.combine(election)
        case .postsView:
            hasher.combine(8)
        case .billsView(let member):
            hasher.combine(9)
            hasher.combine(member)
        case .billDetailView(let bill):
            hasher.combine(10)
            hasher.combine(bill)
        case .billStagesView(let bill):
            hasher.combine(11)
            hasher.combine(bill)
        case .billPublicationsView(let bill, let stage):
            hasher.combine(12)
            hasher.combine(bill)
            hasher.combine(stage)
        case .billPublicationLinksView(let publication):
            hasher.combine(13)
            hasher.combine(publication)
        case .commonsVotesView:
            hasher.combine(14)
        case .commonsVoteDetailView(let vote):
            hasher.combine(15)
            hasher.combine(vote)
        case .memberCommonsVotesView(let member):
            hasher.combine(16)
            hasher.combine(member)
        }
    }
}

