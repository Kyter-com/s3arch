//
//  ProfilesView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

import SwiftUI

struct ProfilesView: View {

  @State private var showAddNewProfileSheetView = false

  var body: some View {
    NavigationStack {
      Form {

      }.navigationTitle("Profiles").toolbar {
        Button(
          action: {
            showAddNewProfileSheetView.toggle()
          },
          label: {
            Image(systemName: "plus.circle")
          }
        ).sheet(
          isPresented: $showAddNewProfileSheetView,
          content: {
            AddNewProfileSheetView()
          })
      }
    }
  }
}

#Preview {
  ProfilesView()
}
