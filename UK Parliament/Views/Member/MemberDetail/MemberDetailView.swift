import SwiftUI
import SkeletonUI

struct MemberDetailView: View {
    @StateObject var viewModel = MemberDetailViewModel()
    var memberId: Int

    private var positionTypeString: String {
        if let house = viewModel.member?.latestHouseMembership?.house {
            return house == 2 ? "Peerage type" : "Constituency"
        } else {
            return ""
        }
    }

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
        .onAppear {
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
                    .frame(width: 180, height: 180)

                    Text("")
                        .skeleton(with: true)
                    Text("")
                        .skeleton(with: true)
                    Spacer()
                }
            }
            .multilineTextAlignment(.center)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
            }

            Section {
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
            }

            Section {
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
            }

            Section {
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
                NavigationLink {
                    Text("")
                } label: {
                    Text("")
                        .skeleton(with: true)
                        .frame(height: 10)
                }
                .disabled(true)
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        if let member = viewModel.member {
            List {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        MemberPictureView(member: member)
                            .frame(width: 180, height: 180)
                        Text(member.nameFullTitle ?? "")
                            .bold()
                        Text(viewModel.synopsis)
                            .font(.caption)
                    }
                    Spacer()
                }
                .multilineTextAlignment(.center)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hexString: member.latestParty?.backgroundColour ?? "ffffff"))
                        Text(member.latestParty?.name ?? "")
                    }
                }

                Section {
                    ContextAwareNavigationLink(value: .billsView(member: member)) {
                        Text("Bills")
                    }
                    votesLink
                }

                Section(positionTypeString) {
                    membershipLink
                }

                Section {
                    ContextAwareNavigationLink(value: .memberInterestsView(member: member)) {
                        Text("Registered interests")
                    }
                    ContextAwareNavigationLink(value: .memberContactView(member: member)) {
                        Text("Contact details")
                    }
                }
            }
            .listStyle(.grouped)
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if let member = viewModel.member, member.isCommonsMember, let constituency = viewModel.constituency {
            ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
                membershipTile
            }
        } else {
            membershipTile
        }
    }

    @ViewBuilder
    var votesLink: some View {
        if let member = viewModel.member, member.isCommonsMember {
            ContextAwareNavigationLink(value: .memberCommonsVotesView(member: member)) {
                Text("Commons votes")
            }
        }
    }

    @ViewBuilder
    var membershipTile: some View {
        if let member = viewModel.member {
            Text(member.latestHouseMembership?.membershipFrom ?? "")
        } else {
            Text("No member found")
                .italic()
        }
    }
}
