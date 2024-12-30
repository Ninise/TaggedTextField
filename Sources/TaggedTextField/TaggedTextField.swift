import SwiftUI

// MARK: - Main View
/// A text field with tagging functionality, allowing users to select tagged items from a search.
public struct TaggedTextFieldView<T: TaggedItem>: View {
    
    public init(text: Binding<String>,
                tagConfig: TagConfiguration,
                onSearch: @escaping (String, String) -> Void,
                onSubmit: @escaping (String) -> Void,
                onSelectItem: @escaping (T) -> Void,
                searchResults: [T]) {
        self._text = text
        self.tagConfig = tagConfig
        self.onSearch = onSearch
        self.onSubmit = onSubmit
        self.onSelectItem = onSelectItem
        self.searchResults = searchResults
    }
    
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @Binding var text: String
    let tagConfig: TagConfiguration
    let onSearch: (String, String) -> Void
    let onSubmit: (String) -> Void
    let onSelectItem: (T) -> Void
    let searchResults: [T]
    
    @State private var selection = NSRange(location: 0, length: 0)
    @State private var lastExtractedText: String? = nil
    @State private var showSearchPopover: Bool = false
    @State private var isTextInsertion: Bool = false
    
    // MARK: - Constants
    private let SEND_ICON = "paperplane.fill"
    
    // MARK: - Body
    public var body: some View {
        ZStack(alignment: .topLeading) {
            searchPopover
            
            VStack(alignment: .leading) {
                HStack {
                    UIKitTextView(text: $text, selectedRange: $selection, isTextInsertion: $isTextInsertion)
                        .frame(minHeight: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                        .onChange(of: selection) {
                            handleSelectionChange()
                        }
                    
                    submitButton
                }
            }
        }
    }
    
    // MARK: - Private Views
    private var searchPopover: some View {
        Text("________________") // Anchor for popover
            .opacity(0.04)
            .popover(isPresented: $showSearchPopover,
                     attachmentAnchor: .point(.topTrailing),
                     arrowEdge: .top) {
                SearchResultsView(
                    results: searchResults,
                    noResultsMessage: tagConfig.noResultsMessage,
                    onSelect: handleItemSelection
                )
                .presentationCompactAdaptation(.none)
            }
    }
    
    private var submitButton: some View {
        Button(action: { submitText() }) {
            Image(systemName: SEND_ICON)
                .font(.title2)
                .foregroundColor(text.isEmpty ? .gray : .blue)
        }
        .padding(.trailing, 20)
        .disabled(text.isEmpty)
    }
    
    // MARK: - Private Methods
    private func handleSelectionChange() {
        lastExtractedText = nil
        TagParser.extractTaggedText(
            start: selection.location - 1,
            text: text,
            trigger: tagConfig.trigger,
            onShowSearchPopover: { show in
                showSearchPopover = show
            },
            onLastExtText: { lastExtText in
                lastExtractedText = lastExtText
            },
            performSearch: { trigger, txt in
                onSearch("\(trigger)", txt)
            })
    }
    
    private func handleItemSelection(_ item: T) {
        guard let lastExt = lastExtractedText else { return }
        
        let toReplace = "\(tagConfig.trigger)\(lastExt)"
        let replacement = item.taggedDisplayText()
        
        withAnimation {
            isTextInsertion = true
            
            DispatchQueue.main.async {
                text = text.replacingOccurrences(
                    of: toReplace,
                    with: replacement,
                    options: .backwards,
                    range: text.range(of: toReplace, options: .backwards)
                )
                
                selection.location += replacement.count - toReplace.count
                onSelectItem(item)
                showSearchPopover = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextInsertion = false
                }
            }
        }
    }
    
    private func submitText() {
        onSubmit(text)
        text = ""
    }
}
