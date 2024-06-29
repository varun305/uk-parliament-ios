import SwiftUI
import SwiftSoup

struct LordsVoteDetailView: View {
    @StateObject var viewModel = LordsVoteDetailViewModel()
    var vote: LordsVote
    
    var body: some View {
        Group {
            if viewModel.vote != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .ifLet(vote.title) { $0.navigationTitle("Votes, \($1)") }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }
    
    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    NavigationLink {
                        Text("")
                    } label: {
                        VoterRowLoading()
                    }
                    .disabled(true)
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }
    
    @ViewBuilder
    var scrollView: some View {
        List {
            amendmentNotes
            
            voteCount
            
            Section("Votes") {
                VoteChart(yesVotes: viewModel.contentsGrouping, noVotes: viewModel.notContentsGrouping)
            }
            .accessibilityHidden(true)
            
            if let vote = viewModel.vote {
                ContextAwareNavigationLink(value: .allVotesView(allVotes: vote)) {
                    Label(
                        title: { Text("View all votes") },
                        icon: {
                            ZStack {
                                Rectangle()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .foregroundStyle(Color.lords)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 5)
                                    }
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .padding(3)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                            }
                        }
                    )
                }
            }
        }
    }
    
    @State private var showNotesSheet = false
    
    @ViewBuilder
    private var amendmentNotes: some View {
        if let amendmentMotionNotes = viewModel.vote?.amendmentMotionNotes {
            let string = getAttributedString(from: amendmentMotionNotes)
            Button {
                showNotesSheet = true
            } label: {
                Text(string)
                    .lineLimit(5)
                    .sheet(isPresented: $showNotesSheet) {
                        NavigationStack {
                            ScrollView {
                                Text(string)
                                    .padding()
                            }
                            .navigationTitle("Amendment motion notes")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button {
                                        showNotesSheet = false
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                    .foregroundStyle(.primary)
                                }
                            }
                        }
                    }
            }
            .foregroundStyle(.primary)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .padding(.bottom, 20)
        }
    }
    
    private func getAttributedString(from html: String) -> AttributedString {
        guard let document = try? SwiftSoup.parse(html) else { return AttributedString("") }
        
        func traverseNodes(_ node: Node, attributedString: inout AttributedString) {
            if let textNode = node as? TextNode {
                var text = AttributedString(textNode.text())
                if let parent = node.parent(), parent.nodeName() == "b" || parent.nodeName() == "strong" {
                    text = AttributedString(textNode.text())
                    text.font = .body.bold()
                } else if let parent = node.parent(), parent.nodeName() == "i" || parent.nodeName() == "em" {
                    text = AttributedString(textNode.text())
                    text.font = .body.italic()
                }
                attributedString += text
            } else if node.nodeName() == "br" {
                attributedString += AttributedString("\n")
            } else {
                for child in node.getChildNodes() {
                    traverseNodes(child, attributedString: &attributedString)
                }
                if node.nodeName() == "p" {
                    attributedString += AttributedString("\n")
                }
            }
        }
        
        var attributedString = AttributedString("")
        traverseNodes(document, attributedString: &attributedString)
        
        return attributedString
    }
    
    @ViewBuilder
    private var voteCount: some View {
        if let authoritativeContentCount = vote.authoritativeContentCount, let authoritativeNotContentCount = vote.authoritativeNotContentCount {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.secondary)
                    Text("\(authoritativeContentCount)")
                        .font(.title)
                        .if(authoritativeContentCount > authoritativeNotContentCount) { $0.bold() }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text("Contents \(authoritativeContentCount)"))
                Spacer()
                HStack {
                    Text("\(authoritativeNotContentCount)")
                        .font(.title)
                        .if(authoritativeContentCount < authoritativeNotContentCount) { $0.bold() }
                    Image(systemName: "hand.thumbsdown.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text("Not contents \(authoritativeNotContentCount)"))
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .padding(.bottom, 20)
            .padding(.horizontal, 20)
        }
    }
}
