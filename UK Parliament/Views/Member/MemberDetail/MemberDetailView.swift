import SwiftUI

struct MemberDetailView: View {
    @StateObject var viewModel = MemberDetailViewModel()
    var memberId: Int
    var constituencyLink: Bool = true

    private var positionTypeString: String {
        viewModel.member?.latestHouseMembership.house == 2 ? "Peerage type" : "Constituency"
    }

    var body: some View {
        Group {
            if let member = viewModel.member {
                List {
                    VStack(alignment: .center) {
                        HStack {
                            Spacer()
                            MemberPictureView(member: member)
                                .frame(width: 180, height: 180)
                            Spacer()
                        }
                        Text(member.nameFullTitle)
                            .bold()
                        Text(viewModel.synopsis)
                            .font(.caption)
                    }
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)

                    Section {
                        HStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(hexString: member.latestParty.backgroundColour ?? "ffffff"))
                            Text(member.latestParty.name)
                        }
                    }

                    Section(positionTypeString) {
                        if constituencyLink {
                            membershipLink
                        } else {
                            membershipTile
                        }
                    }

                    Section {
                        NavigationLink("Registered interests") {
                            RegisteredInterestsView(member: member)
                        }
                        NavigationLink("Contact details") {
                            MemberContactView(member: member)
                        }
                    }
                }
                .navigationTitle(member.nameDisplayAs)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchMember(for: memberId)
            viewModel.fetchMemberSynopsis(for: memberId)
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if let member = viewModel.member, member.isCommonsMember, let constituency = viewModel.constituency {
            NavigationLink {
                ConstituencyDetailView(constituencyId: constituency.id, memberLink: false)
            } label: {
                membershipTile
            }
        } else {
            membershipTile
        }
    }

    @ViewBuilder
    var membershipTile: some View {
        if let member = viewModel.member {
            Text(member.latestHouseMembership.membershipFrom)
        } else {
            Text("No member found")
                .italic()
        }
    }
}
