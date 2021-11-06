//
//  ProjectView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct ProjectView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store : StorageProvider
    @ObservedObject var project: Project
    @State private var showSheet = false
    enum ActiveSheet {
        case newBug, projectDetails
    }
    @State private var activeSheet : ActiveSheet = .newBug
    @State private var showingDeleteAlert = false
    var body: some View {
        List {
            bugList
        }
        .safeAreaInset(edge: .bottom){
            newBugButton
        }
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent() }
        .sheet(isPresented: $showSheet){
            switch activeSheet {
            case .newBug:
                NewBugView(project: project)
            case .projectDetails:
                ProjectDetailsEditView(project: project)
            }
        }
        .alert(Text("Delete Project?"), isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive){
                store.delete(project)
                dismiss()
            }
            Button("Cancel", role: .cancel){}
        } message : {
            Text("Are you sure you want to delete this project? This cannot be undone.")
        }
    }
    @ViewBuilder
    var bugList: some View {
        if project.showFixedBugs {
            if project.bugsSorted.isEmpty {
                Text("This project is empty.")
            }
            ForEach(project.bugsSorted) { bug in
                BugCellView(bug: bug)
            }
        } else {
            if project.unfixedBugs.isEmpty {
                Text("Currently, all bugs are fixed in this project.")
            }
            ForEach(project.unfixedBugs) { bug in
                BugCellView(bug: bug)
            }
        }
    }
    var newBugButton: some View {
        Button("New Bug"){
            activeSheet = .newBug
            showSheet = true
        }
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing){
            Menu {
                Button(action: {
                    activeSheet = .newBug
                    print(activeSheet)
                    showSheet = true
                }){
                    Label("New Bug", systemImage: "plus.circle")
                }
                Button(action: {
                    activeSheet = .projectDetails
                    print(activeSheet)
                    showSheet = true
                }){
                    Label("Edit Details", systemImage: "pencil")
                }
                Button(role: .destructive, action: {
                    showingDeleteAlert = true
                }){
                    Label("Delete Project", systemImage: "trash")
                }
            } label : {
                Text("Menu")
            }
        }
    }
}



struct ProjectView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        Group {
            NavigationView {
                ProjectView(project: Project(context: context))
                    .previewDevice("iPhone 13 Pro Max")
            }
            BugCellView(bug: Bug(context: context))
                .previewLayout(.sizeThatFits)
        }
    }
}
