//
//  Fetchable.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/06/18.
//
import Foundation

protocol FetchableDelegate: AnyObject {
    func fetch(_ fetchable: Fetchable?, didFetch information: WeatherInformation)
    func fetch(_ fetchable: Fetchable?, didFailWithError error: WeatherAppError)
}

protocol Fetchable {
    func fetch(completion: @escaping (_ result: Result<WeatherInformation, WeatherAppError>) -> Void)
}
