//
//  s3archApp.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/2/23.
//

import SwiftUI

@main
struct s3archApp: App {
    var body: some Scene {
        WindowGroup {
            KeysView()
            ContentView()
            BucketsView()
        }
    }
}
