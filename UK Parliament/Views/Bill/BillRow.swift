import SwiftUI

struct BillRow: View {
    var bill: Bill

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(bill.shortTitle)
                    .font(.caption)
                    .bold()
                Spacer()

                if bill.isDefeated {
                    Text("Defeated")
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .opacity(0.5)
                        .italic()
                }
            }
            HStack {
                Text(convertDate(from: bill.lastUpdate))
                    .font(.footnote)
                Spacer()

                if bill.currentHouse == "Commons" {
                    CommonsBadge()
                } else {
                    LordsBadge()
                }
            }
        }
    }

    private func convertDate(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date.components(separatedBy: ".").first ?? "")?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}
