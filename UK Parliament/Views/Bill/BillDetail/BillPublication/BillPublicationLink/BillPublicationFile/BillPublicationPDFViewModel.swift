import Foundation
import PDFKit

extension BillPublicationPDFView {
    @MainActor class BillPublicationPDFViewModel: ObservableObject {
        @Published var data: Data? = nil {
            didSet {
                if let data = data {
                    saveFile(data: data)
                }
            }
        }
        @Published var loading: Bool = false
        @Published var fileLocation: URL? = nil

        func fetchData(publicationId: Int, fileId: Int) {
            loading = true
            BillModel.shared.fetchFile(publicationId: publicationId, fileId: fileId) { data in
                Task { @MainActor in
                    self.data = data
                    self.loading = false
                }
            }
        }

        private func saveFile(data: Data, name: String = "temp.pdf") {
            fileLocation = nil
            let pdf = PDFDocument(data: data)
            if let pdfData = pdf?.dataRepresentation() {
                let temp = FileManager.default.temporaryDirectory
                let file = temp.appending(path: name, directoryHint: .notDirectory)

                do {
                    try pdfData.write(to: file)
                } catch {

                }

                fileLocation = file
            }
        }
    }
}
