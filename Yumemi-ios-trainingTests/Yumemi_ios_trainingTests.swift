//
//  Yumemi_ios_trainingTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/06/18.
//

import XCTest
@testable import Yumemi_ios_training

class Yumemi_ios_trainingTests: XCTestCase {
    
    var fetcherMock: FetcherMock!
    var weatherViewController: WeatherViewController!
    let permissibleTime: TimeInterval = 4
    
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        
        fetcherMock = FetcherMock(weather: .sunny)
        weatherViewController = WeatherViewController(model: fetcherMock)

        let weatherView = weatherViewController.weatherView
        let reloadButton = getReloadButton(from: weatherView)
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        weatherViewController.viewDidLoad()
        addProcessing(target: reloadButton.sendActions(for: .touchUpInside)) {
            DispatchQueue.main.async {
                let weatherImage = self.getImage(from: weatherView)
                XCTAssertEqual(weatherImage,UIImage(named: "sunny"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: permissibleTime, handler: nil)
    }
    
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        
        fetcherMock = FetcherMock(weather: .cloudy)
        weatherViewController = WeatherViewController(model: fetcherMock)
        
        let weatherView = weatherViewController.weatherView
        let reloadButton = getReloadButton(from: weatherView)
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        weatherViewController.viewDidLoad()
        addProcessing(target: reloadButton.sendActions(for: .touchUpInside)) {
            DispatchQueue.main.async {
                let weatherImage = self.getImage(from: weatherView)
                XCTAssertEqual(weatherImage, UIImage(named: "cloudy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: permissibleTime, handler: nil)
    }
    
    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        fetcherMock = FetcherMock(weather: .rainy)
        weatherViewController = WeatherViewController(model: fetcherMock)
        
        let weatherView = weatherViewController.weatherView
        let reloadButton = getReloadButton(from: weatherView)
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        weatherViewController.viewDidLoad()
        addProcessing(target: reloadButton.sendActions(for: .touchUpInside)) {
            DispatchQueue.main.async {
                let weatherImage = self.getImage(from: weatherView)
                XCTAssertEqual(weatherImage, UIImage(named: "rainy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: permissibleTime, handler: nil)
    }
    
    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        fetcherMock = FetcherMock(maxTemperature: testMaxTemperature)
        weatherViewController = WeatherViewController(model: fetcherMock)
        
        let weatherView = weatherViewController.weatherView
        let reloadButton = getReloadButton(from: weatherView)
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        weatherViewController.viewDidLoad()
        addProcessing(target: reloadButton.sendActions(for: .touchUpInside)) {
            DispatchQueue.main.async {
                let maxTemperature = self.getMaxTemperatureLabel(from: weatherView)
                XCTAssertEqual(testMaxTemperature, maxTemperature.text)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: permissibleTime, handler: nil)
    }
    
    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "-40"
        fetcherMock = FetcherMock(maxTemperature: testMinTemperature)
        weatherViewController = WeatherViewController(model: fetcherMock)
        
        let weatherView = weatherViewController.weatherView
        let reloadButton = getReloadButton(from: weatherView)
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        weatherViewController.viewDidLoad()
        addProcessing(target: reloadButton.sendActions(for: .touchUpInside)) {
            DispatchQueue.main.async {
                let minTemperature = self.getMaxTemperatureLabel(from: weatherView)
                XCTAssertEqual(testMinTemperature, minTemperature.text)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: permissibleTime, handler: nil)
    }
    
    func addProcessing(target: Void,completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            target
            completion()
        }
    }
    
    private func getStackView(from view: UIView) -> UIStackView {
        view.subviews.first(where: { $0 is UIStackView})! as! UIStackView
    }
    
    private func getImage(from view: UIView) -> UIImage {
        //WeatherView含まれるstackViewForImageViewAndLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        
        let weatherImageView = stackViewForImageViewAndLabels.subviews.first(where: { $0 is UIImageView })! as! UIImageView
        return weatherImageView.image!
    }
    
    private func getMaxTemperatureLabel(from view: UIView) -> UILabel {
        //WeatherView含まれる2つのUIStackViewのうち、2番目に追加したstackViewForLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        //stackViewForImageViewAndLabelsに含まれるstackViewForLabelsを取得
        let stackViewForLabels = getStackView(from: stackViewForImageViewAndLabels)
        //stackViewForLabelsに2番目に追加したUILabelを取得
        let maxTemperatureLabel = stackViewForLabels.subviews[1] as! UILabel
        return maxTemperatureLabel
    }
    
    private func getMinTemperatureLabel(from view: UIView) -> UILabel {
        //WeatherView含まれるstackViewForImageViewAndLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        //stackViewForImageViewAndLabelsに含まれるstackViewForLabelsを取得
        let stackViewForLabels = getStackView(from: stackViewForImageViewAndLabels)
        //stackViewForLabelsに初めに追加したUILabelを取得
        let minTemperatureLabel = stackViewForLabels.subviews[0] as! UILabel
        return minTemperatureLabel
    }
    
    private func getReloadButton(from view: UIView) -> UIButton {
        view.subviews.filter({ type(of: $0) == UIButton.self }).map({ $0 as! UIButton })[1]
    }
}

class FetcherMock: Fetchable {
    
    var delegate: FetchableDelegate?
    
    let weather: WeatherInformation.Weather
    let minTemperature: String
    let maxTemperature: String
    let weatherInformation: WeatherInformation
    
    init(weather: WeatherInformation.Weather) {
        self.weather = weather
        self.minTemperature = "0"
        self.maxTemperature = "0"
        self.weatherInformation = WeatherInformation(weather: weather, minTemperature: minTemperature, maxTemperature: maxTemperature)
    }
    
    init(minTemperature: String) {
        self.weather = .sunny
        self.minTemperature = minTemperature
        self.maxTemperature = "0"
        self.weatherInformation = WeatherInformation(weather: weather, minTemperature: minTemperature, maxTemperature: maxTemperature)
    }
    
    init(maxTemperature: String) {
        self.weather = .sunny
        self.minTemperature = "0"
        self.maxTemperature = "0"
        self.weatherInformation = WeatherInformation(weather: weather, minTemperature: minTemperature, maxTemperature: maxTemperature)
    }
    
    func fetch() {
        delegate?.fetch(self, didFetch: weatherInformation)
    }
    
}
