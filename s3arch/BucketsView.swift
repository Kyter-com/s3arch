//
//  BucketsView.swift
//  s3arch
//
//  Created by Nick Reisenauer on 11/6/23.
//

import SwiftUI

struct BucketsView: View {
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                
            }
            .navigationTitle("Buckets")
            .toolbar {
                Button(
                    action: {
                        showingSheet.toggle()
                        print("Add Item:")
                    },
                    label: {
                        Image(systemName: "gearshape")
                    }).sheet(isPresented: $showingSheet) {
                        print("Sheet dismissed!")
                    } content: {
                        KeysSheetView()
                    }
            }
        }
    }
}

#Preview {
    BucketsView()
}
