//
//  BucketsView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import SwiftUI

// TODO: Have default landing view for 'profiles', where you input region, id keys, etc
// TODO: Once you click on a profile, it takes you to the buckets view

struct BucketsView: View {
  @State private var bucketNames: [String] = []
  @State private var isLoading = false
  @State private var showSettingsSheetView = false
  private let s3Client = S3Client()

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
      .toolbar {
        Button(
          action: {
            showSettingsSheetView.toggle()
          },
          label: {
            Image(systemName: "gearshape")
          }
        ).sheet(
          isPresented: $showSettingsSheetView,
          content: {
            SettingsSheetView()
          })
      }
      .onAppear(perform: loadBuckets)
    }
  }

  private func loadBuckets() {
    isLoading = true
    s3Client.listBucketNames().whenComplete { result in
      switch result {
      case .success(let bucketNames):
        DispatchQueue.main.async {
          self.bucketNames = bucketNames
          self.isLoading = false
        }
      case .failure(let error):
        print("ERROR: \(error)")
        self.bucketNames = []
      }
    }
  }
}

#Preview {
  BucketsView()
}
