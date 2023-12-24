import SwiftUI

struct MemberContactView: View {
    @StateObject var viewModel = MemberContactViewModel()
    var member: Member

    var body: some View {
        List {
            ForEach(viewModel.contacts) { contact in
                Section(contact.type) {
                    VStack(alignment: .leading) {
                        if !contact.isWebAddress {
                            Text(contact.line1)
                                .bold()
                        } else {
                            Text("[\(contact.line1)](\(contact.line1))")
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
                            Text("[\(email)](\(email))")
                        }
                    }
                    .font(.footnote)
                    .textSelection(.enabled)
                }
            }
        }
        .onAppear {
            viewModel.fetchContacts(for: member.id)
        }
        .navigationTitle("Contact details, \(member.nameDisplayAs)")
    }
}
