//
//  BucketsView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

// TODO: Handle individual buckets in form

import SwiftUI

struct BucketsView: View {
  let keychainData: KeychainData
  @State private var bucketNames: [String] = []
  @State private var isLoading = false
  @StateObject private var s3Client: S3Client
  @State private var searchText = ""

  init(keychainData: KeychainData) {
    self.keychainData = keychainData
    _s3Client = StateObject(wrappedValue: S3Client(keychainData: keychainData))
  }

  var body: some View {
    NavigationStack {
      Form {
        if isLoading {
          ProgressView()
        } else {
          ForEach(
            bucketNames.filter {
              searchText.lowercased().isEmpty || $0.contains(searchText.lowercased())
            }, id: \.self
          ) { bucketName in
            NavigationLink(
              destination: BucketView(keychainData: keychainData, bucketName: bucketName)
            ) {
              Text(bucketName)
            }
          }
        }
      }
      .navigationTitle("Buckets")
      .onAppear {
        Task {
          do {
            self.bucketNames = try await s3Client.listBucketNames().get()
          } catch {
          }
        }
      }
      .onDisappear {
        do {
          try s3Client.client.syncShutdown()
        } catch {
        }
      }
      .searchable(
        text: $searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Bucket name"
      )
    }
  }
}

// TODO: Add search to profile and bucket views!

#Preview {
  let dummyKeychainData = KeychainData(
    accessKey: "123",
    accessKeySecret: "123",
    region: "us-east-2",
    name: "dummyKeychainData",
    updatedAt: Date())
  return BucketsView(keychainData: dummyKeychainData)
}
