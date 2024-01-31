import SwiftUI
import WebKit

struct BillPublicationHTMLView: View {
    @StateObject var viewModel = BillPublicationHTMLViewModel()
    var publication: BillPublication
    var file: BillPublicationFile

    var body: some View {
        htmlView
            .navigationTitle(file.filename ?? "")
            .onAppear {
                if let publicationId = publication.id, let fileId = file.id {
                    viewModel.fetchData(publicationId: publicationId, fileId: fileId)
                }
            }
    }

    @ViewBuilder
    var htmlView: some View {
        if let data = viewModel.data {
            HTMLView(htmlString: data)
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

struct HTMLView: UIViewRepresentable {
    var htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
