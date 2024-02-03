import XCTest
@testable import UK_Parliament

final class UtilsModelTests: XCTestCase {
    func testConstructURLHashable() throws {
        var components = URLComponents(string: "https://members-api.parliament.uk/api/Members/Search")!
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "Name", value: "Rishi"))
        queryItems += [
            URLQueryItem(name: "House", value: "1"),
            URLQueryItem(name: "IsEligible", value: "true")
        ]
        components.queryItems = queryItems

        let hashable = UtilsModel.constructURLHashable(from: components.url!)
        XCTAssertEqual(hashable, Set(["members-api.parliament.uk", "/api/Members/Search", "Name=Rishi", "House=1", "IsEligible=true"]))
    }

    func testAddURLQueries() throws {
        var components = URLComponents(string: "https://members-api.parliament.uk/api/Members/Search")!
        var queryItems = [URLQueryItem]()
        queryItems += [
            URLQueryItem(name: "House", value: "1"),
            URLQueryItem(name: "IsEligible", value: "true")
        ]
        components.queryItems = queryItems

        let added = UtilsModel.addURLQueries(to: components.url!, queries: [URLQueryItem(name: "Name", value: "Rishi")])
        queryItems.append(URLQueryItem(name: "Name", value: "Rishi"))
        components.queryItems = queryItems

        let v1 = UtilsModel.constructURLHashable(from: added)
        let v2 = UtilsModel.constructURLHashable(from: components.url!)

        XCTAssertEqual(v1, v2)
    }
}
