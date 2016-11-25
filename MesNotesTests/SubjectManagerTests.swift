//
//  SubjectManagerTests.swift
//  MesNotes
//
//  Created by Maxime Britto on 25/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MesNotes

class SubjectManagerTests: XCTestCase {
    var _subjectManager:SubjectManager!
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        _subjectManager = SubjectManager(withRealm: try! Realm())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSubject() {
        XCTAssertEqual(_subjectManager.getSubjectCount(), 0)
        XCTAssertNil(_subjectManager.addSubject(withTitle: ""))
        XCTAssertEqual(_subjectManager.getSubjectCount(), 0)
        XCTAssertNotNil(_subjectManager.addSubject(withTitle: "Matière 1"))
        XCTAssertEqual(_subjectManager.getSubjectCount(), 1)
        _subjectManager.addSubject(withTitle: "Matière 1")
        XCTAssertEqual(_subjectManager.getSubjectCount(), 1)
        _subjectManager.addSubject(withTitle: "Matière 2")
        XCTAssertEqual(_subjectManager.getSubjectCount(), 2)
    }
    
    func testDeleteSubject() {
        XCTAssertEqual(_subjectManager.getSubjectCount(), 0)
        _ = _subjectManager.addSubject(withTitle: "Matière 1")
        XCTAssertEqual(_subjectManager.getSubjectCount(), 1)
        _subjectManager.deleteSubject(atIndex: 1)
        XCTAssertEqual(_subjectManager.getSubjectCount(), 1)
        _subjectManager.deleteSubject(atIndex: -1)
        XCTAssertEqual(_subjectManager.getSubjectCount(), 1)
        _subjectManager.deleteSubject(atIndex: 0)
        XCTAssertEqual(_subjectManager.getSubjectCount(), 0)
    }
    
    func testGetSubject() {
        XCTAssertEqual(_subjectManager.getSubjectCount(), 0)
        let createdSubject = _subjectManager.addSubject(withTitle: "Matière 1")!
        let readSubject = _subjectManager.getSubject(atIndex: 0)
        XCTAssertNotNil(readSubject)
        XCTAssertEqual(createdSubject.getTitle(), readSubject!.getTitle())
        
        XCTAssertNil(_subjectManager.getSubject(atIndex: -1))
        XCTAssertNil(_subjectManager.getSubject(atIndex: 1))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
