import SwiftUI
import PDFKit

struct BillPublicationPDFView: View {
    @StateObject var viewModel = BillPublicationPDFViewModel()
    var publication: BillPublication
    var file: BillPublicationFile

    var pdf: PDFDocument? {
        if let data = viewModel.data {
            PDFDocument(data: data)
        } else {
            nil
        }
    }

    var body: some View {
        pdfView
            .navigationTitle(file.filename)
            .onAppear {
                viewModel.fetchData(publicationId: publication.id, fileId: file.id)
            }
            .ifLet(viewModel.fileLocation) { view, url in
                view
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            ShareLink(item: url)
                        }
                    }
            }
    }

    @ViewBuilder
    var pdfView: some View {
        if let pdfData = pdf {
            PDFKitView(document: pdfData)
        } else if viewModel.loading {
            VStack {
                Text("Downloading...")
                ProgressView()
            }
        } else {
            VStack {
                Text("There was an error")
            }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    var document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
