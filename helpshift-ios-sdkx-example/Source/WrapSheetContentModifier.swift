//
//  WrapSheetContentModifier.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI

public struct WrapSheetContentModifier: ViewModifier {
    @State private var sheetHeight: CGFloat = .zero

    public func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.background {
                GeometryReader { proxy in
                    Color.clear.preference(key: SheetHeightPreferenceKey.self, value: proxy.size.height)
                }
                .onPreferenceChange(SheetHeightPreferenceKey.self) { newHeight in
                    sheetHeight = newHeight
                }
                .presentationDetents([.height(sheetHeight)])
            }
        } else {
            VStack {
                Color.clear.background(ClearView())
                content
            }
        }
    }
}

extension View {
    func wrapSheetContent() -> some View {
        modifier(WrapSheetContentModifier())
    }
}

private struct ClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            for v in sequence(first: view, next: { $0.superview }) {
                v.backgroundColor = .clear
            }
        }
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {}
}

private struct SheetHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}
