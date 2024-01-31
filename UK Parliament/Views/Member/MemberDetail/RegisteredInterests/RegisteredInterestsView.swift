import SwiftUI

struct RegisteredInterestsView: View {
    @StateObject var viewModel = RegisteredInterestsViewModel()
    var member: Member

    var body: some View {
        Group {
            if !viewModel.registeredInterests.isEmpty {
                List {
                    ForEach(viewModel.registeredInterests.sorted { $0.sortOrder ?? 0 < $1.sortOrder ?? 0 }) { registeredInterest in
                        Section(registeredInterest.name ?? "") {
                            ForEach(registeredInterest.interests ?? []) { interest in
                                InterestRow(interest: interest)
                            }
                        }
                    }
                }
            } else if viewModel.loading {
                ProgressView()
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle("Registered Interests, \(member.nameDisplayAs ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let memberId = member.id {
                viewModel.fetchData(for: memberId)
            }
        }
    }

    struct InterestRow: View {
        var interest: Interest

        var body: some View {
            VStack(alignment: .leading) {
                Text(interest.interest ?? "")
                VStack {
                    if let createdWhen = interest.createdWhen, createdWhen != "" {
                        HStack {
                            Text("Created")
                            Spacer()
                            Text(createdWhen.convertToDate())
                        }
                    }
                    if let lastAmendedWhen = interest.lastAmendedWhen, lastAmendedWhen != "" {
                        HStack {
                            Text("Amended")
                            Spacer()
                            Text(lastAmendedWhen.convertToDate())
                        }
                    }
                    if let deletedWhen = interest.deletedWhen, deletedWhen != "" {
                        HStack {
                            Text("Created")
                            Spacer()
                            Text(deletedWhen.convertToDate())
                        }
                    }
                }
                .italic()
            }
            .font(.footnote)
        }
    }
}
