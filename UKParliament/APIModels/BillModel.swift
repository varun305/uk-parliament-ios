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
    private var stagesTotalResults: Int = .max
    private var totalResults: Int = .max

    public static var shared = BillModel()
    private init() {}

    public var billPublicationFilterCache = [BillPublicationsFilterKey: Set<String>]()

    public func fetchBillPublications(for id: Int, _ completion: @escaping (BillPublicationResultModel?) -> Void) {
        let url = constructBillPublicationsUrl(for: id)
        FetchModel.base.fetchData(BillPublicationResultModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillPublicationsUrl(for id: Int) -> URL {
        URL(string: "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Publications")!
    }

    public func fetchBillStagePublications(for id: Int, stageId: Int, _ completion: @escaping (BillStagePublicationResultModel?) -> Void) {
        let url = constructBillStagePublicationsUrl(for: id, stageId: stageId)
        FetchModel.base.fetchData(BillStagePublicationResultModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillStagePublicationsUrl(for id: Int, stageId: Int) -> URL {
        URL(string: "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Stages/\(stageId)/Publications")!
    }

    public func canGetNextStagesData(for id: Int, reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        let url = constructBillStagesUrl(for: id)
        return FetchModel.base.canGetNextData(from: url, totalResults: stagesTotalResults)
    }

    public func fetchBillStages(for id: Int, reset: Bool = false, _ completion: @escaping (StageResultModel?) -> Void) {
        let url = constructBillStagesUrl(for: id)
        FetchModel.base.fetchDataSkipTake(StageResultModel.self, from: url, reset: reset) { result in
            if let result = result {
                self.stagesTotalResults = result.totalResults ?? 0
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private func constructBillStagesUrl(for id: Int) -> URL {
        let components = URLComponents(string: "https://bills-api.parliament.uk/api/v1/Bills/\(id)/Stages")!
        return components.url!
    }

    public func fetchBill(for id: Int, _ completion: @escaping (Bill?) -> Void) {
        let url = constructBillUrl(for: id)
        FetchModel.base.fetchData(Bill.self, from: url) { result in
            completion(result)
        }
    }

    private func constructBillUrl(for id: Int) -> URL {
        URL(string: "https://bills-api.parliament.uk/api/v1/Bills/\(id)")!
    }

    public func canGetNextData(search: String = "", memberId: Int? = nil, reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        let url = constructBillsUrl(search: search, memberId: memberId)
        return FetchModel.base.canGetNextData(from: url, totalResults: totalResults)
    }

    public func nextData(search: String = "", memberId: Int? = nil, reset: Bool = false, _ completion: @escaping (BillItemModel?) -> Void) {
        let url = constructBillsUrl(search: search, memberId: memberId)
        FetchModel.base.fetchDataSkipTake(BillItemModel.self, from: url, reset: reset) { result in
            if let result = result {
                self.totalResults = result.totalResults ?? 0
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private let billsUrl = "https://bills-api.parliament.uk/api/v1/Bills"
    private func constructBillsUrl(search: String, memberId: Int?) -> URL {
        var components = URLComponents(string: billsUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "SearchTerm", value: search))
        }
        if let memberId = memberId {
            queryItems.append(URLQueryItem(name: "MemberId", value: String(memberId)))
        }
        queryItems += [
            URLQueryItem(name: "SortOrder", value: "DateUpdatedDescending")
        ]
        components.queryItems = queryItems
        return components.url!
    }
}

public struct BillPublicationsFilterKey: Hashable {
    var billId: Int
    var stageId: Int?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(billId)
        hasher.combine(stageId)
    }
}
