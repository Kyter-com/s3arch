//
//  FolderView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 12/1/23.
//

import SwiftUI

struct FolderView: View {
  @State private var selectedFile: FileItem?

  let folder: FileItem

  var body: some View {
    List {
      ForEach(folder.children ?? []) { item in
        if item.isFolder {
          NavigationLink(destination: FolderView(folder: item)) {
            Text(item.name)
          }
        } else {
          HStack {
            Text(item.name)
            Spacer()
            Button(
              action: { selectedFile = item },
              label: {
                Image(systemName: "info.circle")
              })
          }
        }
      }
    }
    .navigationTitle(folder.name)
    .sheet(item: $selectedFile) { file in
      FileInfoView(file: file)
    }
  }
}
