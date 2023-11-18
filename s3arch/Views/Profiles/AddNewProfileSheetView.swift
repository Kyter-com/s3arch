//
//  AddNewProfileSheetView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import SimpleKeychain
import SwiftUI

struct AddNewProfileSheetView: View {
  private let keychainService = KeychainService()

  @Environment(\.dismiss) private var dismiss

  @State var name: String = ""
  @State var accessKeyInput: String = ""
  @State var accessKeySecretInput: String = ""
  @State var region: String = "us-east-2"
  // TODO: Add all the regions in and map them to the correct .dot notation

  var disableForm: Bool {
    name.count < 1 || name.count > 42 || accessKeyInput.count < 1
      || accessKeySecretInput.count < 1 || region.count < 1
  }

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Name", text: $name)
        } footer: {
          Text("1-42 characters.")
        }
        Section {
          TextField("AWS Access Key", text: $accessKeyInput).textInputAutocapitalization(.never)
          SecureField("AWS Access Key Secret", text: $accessKeySecretInput)
            .textInputAutocapitalization(.never)
          Picker("Region", selection: $region) {
            ForEach(
              [
                "us-east-2"
              ], id: \.self
            ) {
              Text($0)
            }
          }
        } header: {
          Text("AWS Credentials")
        } footer: {
          Text(
            "Your credentials are securely stored in the Apple Keychain, a secure storage system. We do not have access to this data and it never leaves your device."
          )
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
              let dataToStoreOne = KeychainData(
                accessKey: accessKeyInput, accessKeySecret: accessKeySecretInput, region: region,
                name: name, updatedAt: Date())
              do {
                let dataToStore = try JSONEncoder().encode(dataToStoreOne)
                try keychainService.simpleKeychain.set(dataToStore, forKey: UUID().uuidString)
              } catch {
                print(error.localizedDescription)
              }

              dismiss()
            }
          ).disabled(disableForm)
        }
      }
      .navigationTitle("Add Profile")
    }
  }
}

#Preview {
  AddNewProfileSheetView()
}
