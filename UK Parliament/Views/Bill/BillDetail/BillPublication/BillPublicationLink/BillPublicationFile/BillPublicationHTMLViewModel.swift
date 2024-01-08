import Foundation

extension BillPublicationHTMLView {
    @MainActor class BillPublicationHTMLViewModel: ObservableObject {
        @Published var data: String? = nil
        @Published var loading: Bool = false

        func fetchData(publicationId: Int, fileId: Int) {
            loading = true
            BillModel.shared.fetchFile(publicationId: publicationId, fileId: fileId) { data in
                var string: String? = nil
                if let data = data {
                    string = String(decoding: data, as: UTF8.self)
                }
                Task { @MainActor in
                    self.data = string
                    self.loading = false
                }
            }
        }
    }
}
