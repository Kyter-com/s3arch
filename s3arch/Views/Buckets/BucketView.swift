//
//  BucketView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/22/23.
//

import SwiftUI

struct FileItem: Identifiable {
  let id = UUID()
  let name: String
  let isFolder: Bool
  var children: [FileItem]?
}

func buildFileTree(from keys: [String]) -> [FileItem] {
  var root: [FileItem] = []

  for key in keys {
    let parts = key.split(separator: "/").map(String.init)
    addParts(parts, to: &root)
  }

  return root
}

func addParts(_ parts: [String], to items: inout [FileItem]) {
  if let first = parts.first {
    let isFolder = parts.count > 1
    if let index = items.firstIndex(where: { $0.name == first }) {
      if isFolder {
        if items[index].children == nil {
          items[index].children = []
        }
        addParts(Array(parts.dropFirst()), to: &items[index].children!)
      }
    } else {
      var newItem = FileItem(name: first, isFolder: isFolder, children: isFolder ? [] : nil)
      if isFolder {
        if newItem.children == nil {
          newItem.children = []
        }
        addParts(Array(parts.dropFirst()), to: &newItem.children!)
      }
      items.append(newItem)
    }
  }
}
// TODO: Clean up this file!!!
struct FolderView: View {
  let folder: FileItem
  @State private var selectedFile: FileItem?

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
      InfoView(file: file)
    }
  }
}

struct InfoView: View {
  let file: FileItem

  var body: some View {
    VStack(alignment: .leading) {
      Text("Name: \(file.name)")
      // Add more information about the file here
    }
    .padding()
    .navigationTitle("File Info")
  }
}

struct BucketView: View {
  let keychainData: KeychainData
  let bucketName: String
  @State private var fileNames: [String] = []
  @StateObject private var s3Client: S3Client
  @State private var fileItems: [FileItem] = []
  @State private var selectedFile: FileItem?

  init(keychainData: KeychainData, bucketName: String) {
    self.keychainData = keychainData
    self.bucketName = bucketName
    _s3Client = StateObject(wrappedValue: S3Client(keychainData: keychainData))
  }

  var body: some View {
    List {
      ForEach(fileItems) { item in
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
    .onAppear {
      Task {
        do {
          let keys = try await s3Client.listFileKeys(in: bucketName).get()
          self.fileItems = buildFileTree(from: keys)
        } catch {
          print("Error in listFileKeys", error)
        }
      }
    }
    .sheet(item: $selectedFile) { file in
      InfoView(file: file)
    }
    .onDisappear {
      do {
        try s3Client.client.syncShutdown()
      } catch {
        print("Failed to shutdown S3Client: \(error)")
      }
    }
  }
}

#Preview {
  let dummyKeychainData = KeychainData(
    accessKey: "123",
    accessKeySecret: "123",
    region: "us-east-2",
    name: "dummyKeychainData",
    updatedAt: Date())
  return BucketView(keychainData: dummyKeychainData, bucketName: "dummy-test-name")
}
