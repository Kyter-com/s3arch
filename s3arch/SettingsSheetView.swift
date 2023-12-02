//
//  SettingsSheetView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 12/1/23.
//

import SwiftUI

struct SettingsSheetView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      Form {
        Text("Hi")
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button(
            "Done",
            action: {
              dismiss()
            }
          ).bold()
        }
      }
    }
  }
}

#Preview {
  SettingsSheetView()
}
