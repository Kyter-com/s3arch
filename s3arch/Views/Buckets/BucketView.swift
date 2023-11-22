//
//  BucketView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/22/23.
//

import SwiftUI

struct BucketView: View {
  let keychainData: KeychainData
  let bucketName: String
  @State private var fileNames: [String] = []
  @StateObject private var s3Client: S3Client

  init(keychainData: KeychainData, bucketName: String) {
    print("In Bucket", bucketName)
    self.keychainData = keychainData
    self.bucketName = bucketName
    _s3Client = StateObject(wrappedValue: S3Client(keychainData: keychainData))
  }

  var body: some View {
    List(fileNames, id: \.self) { fileName in
      Text(fileName)
    }
    .onAppear {
      Task {
        do {
          self.fileNames = try await s3Client.listFileKeys(in: bucketName).get()
        } catch {
          print("Error in listFileKeys", error)
        }
      }
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
