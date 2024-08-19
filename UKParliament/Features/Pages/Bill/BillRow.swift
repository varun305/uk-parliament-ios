import SwiftUI
import SkeletonUI

struct BillRow: View {
    var bill: Bill

    var originatingHouse: House? {
        if bill.originatingHouse == "Commons" {
            House.commons
        } else if bill.originatingHouse == "Lords" {
            House.lords
        } else {
            nil
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            if let currentStage = bill.currentStage {
                BillStageBadge(stage: currentStage)
                    .frame(width: 60, height: 60)
            }
            VStack(alignment: .leading) {
                Text(bill.shortTitle ?? "")
                    .bold()
                caption
            }
            .multilineTextAlignment(.leading)
        }
    }

    @ViewBuilder
    var caption: some View {
        let date = bill.formattedDate
        if let house = originatingHouse {
            Text(date + " • From \(house)")
                .accessibilityLabel(Text(date + ", From \(house)"))
                .foregroundStyle(.secondary)
                .font(.footnote)
        } else {
            Text(date)
                .foregroundStyle(.secondary)
                .font(.footnote)
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
    NavigationStack {
        List {
            BillRow(bill: Mocks.mockBill)
        }
        .navigationTitle("Hello world")
    }
}
