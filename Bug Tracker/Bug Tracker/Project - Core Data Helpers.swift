//
//  Project - Core Data Helpers.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import Foundation

extension Project {
    var title : String {
        get { title_ ?? "" }
        set { title_ = newValue
           save()
        }
    }
    var creationDate : Date {
        get { creationDate_ ?? Date() }
        set { creationDate_ = newValue
            save()
        }
    }
    
    var bugs: Set<Bug> {
        get { bugs_ as? Set<Bug> ?? [] }
        set { bugs_ = newValue as NSSet }
    }
    
    var bugsSorted: [Bug] {
        return bugs.sorted { first, second in
            if first.fixed == false {
                if second.fixed == true {
                    return true
                }
            } else if first.fixed == true {
                if second.fixed == false {
                    return false
                }
            }

            if first.highPriority == true {
                if second.highPriority == false {
                    return true
                }
            } else if first.highPriority == false {
                if second.highPriority == true {
                    return false
                }
            }
            return first.creationDate < second.creationDate
        }
    }
    var unfixedBugs: [Bug] {
        return bugsSorted.filter { $0.fixed == false }
    }
    
    var unfixedBugCount: Int {
        return unfixedBugs.count
    }
    
    var fixedBugCount: Int {
        let fixedBugs = bugs.filter { $0.fixed == true }
        return fixedBugs.count
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
}
