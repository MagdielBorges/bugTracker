//
//  BugDetailEditView.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import SwiftUI

struct BugDetailEditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store : StorageProvider
    @ObservedObject var bug: Bug
    @State private var title : String
    @State private var detail : String
    @State private var highPriority : Bool
    enum Field {
        case title, detail
    }
    @FocusState private var focusState: Field?
    enum ActiveAlert {
        case titleWarning, deletionWarning
    }
    @State private var showingWarning = false
    @State private var activeAlert : ActiveAlert = .titleWarning
    init(bug: Bug){
        self.bug = bug
        _title = State(initialValue: bug.title)
        _detail = State(initialValue: bug.detail)
        _highPriority = State(initialValue: bug.highPriority)
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Bug Title", text: $title)
                        .focused($focusState, equals: .title)
                    ZStack(alignment: .topLeading){
                        Text(detail).opacity(0).padding(8)
                        TextEditor(text: $detail)
                            .focused($focusState, equals: .detail)
                        if detail.isEmpty {
                            Text("Bug Details")
                                .foregroundColor(.secondary)
                                .padding(8)
                                .onTapGesture {
                                    focusState = .detail
                                }
                        }
                    }
                }
                Section {
                    Toggle(isOn: $highPriority) {
                        Text("High Priority Bug")
                    }
                }
                Section {
                    Button("Delete Bug", role: .destructive){
                        activeAlert = .deletionWarning
                        showingWarning = true
                    }
                }
            }
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .confirmationAction){
                    Button("Done"){
                        guard !title.isEmpty else {
                            activeAlert = .titleWarning
                            showingWarning = true
                            return
                        }
                        store.updateBug(bug, title: title, detail: detail, highPriority: highPriority)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel", role: .cancel){
                        dismiss()
                    }
                }
            }
            .alert(Text(alertTitle), isPresented: $showingWarning) {
                alertButtons
            } message : {
                Text(alertMessage)
            }
        }
    }
    var alertTitle: String {
        if activeAlert == .titleWarning {
            return "Cannot Save Changes"
        } else if activeAlert == .deletionWarning {
            return "Delete Bug?"
        }
        return ""
    }
    var alertMessage: String {
        if activeAlert == .titleWarning {
            return "A bug must have a title."
        } else if activeAlert == .deletionWarning {
            return "Are you sure you want to delete this bug? This cannot be undone."
        }
        return ""
    }
    @ViewBuilder
    var alertButtons: some View {
        if activeAlert == .titleWarning {
            Button("OK", role: .cancel){}
        } else if activeAlert == .deletionWarning {
            Button("Delete", role: .destructive){
                store.delete(bug)
                dismiss()
            }
            Button("Cancel", role: .cancel){}
        }
    }
}

struct BugDetailEditView_Previews: PreviewProvider {
    static var context = StorageProvider().persistentContainer.viewContext
    static var previews: some View {
        BugDetailEditView(bug: Bug.preview)
    }
}
