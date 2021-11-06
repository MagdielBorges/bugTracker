//
//  ContentView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct ContentView: View {
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Menu {
                    Button("New Bug"){
                        activeSheet = .newBug
                        print(activeSheet)
                        showSheet = true
                    }
                    Button("Edit Details"){
                        activeSheet = .projectDetails
                        print(activeSheet)
                        showSheet = true
                    }
                    Button("Delete Project", role: .destructive){
                        showingDeleteAlert = true
                    }
                } label : {
                    Text("Menu")
                }
            }
        }
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
                CellView(bug: bug)
            }
        } else {
            if project.unfixedBugs.isEmpty {
                Text("Currently, all bugs are fixed in this project.")
            }
            ForEach(project.unfixedBugs) { bug in
                CellView(bug: bug)
            }
        }
    }
    var newBugButton: some View {
        Button("New Bug"){
            activeSheet = .newBug
            showSheet = true
        }
    }
}

struct CellView: View {
    @ObservedObject var bug: Bug
    @State private var showDetailEditSheet = false
    var body: some View {
        VStack {
            bugTitle
            Text(bug.detail)
                .italic()
        }
            .sheet(isPresented: $showDetailEditSheet){
                DetailEditView(bug: bug)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if bug.fixed == false {
                    Button("Mark as Fixed"){
                        bug.fixed = true
                    }
                    .tint(.green)
                }
                Button("Edit Details"){
                    showDetailEditSheet = true
                }
                .tint(.gray)
            }
    }
    @ViewBuilder
    var bugTitle: some View {
        if bug.fixed {
            Text(bug.title)
                .foregroundColor(.secondary)
                .strikethrough()
        } else if bug.highPriority {
            Text(bug.title)
                .bold()
                .background(.red)
        } else {
            Text(bug.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        Group {
            NavigationView {
                ContentView(project: Project(context: context))
                    .previewDevice("iPhone 13 Pro Max")
            }
            CellView(bug: Bug(context: context))
                .previewLayout(.sizeThatFits)
        }
    }
}
