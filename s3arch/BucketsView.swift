//
//  BucketsView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import SwiftUI

struct BucketsView: View {

  @State private var showSettingsSheetView = false

  var body: some View {
    NavigationStack {
      Form {
        // TODO: Dynamically generate buckets from S3
        NavigationLink {
          BucketsView()
        } label: {
          Text("Test")
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
    }
  }
}

#Preview {
  BucketsView()
}
