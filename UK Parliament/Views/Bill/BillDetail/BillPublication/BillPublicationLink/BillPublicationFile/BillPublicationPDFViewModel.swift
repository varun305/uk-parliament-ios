import Foundation
import PDFKit

extension BillPublicationPDFView {
    @MainActor class BillPublicationPDFViewModel: ObservableObject {
        @Published var data: Data? = nil
        @Published var loading: Bool = false
        @Published var fileLocation: URL? = nil
        @Published var downloading: Bool = false

        func fetchData(publicationId: Int, fileId: Int) {
            Task {
                self.loading = true
                BillModel.shared.fetchFile(publicationId: publicationId, fileId: fileId) { data in
                    Task { @MainActor in
                        self.data = data
                        self.loading = false
                    }
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

                Task { @MainActor in
                    fileLocation = file
                }
            }
        }
    }
}
