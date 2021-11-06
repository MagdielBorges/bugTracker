//
//  BugCellView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/6/21.
//

import SwiftUI

struct BugCellView: View {
    @EnvironmentObject var store: StorageProvider
    @ObservedObject var bug: Bug
    @State private var showDetailEditSheet = false
    var body: some View {
        VStack {
            bugTitle
            Text(bug.detail)
                .foregroundColor(.secondary)
                .font(.caption)
                .italic()
        }
            .sheet(isPresented: $showDetailEditSheet){
                BugDetailEditView(bug: bug)
            }
            .contextMenu { contextMenu }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                swipeActions
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
    @ViewBuilder
    var swipeActions : some View {
        Button(bug.fixed ? "Mark as Bugged" : "Mark as Fixed"){
            bug.fixed.toggle()
            bug.project.objectWillChange.send()
            store.save()
        }
        .tint(bug.fixed ? .red : .green)
        Button(action: {
            showDetailEditSheet = true
        }){
            Label("Edit Details", systemImage: "pencil")
        }
        .tint(.gray)
    }
    @ViewBuilder
    var contextMenu : some View {
        Button(action: {
            bug.fixed.toggle()
            bug.project.objectWillChange.send()
            store.save()
        }){
            Label(bug.fixed ? "Mark as Bugged" : "Mark as Fixed", systemImage: "ant")
            //Right now it's not switching them right away, but it does change once you leave the view and come back.
        }
        .tint(bug.fixed ? .red : .green)
        Button(action: {
            showDetailEditSheet = true
        }){
            Label("Edit Details", systemImage: "pencil")
        }
    }
}

struct BugCellView_Previews : PreviewProvider {

    static var previews: some View {
        BugCellView(bug: Bug.preview)
            .previewLayout(.sizeThatFits)
    }
}
