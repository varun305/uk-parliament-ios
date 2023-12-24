import SwiftUI

struct BillStageBadge: View {
    var stage: Stage

    var body: some View {
        Text(stage.abbreviation)
            .font(.footnote)
            .bold()
            .foregroundStyle(.white)
            .padding(2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(stage.house == "Commons" ? Color.commons : stage.house == "Lords" ? Color.lords : .accentColor)
            }
    }
}
