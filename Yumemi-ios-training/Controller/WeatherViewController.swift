//
//  ViewController.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/04/30.
//

import UIKit

class WeatherViewController: UIViewController {

    private let weatherView: WeatherView
    private var weatherModel: Fetchable
    private var mainQueueScheduler: MainQueueScheduler
    private var errorHandler: ErrorHandler
    
    init(view: WeatherView = .init(), model: Fetchable, queueScheduler: MainQueueScheduler = .live, errorHandler: ErrorHandler = .presentAlertViewController) {
        self.weatherView = view
        self.weatherModel = model
        self.mainQueueScheduler = queueScheduler
        self.errorHandler = errorHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("WeatherViewController released")
    }
    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherView.delegate = self
        weatherModel.delegate = self
    }
    
    @objc func reload() {
        weatherView.switchView()
        weatherModel.fetch()
    }
}

// MARK:- WeatherViewDelegate
extension WeatherViewController: WeatherViewDelegate {
    
    func didTapReloadButton(_ view: WeatherView) {
        reload()
    }

    func didTapCloseButton(_ view: WeatherView) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- FetcherDelegate
extension WeatherViewController: FetchableDelegate {
    
    func fetch(_ fetcher: Fetchable?, didFetch information: WeatherInformation) {
        mainQueueScheduler.schedule {
            self.weatherView.changeView(for: .init(information: information))
            self.weatherView.switchView()
        }
    }
    
    func fetch(_ fetcher: Fetchable?, didFailWithError error: WeatherAppError) {
        mainQueueScheduler.schedule {
            self.errorHandler.handle(self, error)
            self.weatherView.switchView()
        }
    }
}
