//
//  ProjectDetailsEditView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct ProjectDetailsEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: StorageProvider
    @ObservedObject var project: Project
    @State private var title : String
    @State private var active : Bool
    @State private var showFixedBugs : Bool
    init(project: Project){
        self.project = project
        _title = State(initialValue: project.title)
        _active = State(initialValue: project.active)
        _showFixedBugs = State(initialValue: project.showFixedBugs)
    }
    var body: some View {
        NavigationView {
            Form {
                TextField("Project Title", text: $title)
                Toggle(isOn: $showFixedBugs) {
                    Text("Show Fixed Bugs")
                }
                Toggle(isOn: $active) {
                    Text("Active Project")
                }
            }
            .interactiveDismissDisabled()
            .navigationTitle("Project Details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        store.updateProject(project, title: title, active: active, showFixedBugs: showFixedBugs)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ProjectDetailsEditView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        ProjectDetailsEditView(project: Project(context: context))
    }
}
