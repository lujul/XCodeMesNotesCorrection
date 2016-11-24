//
//  MesNotesTests.swift
//  MesNotesTests
//
//  Created by Maxime Britto on 24/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MesNotes

class SubjectTests: XCTestCase {
    var subject:Subject!
    var realm:Realm!
    override func setUp() {
        super.setUp()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: self.name))
        
        subject = Subject()
        try! realm.write {
            realm.add(subject)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testSubjectTitle() {
        // This is an example of a functional test case.
        XCTAssertEqual(subject.getTitle(), "")
        subject.setTitle(newTitle: "Maths")
        XCTAssertEqual(subject.getTitle(), "Maths")
        subject.setTitle(newTitle: "")
        XCTAssertEqual(subject.getTitle(), "Maths")
        
    }
    
    func testMarkManagement() {
        XCTAssertEqual(subject.getMarkCount(), 0)
        subject.addMark(value: 10, coeff: 1)
        XCTAssertEqual(subject.getMarkCount(), 1)
        subject.addMark(value: -2, coeff: 1)
        XCTAssertEqual(subject.getMarkCount(), 1)
        subject.addMark(value: 14, coeff: 0)
        XCTAssertEqual(subject.getMarkCount(), 1)
        subject.addMark(value: 14, coeff: -1)
        XCTAssertEqual(subject.getMarkCount(), 1)
        
        subject.addMark(value: 20, coeff: 1)
        XCTAssertEqual(subject.getMarkCount(), 2)
        XCTAssertEqual(subject.getAverage(), 15)
        subject.addMark(value: 1, coeff: 2)
        XCTAssertEqual(subject.getAverage(), 8)
    }
    
    func testGetMark() {
        XCTAssertNil(subject.getMark(atIndex: 0))
        subject.addMark(value: 10, coeff: 2)
        let firstMark = subject.getMark(atIndex: 0)
        XCTAssertNotNil(firstMark)
        XCTAssertEqual(firstMark!.getValue(), 10)
        XCTAssertEqual(firstMark!.getCoeff(), 2)
        
        XCTAssertNil(subject.getMark(atIndex: -1))
        XCTAssertNil(subject.getMark(atIndex: 1))
        
        subject.addMark(value: 8, coeff: 2)
        XCTAssertNotNil(subject.getMark(atIndex: 1))
    }
    
    func testDeleteSubject() {
        XCTAssertEqual(1, realm.objects(Subject.self).count)
        XCTAssertEqual(0, realm.objects(Mark.self).count)
        subject.addMark(value: 10, coeff: 1)
        XCTAssertEqual(1, realm.objects(Mark.self).count)
        subject.delete()
        XCTAssertEqual(0, realm.objects(Subject.self).count)
        XCTAssertEqual(0, realm.objects(Mark.self).count)
    }
    
    func testEmptyMarkList() {
        XCTAssertNil(subject.getAverage())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
