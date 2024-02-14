//
//  TracerTests.swift
//  TracerTests
//
//  Created by Todd Gibbons on 2/9/24.
//

import XCTest
@testable import Tracer

final class TracerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// Determine if any of the `sequenceTemplates` are too difficult to generate in the allotted `attemptsToGiveSubSequenceGenerator`.
    func testSequenceGenerationForTemplates() {
        let forbiddenStartingLoc = GridLoc(x: 1, y: 1) // Example starting loc
        for template in sequenceTemplates {
            let generator = GridLocSequenceGenerator(forbiddenStartingLoc: GridLoc.zero, template: template)
            let sequence = generator.generatedSequence
            XCTAssertNotNil(sequence, "Sequence should be generated successfully for template \(template)")
        }
    }
}
