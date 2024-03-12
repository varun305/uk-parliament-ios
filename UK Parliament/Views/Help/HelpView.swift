import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    let faqItems = [
        FAQItem(
            question: "How can I find my constituency?",
            answer: "You can select the constituencies page from the home screen, and enter your postcode in the search bar"
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
            }
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
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
