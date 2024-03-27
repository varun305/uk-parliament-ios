import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    let faqItems = [
        FAQItem(
            question: "How do I find my constituency?",
            answer: "You can select the constituencies page from the home screen, and enter your postcode in the search bar"
        ),
        FAQItem(
            question: "How do I see how my MP voted?",
            answer: "From the MPs page, search for your MP, select your MP, and select 'Commons votes'"
        ),
        FAQItem(
            question: "How do I see the latest version of a bill?",
            answer: "From the Bills page, search for the bill, select your bill and click 'All publications'"
        )
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("FAQ") {
                    ForEach(faqItems) { faqItem in
                        DisclosureGroup(faqItem.question) {
                            Text(faqItem.answer)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Section {
                    NavigationLink("Acknowledgements") {
                        VStack(alignment: .leading) {
                            Text("This product makes use of the UK Parliament API")
                            Link(
                                "Open parliament licence",
                                destination: URL(string: "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/")!
                            )
                            Text("© App developer " + String(Calendar.current.component(.year, from: Date())))
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

struct FAQItem: Identifiable {
    var question: String
    var answer: String

    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }

    var id: String {
        question + answer
    }
}

#Preview {
    HelpView()
}
