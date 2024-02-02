import Foundation

extension String {
    public func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.components(separatedBy: ".").first ?? "")?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }

    public func convertToDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self.components(separatedBy: ".").first ?? "")?.formatted(date: .long, time: .shortened) ?? ""
    }

    public func searchContains(_ search: String) -> Bool {
        self.lowercased().contains(search.lowercased()) || search.isEmpty
    }
}
