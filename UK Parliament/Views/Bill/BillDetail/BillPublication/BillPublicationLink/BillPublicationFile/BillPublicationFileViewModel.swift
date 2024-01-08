import Foundation

extension BillPublicationPDFView {
    @MainActor class BillPublicationPDFViewModel: ObservableObject {
        @Published var data: Data? = nil
        @Published var loading: Bool = false

        func fetchData(publicationId: Int, fileId: Int) {
            loading = true
            BillModel.shared.fetchFile(publicationId: publicationId, fileId: fileId) { data in
                Task { @MainActor in
                    self.data = data
                    self.loading = false
                }
            }
        }
    }
}
