//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Diego Sierra on 11/10/23.
//

import SwiftUI


struct ThemePicker: View {
    @Binding var selection: Theme
    var body: some View {
        if #available(iOS 16.0, *) {
            Picker("Theme", selection: $selection) {
                ForEach(Theme.allCases) { theme in
                    ThemeView(theme: theme)
                        .tag(theme)
                }
            }
            .pickerStyle(.navigationLink)
        } else {
            Picker("Theme", selection: $selection) {
                ForEach(Theme.allCases) { theme in
                    ThemeView(theme: theme)
                        .tag(theme)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    ThemePicker(selection: .constant(.periwinkle))
}
