import Foundation

class StageSitting: Codable, Identifiable {
    var id: Int?
    var stageId: Int?
    var billStageId: Int?
    var billId: Int?
    var date: String?

    var formattedDate: String {
        date?.convertToDate() ?? ""
    }
}

class Stage: Codable, Identifiable, Hashable {
    var id: Int?
    var stageId: Int?
    var sessionId: Int?
    var description: String?
    var abbreviation: String?
    var house: String?
    var stageSittings: [StageSitting]?
    var sortOrder: Int?

    static func == (lhs: Stage, rhs: Stage) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(stageId)
        hasher.combine(sessionId)
    }
}

class StageResultModel: Codable {
    var items: [Stage]?
    var totalResults: Int?
}

class BillMember: Codable, Identifiable {
    var memberId: Int?
    var name: String?
    var party: String?
    var partyColour: String?
    var house: String?
    var memberPhoto: String
    var memberFrom: String?

    var id: Int? {
        memberId
    }
}

class BillOrganisation: Codable {
    var name: String?
    var url: String?
}

class Sponsor: Codable, Identifiable {
    var member: BillMember?
    var organisation: BillOrganisation?
    var sortOrder: Int?

    var id: Int? {
        member?.memberId
    }
}

class Bill: Codable, Identifiable, Hashable {
    var billId: Int?
    var shortTitle: String?
    var longTitle: String?
    var currentHouse: String?
    var originatingHouse: String?
    var lastUpdate: String?
    var billWithdrawn: String?
    var isDefeated: Bool?
    var billTypeId: Int?
    var introducedSessionId: Int?
    var includedSessionIds: [Int]?
    var isAct: Bool?
    var currentStage: Stage?
    var sponsors: [Sponsor]?

    var id: Int? {
        billId
    }

    var formattedDate: String {
        lastUpdate?.convertToDate() ?? ""
    }

    static func == (lhs: Bill, rhs: Bill) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(shortTitle)
    }
}

class BillItemModel: Codable {
    var items: [Bill]?
    var totalResults: Int?
}

class BillPublicationType: Codable, Identifiable {
    var id: Int?
    var name: String?
    var description: String?
}

class BillPublicationLink: Codable, Identifiable, Hashable {
    var id: Int?
    var title: String?
    var url: String?
    var contentType: String?

    static func == (lhs: BillPublicationLink, rhs: BillPublicationLink) -> Bool {
        lhs.id == rhs.id && lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
    }
}

class BillPublicationFile: Codable, Identifiable, Hashable {
    var id: Int?
    var filename: String?
    var contentType: String?
    var contentLength: Int?

    static func == (lhs: BillPublicationFile, rhs: BillPublicationFile) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(filename)
    }
}

class BillPublication: Codable, Identifiable, Equatable, Hashable {
    var house: String?
    var id: Int?
    var title: String?
    var publicationType: BillPublicationType?
    var displayDate: String?
    var links: [BillPublicationLink]?
    var files: [BillPublicationFile]?

    var formattedDate: String {
        displayDate?.convertToDate() ?? ""
    }

    static func == (lhs: BillPublication, rhs: BillPublication) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

class BillPublicationResultModel: Codable {
    var billId: Int?
    var publications: [BillPublication]?
}

class BillStageSitting: Codable {
    var sittingId: Int?
    var publications: [BillPublication]?
}

class BillStagePublicationResultModel: Codable {
    var billStageId: Int?
    var publications: [BillPublication]?
    var sittings: [BillStageSitting]?
}

class BillModel {
    private var stagesSkip = 0
    private var stagesTotalResults: Int = .max

    private var skip: [String?: Int] = [nil: 0]
    private let take = 20
    private var totalResults: Int = .max

    public static var shared = BillModel()
    private init() {}

    public func fetchBillPublications(for id: Int, _ completion: @escaping (BillPublicationResultModel?) -> Void) {
        let url = constructBillPublicationsUrl(for: id)
        FetchModel.base.fetchData(BillPublicationResultModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillPublicationsUrl(for id: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Publications"
    }

    public func fetchBillStagePublications(for id: Int, stageId: Int, _ completion: @escaping (BillStagePublicationResultModel?) -> Void) {
        let url = constructBillStagePublicationsUrl(for: id, stageId: stageId)
        FetchModel.base.fetchData(BillStagePublicationResultModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillStagePublicationsUrl(for id: Int, stageId: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Stages/\(stageId)/Publications"
    }

    public func fetchBillStages(for id: Int, reset: Bool = false, _ completion: @escaping (StageResultModel?) -> Void) {
        if reset {
            stagesSkip = 0
        }

        if stagesSkip > stagesTotalResults {
            return
        }

        let url = constructBillStagesUrl(for: id, skip: stagesSkip)
        FetchModel.base.fetchData(StageResultModel.self, from: url) { result in
            if let result = result {
                self.stagesTotalResults = result.totalResults ?? 0
                self.stagesSkip += self.take
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private func constructBillStagesUrl(for id: Int, skip: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Stages?Skip=\(skip)&Take=20"
    }

    public func fetchBill(for id: Int, _ completion: @escaping (Bill?) -> Void) {
        let url = constructBillUrl(for: id)
        FetchModel.base.fetchData(Bill.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillUrl(for id: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills/\(id)"
    }

    public func canGetNextData(search: String = "", reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        return !(skip[search, default: 0] > totalResults)
    }

    public func nextData(search: String = "", memberId: Int? = nil, reset: Bool = false, _ completion: @escaping (BillItemModel?) -> Void) {
        if reset {
            skip[search] = 0
        }

        let _skip = skip[search, default: 0]
        if _skip > totalResults {
            return
        }

        let url: String
        if search != "", let memberId = memberId {
            url = constructSearchMemberBillsUrl(search: search, memberId: memberId, skip: _skip)
        } else if search != "" {
            url = constructSearchBillsUrl(search: search, skip: _skip)
        } else if let memberId = memberId {
            url = constructMemberBillsUrl(memberId: memberId, skip: _skip)
        } else {
            url = constructBillsUrl(skip: _skip)
        }
        
        FetchModel.base.fetchData(BillItemModel.self, from: url) { result in
            if let result = result {
                self.totalResults = result.totalResults ?? 0
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

    private func constructMemberBillsUrl(memberId: Int, skip: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills?MemberId=\(memberId)&SortOrder=DateUpdatedDescending&Skip=\(skip)&Take=20"
    }

    private func constructSearchMemberBillsUrl(search: String, memberId: Int, skip: Int) -> String {
        "https://bills-api.parliament.uk/api/v1/Bills?SearchTerm=\(search)&MemberId=\(memberId)&SortOrder=DateUpdatedDescending&Skip=\(skip)&Take=20"
    }
}
