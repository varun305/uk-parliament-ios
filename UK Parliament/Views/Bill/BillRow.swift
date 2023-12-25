import SwiftUI

struct BillRow: View {
    var bill: Bill

    var body: some View {
        HStack {
            BillStageBadge(stage: bill.currentStage)
                .frame(width: 60, height: 60)
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
                Spacer()
                HStack {
                    Text(bill.lastUpdate.convertToDate())
                    Spacer()
                    Group {
                        if bill.originatingHouse == "Commons" {
                            Text("From House of Commons")
                        } else if bill.originatingHouse == "Lords" {
                            Text("From House of Lords")
                        }
                    }
                    .italic()
                }
                .foregroundStyle(.secondary)
                .font(.footnote)
            }
            .padding(.top, 3)
            .multilineTextAlignment(.leading)
        }
    }
}
