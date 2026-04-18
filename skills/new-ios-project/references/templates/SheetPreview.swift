//
//  SheetPreview.swift
//  {{APP_NAME}}
//
//  Wrap a sheet's content in `SheetPreview { ... }` inside `#Preview` to see
//  it presented as a sheet rather than inline.
//

import SwiftUI

struct SheetPreview<Content: View>: View {
    let content: () -> Content
    @State private var show = true

    var body: some View {
        Color.clear
            .sheet(isPresented: $show) {
                content()
            }
    }
}
