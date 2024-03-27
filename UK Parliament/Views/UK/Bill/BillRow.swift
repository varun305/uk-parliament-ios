import SwiftUI
import SkeletonUI

struct BillRow: View {
    var bill: Bill

    var body: some View {
        HStack(alignment: .center) {
            if let currentStage = bill.currentStage {
                BillStageBadge(stage: currentStage)
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading) {
                Text(bill.shortTitle ?? "")
                    .bold()
                Group {
                    Text(bill.formattedDate)
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
            .multilineTextAlignment(.leading)
        }
    }
}

struct BillRowLoading: View {
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 3)
                    .skeleton(with: true)
                Circle()
                    .fill(.white)
                    .padding(5)
                    .skeleton(with: true)
                Text("2")
                    .skeleton(with: true)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                HStack {
                    Text("")
                        .skeleton(with: true)
                    Spacer()
                }
                HStack {
                    Text("")
                        .frame(width: 50)
                        .skeleton(with: true)
                    Spacer()
                    Text("")
                        .frame(width: 50)
                        .skeleton(with: true)
                }
            }
        }
        .frame(height: 60)
    }
}

#Preview {
    BillRow(bill: Mocks.mockBill)
}
