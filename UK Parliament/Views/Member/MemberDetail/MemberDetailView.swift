import SwiftUI

struct MemberDetailView: View {
    @StateObject var viewModel = MemberDetailViewModel()
    var memberId: Int

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

                    Section {
                        ContextAwareNavigationLink(value: .billsView(member: member)) {
                            Text("Bills")
                        }
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
            ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
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
