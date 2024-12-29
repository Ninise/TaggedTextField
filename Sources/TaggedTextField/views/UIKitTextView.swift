//
//  File.swift
//  
//
//  Created by Nikita on 29.12.2024.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - UITextViewWrapper
/// Wraps UITextView from UIKit to provide more settings, (text changes, height calculation)
fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView
    
    @Binding var text: String
    @Binding var selectedRange: NSRange
    @Binding var calculatedHeight: CGFloat
    @Binding var isTextInsertion: Bool
    var onDone: (() -> Void)?
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        if nil != onDone {
            textView.returnKeyType = .done
        }
        
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if textView.text != self.text && (isTextInsertion || !textView.isFirstResponder) {
            textView.text = self.text
            textView.selectedRange = selectedRange
            
            textView.scrollRangeToVisible(selectedRange)
            textView.layoutIfNeeded()
        }
        
        if textView.selectedRange != selectedRange {
            textView.selectedRange = selectedRange
        }
        
        if textView.window != nil, !textView.isFirstResponder {
            if !textView.text.isEmpty {
                textView.becomeFirstResponder()
                textView.selectedRange = selectedRange
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, selection: $selectedRange, height: $calculatedHeight, onDone: onDone)
    }
    
    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height
            }
        }
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var selection: Binding<NSRange>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        
        init(text: Binding<String>, selection: Binding<NSRange>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.selection = selection
            self.calculatedHeight = height
            self.onDone = onDone
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.text.wrappedValue = textView.text
                self.selection.wrappedValue = textView.selectedRange
            }
            UITextViewWrapper.recalculateHeight(view: textView, result: calculatedHeight)
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            self.selection.wrappedValue = textView.selectedRange
        }
    }
}

// MARK: - UIKitTextView
/// A bridge between UIKit and SwiftUI
struct UIKitTextView: View {
    private var placeholder: String
    
    @Binding private var text: String
    @Binding private var selectedRange: NSRange
    @Binding private var isTextInsertion: Bool
    
    private var internalText: Binding<String> {
        Binding<String>(get: { text }) {
            text = $0
        }
    }
    
    @State private var dynamicHeight: CGFloat = 37
    @State private var showingPlaceholder = false
    
    init (_ placeholder: String = "", text: Binding<String>, selectedRange: Binding<NSRange>, isTextInsertion: Binding<Bool>) {
        self.placeholder = placeholder
        self._text = text
        self._selectedRange = selectedRange
        self._isTextInsertion = isTextInsertion
    }
    
    var body: some View {
        UITextViewWrapper(
            text: internalText,
            selectedRange: $selectedRange,
            calculatedHeight: $dynamicHeight,
            isTextInsertion: $isTextInsertion
        )
        .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
        .background(placeholderView, alignment: .topLeading)
        
    }
    
    var placeholderView: some View {
        Group {
            if text.isEmpty {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
