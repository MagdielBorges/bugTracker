//
//  Create Entities.swift
//  Bug Tracker
//
//  Created by Magdiel Borges on 11/4/21.
//

import Foundation

extension StorageProvider {
    func newProject(title: String, showFixedBugs: Bool) {
        let project = Project(context: persistentContainer.viewContext)
        project.title = title
        project.creationDate = Date()
        project.active = true
        project.showFixedBugs = showFixedBugs
        project.bugs = []
        save()
    }
    
    func updateProject(_ project: Project, title: String, active: Bool, showFixedBugs: Bool) {
        project.title = title
        project.active = active
        project.showFixedBugs = showFixedBugs
        save()
    }
}

extension StorageProvider {
    func newBug(in project: Project, title: String, detail: String, highPriority: Bool){
        let bug = Bug(context: persistentContainer.viewContext)
        bug.title = title
        bug.detail = detail
        bug.creationDate = Date()
        bug.fixed = false
        bug.highPriority = highPriority
        bug.project = project
        save()
    }
    
    func updateBug(_ bug: Bug, title: String, detail: String, highPriority: Bool){
        bug.title = title
        bug.detail = detail
        bug.highPriority = highPriority
        save()
    }
}
