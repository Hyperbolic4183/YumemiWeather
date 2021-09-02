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
    var weatherViewControllerMock: WeatherViewControllerMock!
    
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        
        fetcherMock = FetcherMock(weather: .sunny)
        weatherViewControllerMock = WeatherViewControllerMock(model: fetcherMock)
        weatherViewControllerMock.model.fetch()
        
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "sunny"))
    }
    
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {

        fetcherMock = FetcherMock(weather: .cloudy)
        weatherViewControllerMock = WeatherViewControllerMock(model: fetcherMock)
        weatherViewControllerMock.model.fetch()
        
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "cloudy"))
    }

    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        fetcherMock = FetcherMock(weather: .rainy)
        weatherViewControllerMock = WeatherViewControllerMock(model: fetcherMock)
        weatherViewControllerMock.model.fetch()
        
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "rainy"))
    }

    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        fetcherMock = FetcherMock(maxTemperature: testMaxTemperature)
        weatherViewControllerMock = WeatherViewControllerMock(model: fetcherMock)
        weatherViewControllerMock.model.fetch()
        
        let maxTemperature = self.getMaxTemperatureLabel(from: weatherViewControllerMock.view)
       
        XCTAssertEqual(testMaxTemperature, maxTemperature.text)
    }

    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "-40"
        fetcherMock = FetcherMock(maxTemperature: testMinTemperature)
        weatherViewControllerMock = WeatherViewControllerMock(model: fetcherMock)
        weatherViewControllerMock.model.fetch()
        
        let minTemperature = self.getMaxTemperatureLabel(from: weatherViewControllerMock.view)
       
        XCTAssertEqual(testMinTemperature, minTemperature.text)
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

class WeatherViewControllerMock: FetchableDelegate {
    
    private(set) var model: Fetchable
    private(set) var view = WeatherView()
    
    init(model: Fetchable) {
        self.model = model
        self.model.delegate = self
    }
    
    func fetch(_ fetchable: Fetchable?, didFetch information: WeatherInformation) {
        view.changeDisplay(WeatherViewState(information: information))
    }
    
    func fetch(_ fetchable: Fetchable?, didFailWithError error: WeatherAppError) {
        
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
