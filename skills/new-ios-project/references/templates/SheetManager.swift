//
//  SheetManager.swift
//  {{APP_NAME}}
//

import Foundation

final class SheetManager: ObservableObject {
    @Published var activeSheet: AppSheet? = nil

    func show(_ sheet: AppSheet) {
        guard activeSheet?.id != sheet.id else { return }
        activeSheet = sheet
    }

    func dismiss() {
        activeSheet = nil
    }
}
