//
//  s3archApp.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/2/23.
//

// Format: swift-format ./Documents/GitHub/s3arch/ -i -r
// Lint:   swift-format lint ./Documents/GitHub/s3arch/ -r
// Both:   swift-format ./Documents/GitHub/s3arch/ -i -r && swift-format lint ./Documents/GitHub/s3arch/ -r

import SwiftUI

@main
struct S3archApp: App {
  var body: some Scene {
    WindowGroup {
      ProfilesView()
    }
  }
}
