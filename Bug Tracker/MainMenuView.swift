//
//  MainMenuView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct MainMenuView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.creationDate_)], predicate: NSPredicate(format: "active = true"), animation: .default) var activeProjects : FetchedResults<Project>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.creationDate_)], predicate: NSPredicate(format: "active = false"), animation: .default) var inactiveProjects : FetchedResults<Project>
    @EnvironmentObject var store : StorageProvider
    @State private var showingNewProjectSheet = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Active Projects")
                    .bold()
                if activeProjects.isEmpty {
                    Text("You have no active projects.")
                }
                ScrollView(showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 200))]) {
                        ForEach(activeProjects){ project in
                            NavigationCellView(project: project)
                        }
                    }
                }
                Text("Inactive Projects")
                    .bold()
                if inactiveProjects.isEmpty {
                    Text("You have no inactive projects.")
                }
                ScrollView(showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140, maximum: 200))]) {
                        ForEach(inactiveProjects){ project in
                            NavigationCellView(project: project)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("New Project"){
                        showingNewProjectSheet = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("Bug Tracker")
            .sheet(isPresented: $showingNewProjectSheet){
                NewProjectView()
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var store = StorageProvider()
    static var previews: some View {
        MainMenuView()
            .environment(\.managedObjectContext, store.persistentContainer.viewContext)
            .environmentObject(store)
            .previewDevice("iPhone 13 Pro Max")
    }
}


