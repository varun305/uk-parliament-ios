import Foundation
import SwiftUI

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

    public func htmlToMarkdown() -> LocalizedStringKey {
        var text = self

        text = text.replacing("<div>", with: "\n")
        text = text.replacing("</div>", with: "")
        text = text.replacing("<p>", with: "\n")
        text = text.replacing("</p>", with: "")
        text = text.replacing("<br>", with: "\n")

        text = text.replacing("<strong>", with: "**")
        text = text.replacing("</strong>", with: "**")
        text = text.replacing("<b>", with: "**")
        text = text.replacing("</b>", with: "**")
        text = text.replacing("<em>", with: "*")
        text = text.replacing("</em>", with: "*")
        text = text.replacing("<i>", with: "*")
        text = text.replacing("</i>", with: "*")

        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print(text)

        return LocalizedStringKey(text)
    }
}
