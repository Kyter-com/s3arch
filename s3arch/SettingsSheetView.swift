//
//  SettingsSheetView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import Security
import SwiftUI

struct SettingsSheetView: View {
  @Environment(\.dismiss) private var dismiss

  @State var accessKeyInput: String = ""
  @State var accessKeySecretInput: String = ""

  var body: some View {
    NavigationView {
      Form {
        Section {

          // TODO: Use secure fields probably

          TextField("AWS Access Key", text: $accessKeyInput)

          TextField("AWS Access Key Secret", text: $accessKeySecretInput)
        } header: {
          Text("AWS Credentials")
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            "Cancel",
            action: {
              dismiss()
            })
        }
        ToolbarItem(placement: .primaryAction) {
          Button(
            "Save",
            action: {
              dismiss()
            })
        }
      }
      .navigationTitle("Settings")
    }
  }
}

#Preview {
  SettingsSheetView()
}
