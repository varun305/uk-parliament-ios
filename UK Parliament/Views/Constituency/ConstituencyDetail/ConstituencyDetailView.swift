import SwiftUI

struct ConstituencyDetailView: View {
    var constituency: Constituency
    
    var body: some View {
        Text(constituency.name)
    }
}
