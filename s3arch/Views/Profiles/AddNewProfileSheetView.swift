//
//  AddNewProfileSheetView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import SwiftUI

struct AddNewProfileSheetView: View {

  @Environment(\.dismiss) private var dismiss

  @State var name: String = ""

  @State var accessKeyInput: String = ""
  @State var accessKeySecretInput: String = ""
  @State var region: String = "us-east-1"

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Name", text: $name)
        }
        Section {

          TextField("AWS Access Key", text: $accessKeyInput)

          SecureField("AWS Access Key Secret", text: $accessKeySecretInput)

          Picker("Region", selection: $region) {
            ForEach(["us-east-1", "us-east-2"], id: \.self) {
              Text($0)
            }
          }
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
      .navigationTitle("Add Profile")
    }
  }
}

#Preview {
  AddNewProfileSheetView()
}
