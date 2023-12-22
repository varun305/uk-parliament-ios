import SwiftUI

struct ConstituencyDetailView: View {
    var constituency: Constituency
    @StateObject var viewModel = ConstituencyDetailViewModel()

    var body: some View {
        List {
            Section("Current MP") {
                memberTile
            }

            Section("Past election results") {
                resultsView
            }
        }
        .navigationTitle(constituency.name)
        .onAppear {
            viewModel.fetchData(for: constituency)
        }
    }

    @ViewBuilder
    var memberTile: some View {
        NavigationLink {
            MemberDetailView(member: constituency.member)
        } label: {
            HStack {
                Text(constituency.member.nameDisplayAs)
                    .bold()
                Spacer()
                MemberPictureView(member: constituency.member)
                    .frame(width: 30, height: 30)
            }
        }
    }

    @ViewBuilder
    var resultsView: some View {
        ForEach(viewModel.electionResults) { result in
            HStack {
                Text(convertDate(from: result.electionDate))
                    .lineLimit(1)
                    .font(.callout)

                Spacer()

                Text(result.result.uppercased())
                    .bold()
                    .foregroundStyle(Color(hexString: result.winningParty.foregroundColour ?? "000000"))
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color(hexString: result.winningParty.backgroundColour ?? "ffffff"))
                    }
            }
        }
    }

    private func convertDate(from date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}
