import Foundation


class StageSitting: Codable, Identifiable {
    var id: Int
    var stageId: Int
    var billStageId: Int
    var billId: Int
    var date: String
}

class Stage: Codable, Identifiable {
    var id: Int
    var stageId: Int
    var sessionId: Int
    var description: String
    var abbreviation: String
    var house: String
    var stageSittings: [StageSitting]
    var sortOrder: Int
}

class BillMember: Codable, Identifiable {
    var memberId: Int
    var name: String
    var party: String
    var partyColour: String
    var house: String
    var memberPhoto: String
    var memberFrom: String

    var id: Int {
        memberId
    }
}

class BillOrganisation: Codable {
    var name: String
    var url: String
}

class Sponsor: Codable {
    var member: BillMember
    var organisation: BillOrganisation?
    var sortOrder: Int
}

class Bill: Codable, Identifiable {
    var billId: Int
    var shortTitle: String
    var longTitle: String?
    var currentHouse: String
    var originatingHouse: String
    var lastUpdate: String
    var billWithdrawn: String?
    var isDefeated: Bool
    var billTypeId: Int
    var introducedSessionId: Int
    var includedSessionIds: [Int]
    var isAct: Bool
    var currentStage: Stage
    var sponsors: [Sponsor]?

    var id: Int {
        billId
    }
}

class BillItemModel: Codable {
    var items: [Bill]
    var totalResults: Int
}


class BillModel {
    private var skip: [String?: Int] = [nil: 0]
    private let take = 20
    private var totalResults: Int = .max

    public static var shared = BillModel()
    private init() {}

    public func fetchBill(for id: Int, _ completion: @escaping (Bill?) -> Void) {
        let url = constructBillUrl(for: id)
        FetchModel.base.fetchData(Bill.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillUrl(for id: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills/\(id)"
    }

    public func nextData(search: String = "", reset: Bool = false, _ completion: @escaping (BillItemModel?) -> Void) {
        if reset {
            skip[search] = 0
        }

        let _skip = skip[search, default: 0]
        if _skip > totalResults {
            return
        }

        let url = search == "" ? constructBillsUrl(skip: _skip) : constructSearchBillsUrl(search: search, skip: _skip)
        FetchModel.base.fetchData(BillItemModel.self, from: url) { result in
            if let result = result {
                self.totalResults = result.totalResults
                self.skip = [search: self.skip[search, default: 0] + self.take]
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private func constructBillsUrl(skip: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills?SortOrder=DateUpdatedDescending&Skip=\(skip)&Take=20"
    }

    private func constructSearchBillsUrl(search: String, skip: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills?SearchTerm=\(search)&SortOrder=DateUpdatedDescending&Skip=\(skip)&Take=20"
    }
}
