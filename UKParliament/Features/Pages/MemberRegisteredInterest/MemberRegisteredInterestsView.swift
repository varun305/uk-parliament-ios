import SwiftUI
import SkeletonUI

struct MemberRegisteredInterestsView: View {
    @StateObject var viewModel = MemberRegisteredInterestsViewModel()
    var member: Member

    /// Categories sorted by sortOrder, each with duplicate interest text removed.
    var sortedInterests: [RegisteredInterest] {
        viewModel.registeredInterests
            .sorted { $0.sortOrder ?? 0 < $1.sortOrder ?? 0 }
            .filter { !deduplicatedInterests(for: $0).isEmpty }
    }

    func deduplicatedInterests(for category: RegisteredInterest) -> [Interest] {
        var seen = Set<String>()
        return (category.interests ?? []).filter { interest in
            guard let text = interest.interest, !text.isEmpty else { return false }
            return seen.insert(text).inserted
        }
    }

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
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<4) { _ in
                    VStack(alignment: .leading, spacing: 0) {
                        Text("").skeleton(with: true).frame(width: 160, height: 14)
                            .padding(.horizontal)
                            .padding(.top, 14)
                            .padding(.bottom, 8)
                        Divider()
                        ForEach(0..<3) { i in
                            if i > 0 { Divider().padding(.leading) }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("").skeleton(with: true).frame(maxWidth: .infinity).frame(height: 11)
                                Text("").skeleton(with: true).frame(width: 200, height: 11)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                    }
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(sortedInterests) { category in
                    categoryCard(category)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    @ViewBuilder
    func categoryCard(_ category: RegisteredInterest) -> some View {
        let interests = deduplicatedInterests(for: category)
        VStack(alignment: .leading, spacing: 0) {
            Text(category.name ?? "")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Divider()

            ForEach(interests.indices, id: \.self) { index in
                if index > 0 {
                    Divider().padding(.leading)
                }
                interestRow(interests[index])
            }
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func interestRow(_ interest: Interest) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(interest.interest ?? "")
                .font(.footnote)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            if let date = interest.createdWhen, !date.convertToDate().isEmpty {
                Text("Registered \(date.convertToDate())")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
