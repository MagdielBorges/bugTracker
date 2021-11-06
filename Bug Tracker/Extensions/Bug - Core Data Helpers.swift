//
//  Bug - Core Data Helpers.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import Foundation

extension Bug {
    var title : String {
        get { title_ ?? "" }
        set { title_ = newValue
            save()
        }
    }
    var detail : String {
        get { detail_ ?? "" }
        set { detail_ = newValue
            save()
        }
    }
    var creationDate: Date {
        get { creationDate_ ?? Date() }
        set { creationDate_ = newValue
            save()
        }
    }
    
    var project: Project {
        get { project_! }
        set { project_ = newValue
            save()
        }
    }
    
    func save(){
        if let context = managedObjectContext, context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Save failed due to an error: \(error)")
            }
        }
    }
    
    static var preview : Bug {
        let context = StorageProvider().persistentContainer.viewContext
        let bug = Bug(context: context)
        bug.title = "Preview Bug"
        bug.project = Project(context: context)
        bug.detail = "A bug for previews."
        bug.highPriority = false
        bug.creationDate = Date()
        bug.fixed = false
        return bug
    }
}
