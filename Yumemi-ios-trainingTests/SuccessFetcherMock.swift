//
//  SuccessFetcherMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/03.
//

import Foundation
@testable import Yumemi_ios_training

class SuccessFetcherMock: Fetchable {
    
    var delegate: FetchableDelegate?
    let weatherInformation: WeatherInformation
    
    init(weatherInformation: WeatherInformation) {
        self.weatherInformation = weatherInformation
    }
    
    func fetch() {
        delegate?.fetch(self, didFetch: weatherInformation)
    }
    
}
