import SwiftUI
import SkeletonUI

struct MemberDetailView: View {
    @StateObject var viewModel = MemberDetailViewModel()
    var memberId: Int

    var body: some View {
        Group {
            if viewModel.member != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .navigationTitle(viewModel.member?.nameDisplayAs ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchMember(for: memberId)
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            HStack {
                Spacer()
                VStack(alignment: .center) {
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
                    .frame(width: 120, height: 120)
                    Text("")
                        .skeleton(with: true)
                    Text("")
                        .skeleton(with: true)
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section {
                Text("").skeleton(with: true).frame(height: 10)
            }
            Section {
                NavigationLink { Text("") } label: {
                    Text("").skeleton(with: true).frame(height: 10)
                }
                .disabled(true)
                NavigationLink { Text("") } label: {
                    Text("").skeleton(with: true).frame(height: 10)
                }
                .disabled(true)
            }
            Section {
                NavigationLink { Text("") } label: {
                    Text("").skeleton(with: true).frame(height: 10)
                }
                .disabled(true)
                NavigationLink { Text("") } label: {
                    Text("").skeleton(with: true).frame(height: 10)
                }
                .disabled(true)
            }
        }
        .environment(\.isScrollEnabled, false)
    }

    var houseColor: Color {
        if let member = viewModel.member, member.isCommonsMember {
            Color.commons
        } else if let member = viewModel.member, !member.isCommonsMember {
            Color.lords
        } else {
            Color.accentColor
        }
    }

    var partyColor: Color {
        Color(hexString: viewModel.member?.latestParty?.backgroundColour ?? "ffffff")
    }

    @ViewBuilder
    var scrollView: some View {
        if let member = viewModel.member {
            ScrollView {
                VStack(spacing: 24) {
                    heroCard(member: member)
                    if !viewModel.synopsis.isEmpty {
                        synopsisCard()
                    }
                    detailsCard(member: member)
                    linksCard(member: member)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    @ViewBuilder
    func heroCard(member: Member) -> some View {
        GroupedCard {
            VStack(spacing: 0) {
                Color(UIColor.secondarySystemGroupedBackground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .overlay {
                        if let portrait = viewModel.portraitImage {
                            Image(uiImage: portrait)
                                .resizable()
                                .scaledToFill()
                                .transition(.opacity)
                        } else {
                            ProgressView()
                        }
                    }
                    .clipped()
                    .animation(.easeInOut(duration: 0.3), value: viewModel.portraitImage != nil)

                Rectangle()
                    .fill(partyColor)
                    .frame(height: 4)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(member.nameFullTitle ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        Text(member.latestParty?.name ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(member.isCommonsMember ? "House of Commons" : "House of Lords")
                            .font(.caption)
                            .foregroundStyle(houseColor)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    func synopsisCard() -> some View {
        MinimalSection(title: "About") {
            Text(viewModel.synopsis)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    func detailsCard(member: Member) -> some View {
        MinimalSection(title: "Details") {
            DetailValueRow(label: "Party") {
                HStack(spacing: 6) {
                    Circle()
                        .fill(partyColor)
                        .frame(width: 10, height: 10)
                    Text(member.latestParty?.name ?? "")
                        .multilineTextAlignment(.trailing)
                        .font(.subheadline)
                }
            }

            if member.isCommonsMember, let constituency = viewModel.constituency {
                Divider().padding(.leading)
                ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
                    DetailValueRow(label: "Constituency") {
                        HStack(spacing: 4) {
                            Text(member.latestHouseMembership?.membershipFrom ?? "")
                                .multilineTextAlignment(.trailing)
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .foregroundStyle(.primary)
            } else if !member.isCommonsMember {
                Divider().padding(.leading)
                DetailValueRow(label: "Peerage type") {
                    Text(member.latestHouseMembership?.membershipFrom ?? "")
                        .font(.subheadline)
                }
            }
        }
    }

    @ViewBuilder
    func linksCard(member: Member) -> some View {
        MinimalSection(title: "Links") {
            ContextAwareNavigationLink(value: .billsView(member: member)) {
                DetailLinkRow(title: "View bills", image: "bill", color: houseColor)
            }
            .foregroundStyle(.primary)
            Divider().padding(.leading, 52)
            votesLink
            Divider().padding(.leading, 52)
            ContextAwareNavigationLink(value: .memberInterestsView(member: member)) {
                DetailLinkRow(title: "Registered interests", image: "interest", color: .accentColor)
            }
            .foregroundStyle(.primary)
            Divider().padding(.leading, 52)
            ContextAwareNavigationLink(value: .memberContactView(member: member)) {
                DetailLinkRow(title: "Contact details", image: "mail.fill", isSystemImage: true, color: .accentColor)
            }
            .foregroundStyle(.primary)
        }
    }

    @ViewBuilder
    var votesLink: some View {
        if let member = viewModel.member, member.isCommonsMember {
            ContextAwareNavigationLink(value: .memberCommonsVotesView(member: member)) {
                DetailLinkRow(title: "View commons votes", image: "vote", color: .commons)
            }
            .foregroundStyle(.primary)
        } else if let member = viewModel.member, !member.isCommonsMember {
            ContextAwareNavigationLink(value: .memberLordsVotesView(member: member)) {
                DetailLinkRow(title: "View lords votes", image: "vote", color: .lords)
            }
            .foregroundStyle(.primary)
        }
    }
}
