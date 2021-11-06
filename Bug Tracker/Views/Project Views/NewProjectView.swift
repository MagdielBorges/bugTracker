//
//  NewProjectView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct NewProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store : StorageProvider
    @State private var title = ""
    @State private var showFixedBugs = false
    @State private var showWarning = false
    var body: some View {
        NavigationView {
            Form {
                TextField("Project Title", text: $title)
                Toggle(isOn: $showFixedBugs) {
                    Text("Show Fixed Bugs")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Create"){
                        guard !title.isEmpty else {
                            showWarning = true
                            return
                        }
                        store.newProject(title: title, showFixedBugs: showFixedBugs)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Discard"){
                        dismiss()
                    }
                }
            }
            .alert(Text("Cannot Create Project"), isPresented: $showWarning) {
                Button("OK", role: .cancel){}
            } message: {
                Text("A project must have a title.")
            }
        }
    }
}

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
    }
}
