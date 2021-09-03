//
//  WeatherViewControllerMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/03.
//

import XCTest
import Foundation
@testable import Yumemi_ios_training

class WeatherViewControllerMock: FetchableDelegate {
    
    var model: Fetchable?
    private(set) var view = WeatherView()
    
    func fetch(_ fetchable: Fetchable?, didFetch information: WeatherInformation) {
        view.changeDisplay(WeatherViewState(information: information))
    }
    
    func fetch(_ fetchable: Fetchable?, didFailWithError error: WeatherAppError) {
        XCTestExpectation.expectationOfError.fulfill()
    }
}
