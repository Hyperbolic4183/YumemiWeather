//
//  Yumemi_ios_trainingTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/06/18.
//

import XCTest
@testable import Yumemi_ios_training

class Yumemi_ios_trainingTests: XCTestCase {
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        let view = WeatherView()
        let sunnyWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: "0")
        view.changeDisplay(WeatherViewState(information: sunnyWeatherInformation))
        XCTAssertEqual(view.weatherImageView.image, UIImage(named: "sunny"))
    }
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let view = WeatherView()
        let sunnyWeatherInformation = WeatherInformation(weather: .cloudy, minTemperature: "0", maxTemperature: "0")
        view.changeDisplay(WeatherViewState(information: sunnyWeatherInformation))
        XCTAssertEqual(view.weatherImageView.image, UIImage(named: "cloudy"))
    }
    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let view = WeatherView()
        let sunnyWeatherInformation = WeatherInformation(weather: .rainy, minTemperature: "0", maxTemperature: "0")
        view.changeDisplay(WeatherViewState(information: sunnyWeatherInformation))
        XCTAssertEqual(view.weatherImageView.image, UIImage(named: "rainy"))
    }
    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        let view = WeatherView()
        let minTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: testMaxTemperature)
        view.changeDisplay(WeatherViewState(information: minTemperatureWeatherInformation))
        XCTAssertEqual(view.maxTemperatureLabel.text, testMaxTemperature)
    }
    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "-40"
        let view = WeatherView()
        let minTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: "0")
        view.changeDisplay(WeatherViewState(information: minTemperatureWeatherInformation))
        XCTAssertEqual(view.minTemperatureLabel.text, testMinTemperature)
    }
}
