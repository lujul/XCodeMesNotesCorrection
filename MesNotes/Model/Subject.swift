//
//  Subject.swift
//  MesNotes
//
//  Created by Maxime Britto on 24/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object {
    private dynamic var title:String = ""
    private let markList = List<Mark>()
    
    public func getTitle() -> String {
        return title
    }
    
    public func setTitle(newTitle:String) {
        if newTitle.characters.count > 0 {
            realm?.beginWrite()
            self.title = newTitle
            try! realm?.commitWrite()
        }
    }
    
    public func getAverage() -> Float? {
        let average:Float?
        if getMarkCount() > 0 {
            var somme:Float = 0
            var coeffSum:Float = 0
            for mark in markList {
                let coeff:Float = Float(mark.getCoeff())
                somme = somme + (mark.getValue() * coeff)
                coeffSum = coeffSum + coeff
            }
            average = somme / coeffSum
        } else {
            average = nil
        }
        return average
    }
    
    public func getMark(atIndex index:Int) -> Mark? {
        let mark:Mark?
        if index >= 0 && index < markList.count {
            mark = markList[index]
        } else {
            mark = nil
        }
        return mark
    }
    
    public func getMarkCount() -> Int {
        return markList.count
    }
    
    public func addMark(value:Float, coeff:Int) {
        if value >= 0 && coeff > 0 {
            let mark = Mark()
            mark.setValue(newValue: value)
            mark.setCoeff(newCoeff: coeff)
            realm?.beginWrite()
            markList.append(mark)
            try! realm?.commitWrite()
        }
    }
    
    public func removeAllMarks() {
        if let r = realm {
            try! r.write {
                r.delete(markList)
            }
        } else {
            markList.removeAll()
        }
    }
    
    public func delete() {
        removeAllMarks()
        if let r = realm {
            try! r.write {
                r.delete(self)
            }
        }
    }
}
