//
//  NavigationCellView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import Foundation
import SwiftUI

struct NavigationCellView: View {
    @EnvironmentObject var store : StorageProvider
    @ObservedObject var project : Project
    @State private var showProjectDetailSheet = false
    @State private var showingDeleteAlert = false
    var body: some View {
        NavigationLink(destination: ContentView(project: project)){
            VStack {
                Text(project.title)
                    .font(.title2).fontWeight(.light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                HStack {
                    Text("\(project.unfixedBugCount) Issue(s)")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer()
                    Text("\(project.fixedBugCount) Fixed")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .contextMenu {
            Button("Edit Details"){
                showProjectDetailSheet = true
            }
            Button("Delete Project"){
                showingDeleteAlert = true
            }
        }
        .sheet(isPresented: $showProjectDetailSheet){
            ProjectDetailsEditView(project: project)
        }
        .alert(Text("Delete Project?"), isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive){
                store.delete(project)
            }
            Button("Cancel", role: .cancel){}
        } message : {
            Text("Are you sure you want to delete this project? This cannot be undone.")
        }
    }
}

struct NavigationCellView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        NavigationCellView(project: Project(context: context))
            .previewLayout(.sizeThatFits)
    }
}
