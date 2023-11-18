//
//  ProfilesView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/15/23.
//

// TODO: Display name on buckets view

import SimpleKeychain
import SwiftUI

struct ProfilesView: View {
  private let keychainService = KeychainService()

  @State private var showAddNewProfileSheetView = false
  @State private var profilesState: [String: KeychainData] = [:]

  /// State used for deleting a profile item
  @State private var selectedKey: String = ""
  @State private var showingDeleteAlert: Bool = false

  var body: some View {
    NavigationStack {
      List {
        ForEach(
          profilesState.keys.sorted {
            guard let date1 = profilesState[$0]?.updatedAt, let date2 = profilesState[$1]?.updatedAt
            else { return false }
            return date1 > date2
          }, id: \.self
        ) { key in
          if let keychainData = profilesState[key] {
            NavigationLink(destination: BucketsView(keychainData: keychainData)) {
              Text("\(keychainData.name)")
            }
          }
        }
        .onDelete(perform: { indexSet in
          if let index = indexSet.first {
            selectedKey =
              profilesState.keys.sorted {
                guard let date1 = profilesState[$0]?.updatedAt,
                  let date2 = profilesState[$1]?.updatedAt
                else { return false }
                return date1 > date2
              }[index]
            showingDeleteAlert = true
          }
        })
      }
      .alert(isPresented: $showingDeleteAlert) {
        Alert(
          title: Text("Delete Profile"),
          message: Text("Are you sure you want to delete this profile?"),
          primaryButton: .destructive(Text("Delete")) {
            keychainService.deleteProfileFromKeychain(key: selectedKey)
            profilesState.removeValue(forKey: selectedKey)
          },
          secondaryButton: .cancel())
      }
      .navigationTitle("Profiles").toolbar {
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
    .onAppear(perform: loadProfilesState)
    .onChange(of: showAddNewProfileSheetView) {
      if !showAddNewProfileSheetView {
        loadProfilesState()
      }
    }
  }

  private func loadProfilesState() {
    self.profilesState = keychainService.loadAllProfilesFromKeychain()
  }
}

#Preview {
  ProfilesView()
}
