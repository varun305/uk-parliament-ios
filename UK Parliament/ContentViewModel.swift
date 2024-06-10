import Foundation
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var banner: Banner? = nil
    private var fetched = false

    func fetchBanner() async {
        let db = Firestore.firestore()
        let docRef = db.collection("metadata").document("home-page-banner")

        do {
            let doc = try await docRef.getDocument()

            let title = doc.data()?["title"] as? String
            let subtitle = doc.data()?["subtitle"] as? String?

            if let title = title {
                Task { @MainActor in
                    withAnimation {
                        self.banner = Banner(title: title, subtitle: subtitle ?? nil, image: Image("info"))
                    }
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
