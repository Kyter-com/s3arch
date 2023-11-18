//
//  BucketsView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import SwiftUI

struct BucketsView: View {
  let keychainData: KeychainData
  @State private var bucketNames: [String] = ["test"]
  @State private var isLoading = false

  var body: some View {
    NavigationStack {
      Form {
        if isLoading {
          ProgressView()
        } else {
          ForEach(bucketNames, id: \.self) { bucketName in
            NavigationLink(destination: Text(bucketName)) {
              Text(bucketName)
            }
          }
        }
      }
      .navigationTitle("Buckets")
//      .onAppear(perform: loadBuckets)
    }
  }

//    private func loadBuckets() {
//      isLoading = true
//      s3Client.listBucketNames().whenComplete { result in
//        switch result {
//        case .success(let bucketNames):
//          DispatchQueue.main.async {
//            self.bucketNames = bucketNames
//            self.isLoading = false
//          }
//        case .failure(let error):
//          print("ERROR: \(error)")
//          self.bucketNames = []
//        }
//      }
//    }
}

#Preview {
  let dummyKeychainData = KeychainData(
    accessKey: "123",
    accessKeySecret: "123",
    region: "us-east-2",
    name: "dummyKeychainData",
    updatedAt: Date())
  return BucketsView(keychainData: dummyKeychainData)
}
