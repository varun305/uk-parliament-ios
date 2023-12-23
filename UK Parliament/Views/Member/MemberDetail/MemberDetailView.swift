import SwiftUI

struct MemberDetailView: View {
    @StateObject var viewModel = MemberDetailViewModel()
    var member: Member
    var constituencyLink: Bool = true

    var body: some View {
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
            .listRowBackground(Color.clear)

            Section("Constituency") {
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
            }
        }
        .navigationTitle(member.nameDisplayAs)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMemberConstituency(for: member.id)
            viewModel.fetchMemberSynopsis(for: member.id)
        }
    }

    @ViewBuilder
    var membershipLink: some View {
        if member.isCommonsMember, let constituency = viewModel.constituency {
            NavigationLink {
                ConstituencyDetailView(constituency: constituency, memberLink: false)
            } label: {
                Text(member.latestHouseMembership.membershipFrom)
            }
        } else {
            Text(member.latestHouseMembership.membershipFrom)
        }
    }

    @ViewBuilder
    var membershipTile: some View {
        Text(member.latestHouseMembership.membershipFrom)
    }
}
