//
//  SubjectManager.swift
//  MesNotes
//
//  Created by Maxime Britto on 25/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import Foundation
import RealmSwift

class SubjectManager {
    private let _subjectList:Results<Subject>
    private let _realm:Realm
    
    var subjectList:Results<Subject> {
        return _subjectList
    }
    
    init(withRealm realm:Realm) {
        _realm = realm
        _subjectList = _realm.objects(Subject.self).sorted(byProperty: "title", ascending: false)
    }
    
    func getIndex(forSubject subject:Subject) -> Int? {
        return _subjectList.index(of: subject)
    }
    
    func getSubjectCount() -> Int {
        return _subjectList.count
    }
    
    func getSubject(atIndex index:Int) -> Subject? {
        var subject:Subject?
        if index >= 0 && index < getSubjectCount() {
            subject = _subjectList[index]
        }
        return subject
    }
    
    func addSubject(_ subject:Subject?) {
        guard let s = subject else {
            return
        }
        try! _realm.write {
            _realm.add(s)
        }
    }
    
    func addSubject(withTitle title:String) -> Subject? {
        guard title != "" else {
            return nil
        }
        let subject:Subject?
        let existingSubjectList = _realm.objects(Subject.self).filter("title = %@",title)
        
        if let existingSubject = existingSubjectList.first {
            subject = existingSubject
        } else {
            let newSubject = Subject()
            newSubject.setTitle(newTitle: title)
            try! _realm.write {
                _realm.add(newSubject)
            }
            subject = newSubject
        }
        return subject
    }
    
    func deleteSubject(atIndex index:Int) {
        if let subject = getSubject(atIndex: index) {
            try! _realm.write {
                _realm.delete(subject)
            }
        }
    }
}
