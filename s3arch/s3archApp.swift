//
//  s3archApp.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/2/23.
//

// Format: swift-format ./Documents/GitHub/s3arch/ -i -r
// Lint:   swift-format lint ./Documents/GitHub/s3arch/ -r

import SwiftUI

@main
struct S3archApp: App {
  var body: some Scene {
    WindowGroup {
      ProfilesView()
    }
  }
}

// TODO: Setup dependabot and CodeQL https://blog.eidinger.info/github-embraces-swift-and-provides-code-analysis-security-alerts-and-dependency-updates-for-swift-projects
