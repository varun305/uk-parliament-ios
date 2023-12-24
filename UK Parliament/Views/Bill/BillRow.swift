import SwiftUI

struct BillRow: View {
    var bill: Bill

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(bill.shortTitle)
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
                Text(bill.lastUpdate.convertToDate())
                    .font(.footnote)
                Spacer()

                BillStageBadge(stage: bill.currentStage)
                Group {
                    if bill.originatingHouse == "Commons" {
                        CommonsBadge()
                    } else if bill.originatingHouse == "Lords" {
                        LordsBadge()
                    }
                }
            }
        }
        .multilineTextAlignment(.leading)
    }
}
