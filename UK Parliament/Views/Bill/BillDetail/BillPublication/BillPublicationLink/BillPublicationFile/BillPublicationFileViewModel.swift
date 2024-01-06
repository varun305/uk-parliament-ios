import Foundation

extension BillPublicationFileView {
    @MainActor class BillPublicationFileViewModel: ObservableObject {
        @Published var pdfData: Data? = nil

        func getPDF(publicationId: Int, fileId: Int) {
            BillModel.shared.fetchFile(publicationId: publicationId, fileId: fileId) { data in
                Task { @MainActor in
                    self.pdfData = data
                }
            }
        }
    }
}
