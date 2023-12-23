import SwiftUI

struct RegisteredInterestsView: View {
    @StateObject var viewModel = RegisteredInterestsViewModel()
    var member: Member

    var body: some View {
        List {
            ForEach(viewModel.registeredInterests) { registeredInterest in
                Section(registeredInterest.name) {
                    ForEach(registeredInterest.interests) { interest in
                        InterestRow(interest: interest)
                    }
                }
            }
        }
        .navigationTitle("Registered Interests: \(member.nameDisplayAs)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchData(for: member.id)
        }
    }

    struct InterestRow: View {
        var interest: Interest

        var body: some View {
            VStack(alignment: .leading) {
                Text(interest.interest)
                VStack {
                    if let createdWhen = interest.createdWhen, createdWhen != "" {
                        HStack {
                            Text("Created")
                            Spacer()
                            Text(convertDate(from: createdWhen))
                        }
                    }
                    if let lastAmendedWhen = interest.lastAmendedWhen, lastAmendedWhen != "" {
                        HStack {
                            Text("Amended")
                            Spacer()
                            Text(convertDate(from: lastAmendedWhen))
                        }
                    }
                    if let deletedWhen = interest.deletedWhen, deletedWhen != "" {
                        HStack {
                            Text("Created")
                            Spacer()
                            Text(convertDate(from: deletedWhen))
                        }
                    }
                }
                .italic()
            }
            .font(.footnote)
        }

        private func convertDate(from date: String) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? dateFormatter2.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
        }
    }
}
