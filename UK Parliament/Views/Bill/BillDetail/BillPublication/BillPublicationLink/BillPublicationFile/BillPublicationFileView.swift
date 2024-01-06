import SwiftUI
import PDFKit

struct BillPublicationFileView: View {
    @StateObject var viewModel = BillPublicationFileViewModel()
    var publication: BillPublication
    var file: BillPublicationFile

    var body: some View {
        Group {
            if let pdfData = viewModel.pdfData {
                PDFKitView(pdfData: pdfData)
            } else {
                VStack {
                    Text("Downloading...")
                    ProgressView()
                }
            }
        }
        .onAppear {
            viewModel.getPDF(publicationId: publication.id, fileId: file.id)
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    var pdfData: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: pdfData)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
