//
//  NewBugView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct NewBugView: View {
    @Environment(\.dismiss) var dismiss
    let project: Project
    @EnvironmentObject var store: StorageProvider
    @State private var title = ""
    @State private var detail = ""
    @State private var highPriority = false
    @State private var showWarning = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Bug Title", text: $title)
                    TextField("Detailed Description", text: $detail)
                }
                Section {
                    Toggle(isOn: $highPriority) {
                        Text("High Priority Bug")
                    }
                }
            }
            .navigationTitle("New Bug")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Create"){
                        guard !title.isEmpty else {
                            showWarning = true
                            return
                        }
                        store.newBug(in: project, title: title, detail: detail, highPriority: highPriority)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Discard"){
                        dismiss()
                    }
                }
            }
            .alert(Text("Cannot Create Bug"), isPresented: $showWarning) {
                Button("OK", role: .cancel){}
            } message: {
                Text("A bug must have a title.")
            }
        }
    }
}

struct NewBugView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        NewBugView(project: Project(context: context))
    }
}
