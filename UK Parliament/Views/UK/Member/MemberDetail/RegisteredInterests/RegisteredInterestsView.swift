import SwiftUI
import SkeletonUI

struct RegisteredInterestsView: View {
    @StateObject var viewModel = RegisteredInterestsViewModel()
    var member: Member

    var body: some View {
        Group {
            if !viewModel.registeredInterests.isEmpty {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .navigationTitle("Registered Interests, \(member.nameDisplayAs ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let memberId = member.id {
                viewModel.fetchData(for: memberId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            ForEach(0..<5) { _ in
                Section("") {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
            }
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            ForEach(viewModel.registeredInterests.sorted { $0.sortOrder ?? 0 < $1.sortOrder ?? 0 }) { registeredInterest in
                Section(registeredInterest.name ?? "") {
                    ForEach(registeredInterest.interests ?? []) { interest in
                        InterestRow(interest: interest)
                    }
                }
            }
        }
        .listStyle(.grouped)
    }

    struct InterestRow: View {
        var interest: Interest

        var body: some View {
            VStack(alignment: .leading) {
                Text(interest.interest ?? "")
            }
            .font(.footnote)
        }
    }
}
