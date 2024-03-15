import SwiftUI
import SkeletonUI

struct BillRow: View {
    var bill: Bill

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center) {
            if let currentStage = bill.currentStage {
                BillStageBadge(stage: currentStage)
                    .frame(width: 60, height: 60)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(bill.shortTitle ?? "")
                        .bold()
                }
                Group {
                    Text(bill.formattedDate)
                    Group {
                        if bill.originatingHouse == "Commons" {
                            Text("From House of Commons")
                        } else if bill.originatingHouse == "Lords" {
                            Text("From House of Lords")
                        }
                    }
                }
                .font(.footnote)
            }
            .multilineTextAlignment(.leading)
            .accessibilityElement(children: .combine)
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .accessibilityHidden(true)
        }
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
    }
}

struct BillRowLoading: View {
    @Environment(\.colorScheme) var colorScheme

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
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("")
                        .skeleton(with: true)
                }
                Group {
                    Text("")
                        .skeleton(with: true)
                    Text("")
                        .skeleton(with: true)
                }
                .font(.footnote)
            }
            .multilineTextAlignment(.leading)
            .accessibilityElement(children: .combine)
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .accessibilityHidden(true)
        }
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
        .frame(height: 90)
    }
}

#Preview {
    BillRow(bill: Mocks.mockBill)
}
