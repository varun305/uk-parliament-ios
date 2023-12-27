import SwiftUI


struct AcknowledgementsView: View {
    private var LICENSE = "MIT License\n\nCopyright (c) 2023 Varun Santhosh\n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.\n"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(LICENSE)
                    .italic()
                    .foregroundStyle(.secondary)

                Group {
                    Text("This application is open source")
                        .foregroundStyle(.secondary)
                    Link("GitHub repository", destination: URL(string: "https://github.com/varun305/uk-parliament-ios")!)
                        .italic()
                }
                .padding(.top)

                Group {
                    Text("This product makes use of the UK Parliament API")
                        .foregroundStyle(.secondary)
                    Link("Open Parliament Licence", destination: URL(string: "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence")!)
                        .italic()
                }
                .padding(.top)
            }
            .font(.footnote)
            .padding()
        }
        .navigationTitle("Acknowledgements")
        .navigationBarTitleDisplayMode(.inline)
    }
}
