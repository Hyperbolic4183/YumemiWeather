//
//  Testable.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/06/18.
//
import Foundation
protocol Testable {
    func fetchYumemiWeather() -> Result<WeatherInformation, WeatherAppError>
}