import SwiftUI
import SkeletonUI

struct MemberContactView: View {
    @StateObject var viewModel = MemberContactViewModel()
    var member: Member

    var body: some View {
        Group {
            if viewModel.contacts.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .onAppear {
            if let memberId = member.id {
                viewModel.fetchContacts(for: memberId)
            }
        }
        .navigationTitle("Contact details, \(member.nameDisplayAs ?? "")")
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
            ForEach(viewModel.contacts) { contact in
                Section(contact.type ?? "") {
                    VStack(alignment: .leading) {
                        if let line1 = contact.line1 {
                            if !(contact.isWebAddress ?? false) {
                                Text(line1)
                                    .bold()
                            } else {
                                Link(line1, destination: URL(string: line1)!)
                            }
                        }
                        if let line2 = contact.line2 {
                            Text(line2)
                        }
                        if let postcode = contact.postcode {
                            Text(postcode)
                        }
                        if let phone = contact.phone {
                            Text(phone)
                        }
                        if let email = contact.email {
                            Link(email, destination: URL(string: "mailto:" + email)!)
                        }
                    }
                    .font(.footnote)
                }
            }
        }
        .listStyle(.grouped)
    }
}
