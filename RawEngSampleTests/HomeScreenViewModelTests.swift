//
//  HomeScreenViewModelTests.swift
//  RawEngSampleTests
//
//  Created by Aryan Sharma on 31/10/24.
//

import XCTest
@testable import RawEngSample

final class HomeScreenViewModelTests: XCTestCase {

    var viewModel: HomeScreenViewModel?
    
    override func setUpWithError() throws {
        viewModel = HomeScreenViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_Deinit_isCalled() throws {
        // given
        
        
        // when
        //self.viewModel = nil
        
        // then
        //XCTAssertNil(vm)
    }
    
    func testSetupSubscription() throws {
        // given
        guard let vm = self.viewModel else {
            XCTFail()
            return
        }
        vm.setup()
        
        // when
        vm.setup()
        
        // then
        //XCTAssertNil(vm)
    }
    
    func testReceiveNotification() throws {
        // given
        guard let vm = self.viewModel else {
            XCTFail()
            return
        }
        vm.setup()
        
        // when
        NotificationCenter.default.post(name: .teamsDidUpdate, object: nil)
        
        // then
        //XCTAssertNil(vm)
    }
}
