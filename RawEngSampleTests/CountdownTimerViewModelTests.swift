//
//  CountdownTimerViewModelTests.swift
//  RawEngSampleTests
//
//  Created by Aryan Sharma on 04/11/24.
//

import XCTest
@testable import RawEngSample

final class CountdownTimerViewModelTests: XCTestCase {
    
    var sut: CountdownTimerViewModel!
    
    override func setUpWithError() throws {
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        sut = CountdownTimerViewModel(gameDate: futureDate)
    }

    override func tearDownWithError() throws {
       sut = nil
    }
    
    func test_updateRemainingTime_isCalledBeforeStartingTheTimer() throws {
        // given
        let emptyString = ""
        let expectation = expectation(description: "Timer values will not be empty")
        
        // when
        Task {
            try? await Task.sleep(for: .seconds(0.5))
            expectation.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1) { [weak self] error in
            if let error = error {
                XCTFail("Expectation failed with error: \(error)")
            }
            XCTAssertNotEqual(emptyString, self?.sut.remainingDays)
            XCTAssertNotEqual(emptyString, self?.sut.remainingHours)
            XCTAssertNotEqual(emptyString, self?.sut.remainingMinutes)
        }
    }
    
    func test_gameDate_ifLessThanCurrentDate_countdownIsReset() {
        // given
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        // when
        let sut = CountdownTimerViewModel(gameDate: pastDate)
    
        // then
        let countdownResetValue = "00"
        XCTAssertEqual(countdownResetValue, sut.remainingDays)
        XCTAssertEqual(countdownResetValue, sut.remainingHours)
        XCTAssertEqual(countdownResetValue, sut.remainingMinutes)
    }
}
