//
//  WeatherViewControllerMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/03.
//

import XCTest
@testable import Yumemi_ios_training

class WeatherViewControllerMock: WeatherViewControllerProtocol {
    //MARK:- WeatherViewControllerProtocol
    var weatherView: WeatherViewProtocol
    var weatherModel: Fetchable
    
    func handle(_ error: WeatherAppError) {
        expectation?.fulfill()
    }
    
    var expectation: XCTestExpectation?
    
    init(view: WeatherViewProtocol, model: Fetchable) {
        self.weatherView = view
        self.weatherModel = model
    }
    
    init(view: WeatherViewProtocol, model: Fetchable, expectation: XCTestExpectation) {
        self.weatherView = view
        self.weatherModel = model
        self.expectation = expectation
    }
    
    //MARK:- WeatherViewDelegate
    func didTapReloadButton(_ view: WeatherView) {}
    
    func didTapCloseButton(_ view: WeatherView) {}
    
    //MARK:- FetchableDelegate
    func fetch(_ fetchable: Fetchable?, didFetch information: WeatherInformation) {
        weatherView.weatherViewState = WeatherViewState(information: information)
    }
    
    func fetch(_ fetchable: Fetchable?, didFailWithError error: WeatherAppError) {
        handle(error)
    }
    
    
}
