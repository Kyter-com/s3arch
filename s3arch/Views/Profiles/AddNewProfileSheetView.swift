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
            ForEach(
              [
                "us-east-2",
                "us-east-1",
                "us-west-1",
                "us-west-2",
                "af-south-1",
                "ap-east-1",
                "ap-south-2",
                "ap-southeast-3",
                "ap-south-1",
                "ap-northeast-3",
                "ap-northeast-2",
                "ap-southeast-1",
                "ap-southeast-2",
                "ap-northeast-1",
                "ca-central-1",
                "eu-central-1",
                "eu-west-1",
                "eu-west-2",
                "eu-south-1",
                "eu-west-3",
                "eu-south-2",
                "eu-north-1",
                "eu-central-2",
                "me-south-1",
                "me-central-1",
                "sa-east-1",
              ], id: \.self
            ) {
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
