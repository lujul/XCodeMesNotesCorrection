//
//  MarkTests.swift
//  MesNotes
//
//  Created by Maxime Britto on 24/11/2016.
//  Copyright © 2016 mbritto. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MesNotes

class MarkTests: XCTestCase {
    var mark:Mark!
    var realm:Realm!
    
    override func setUp() {
        super.setUp()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mark = Mark()
        try! realm.write {
            realm.add(mark)
        }

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetValue() {
        XCTAssertEqual(mark.getValue(), 0)
        mark.setValue(newValue: 10.5)
        XCTAssertEqual(mark.getValue(), 10.5)
        mark.setValue(newValue: -10)
        XCTAssertEqual(mark.getValue(), 10.5)
        mark.setValue(newValue: 0)
        XCTAssertEqual(mark.getValue(), 0)
        
    }
    
    func testSetCoeff() {
        XCTAssertEqual(1, mark.getCoeff())
        mark.setCoeff(newCoeff: 2)
        XCTAssertEqual(2, mark.getCoeff())
        mark.setCoeff(newCoeff: -2)
        XCTAssertEqual(2, mark.getCoeff())
        mark.setCoeff(newCoeff: 0)
        XCTAssertEqual(2, mark.getCoeff())
        mark.setCoeff(newCoeff: 1)
        XCTAssertEqual(1, mark.getCoeff())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
