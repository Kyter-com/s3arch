//
//  FileInfoView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 12/1/23.
//

import SwiftUI

struct FileInfoView: View {
  let file: FileItem

  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Text("Name: \(file.name)")
        // Add more information about the file here
      }
      .padding()
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("File Info")
      .toolbar {
        ToolbarItem {
          Button("Done") {
            dismiss()
          }
          .bold()
        }
      }
    }
  }
}
