//
//  BugCellView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/6/21.
//

import SwiftUI

struct BugCellView: View {
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
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                if bug.fixed == false {
                    Button("Mark as Fixed"){
                        bug.fixed = true
                        bug.project.objectWillChange.send()
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

struct BugCellView_Previews : PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        BugCellView(bug: Bug(context: context))
    }
}
