//
//  WeatherModel.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/05/12.
//

import YumemiWeather

struct WeatherDataSource {
    func reload() -> String  {
        YumemiWeather.fetchWeather()
    }
}