//
//  WeatherView.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/04/30.
//

import UIKit


protocol WeatherViewDelegate: AnyObject {
    func didTapReloadButton(_ view: WeatherView)
    func didTapCloseButton(_ view: WeatherView)
}

final class WeatherView: UIView {
    
    weak var delegate: WeatherViewDelegate?
    
    private let stackViewForImageViewAndLabels = UIStackView()
    private let weatherImageView = UIImageView()
    private let stackViewForLabels = UIStackView()
    private let minTemperatureLabel = UILabel()
    private let maxTemperatureLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let reloadButton = UIButton(type: .system)
    private let indicator = UIActivityIndicatorView()
    private let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
        addSubviewConstraints()
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupStackViewForImageViewAndLabels()
        setupStackViewForLabels()
        setupLowestTemperatureLabel()
        setupHighestTemperatureLabel()
        setupCloseButton()
        setupReloadButton()
        setupLoadingView()
        setupWeatherImage()
    }
    
    private func addSubviewConstraints() {
        //天気を表示するimageViewと気温を表示するlabelを入れるためのStackViewの追加と制約
        addSubview(stackViewForImageViewAndLabels)
        stackViewForImageViewAndLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewForImageViewAndLabels.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackViewForImageViewAndLabels.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        //天気を表示するimageViewの追加と制約
        stackViewForImageViewAndLabels.addArrangedSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            weatherImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
        //最低/最高気温を表示するlabelの追加と制約
        addSubview(stackViewForLabels)
        stackViewForLabels.addArrangedSubview(minTemperatureLabel)
        stackViewForLabels.addArrangedSubview(maxTemperatureLabel)
        stackViewForImageViewAndLabels.addArrangedSubview(stackViewForLabels)
        //close/reloadボタンの追加と制約
        addSubview(closeButton)
        addSubview(reloadButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.centerXAnchor.constraint(equalTo: minTemperatureLabel.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: stackViewForImageViewAndLabels.bottomAnchor, constant: 80),
            reloadButton.centerXAnchor.constraint(equalTo: maxTemperatureLabel.centerXAnchor),
            reloadButton.topAnchor.constraint(equalTo: stackViewForLabels.bottomAnchor, constant: 80)
        ])
        //indicatorの追加と制約
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: stackViewForImageViewAndLabels.bottomAnchor, constant: 40)
        ])
    }
    
    private func setupWeatherImage() {
            weatherImageView.image = UIImage()
        }
    
    private func setupStackViewForImageViewAndLabels() {
        stackViewForImageViewAndLabels.axis = .vertical
        stackViewForImageViewAndLabels.alignment = .fill
        stackViewForImageViewAndLabels.distribution = .fill
    }
    
    private func setupStackViewForLabels() {
        stackViewForLabels.axis = .horizontal
        stackViewForLabels.alignment = .fill
        stackViewForLabels.distribution = .fillEqually
    }
    
    private func setupLowestTemperatureLabel() {
        minTemperatureLabel.text = "--"
        minTemperatureLabel.textColor = .systemBlue
        minTemperatureLabel.textAlignment = .center
    }
    
    private func setupHighestTemperatureLabel() {
        maxTemperatureLabel.text = "--"
        maxTemperatureLabel.textColor = .systemRed
        maxTemperatureLabel.textAlignment = .center
    }
    
    private func setupCloseButton() {
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)
    }
    
    private func setupReloadButton() {
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        reloadButton.setTitle("Reload", for: .normal)
    }
    
    private func setupLoadingView() {
        loadingView.alpha = 0.2
        loadingView.backgroundColor = .black
    }
    
    private func switchIndicatorAnimation() {
        if indicator.isAnimating {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
    }
    
    private func switchLoadingView() {
        if loadingView.isDescendant(of: self) {
            loadingView.removeFromSuperview()
        } else {
            addSubview(loadingView)
        }
    }
    
    func changeView(for weatherViewState: WeatherViewState) {
        self.minTemperatureLabel.text = weatherViewState.minTemperature
        self.maxTemperatureLabel.text = weatherViewState.maxTemperature
        self.weatherImageView.image = weatherViewState.weather
        self.weatherImageView.tintColor = weatherViewState.color
    }
    
    func switchView() {
        switchIndicatorAnimation()
        switchLoadingView()
    }
    
    @objc private func reload() {
        delegate?.didTapReloadButton(self)
    }
    
    @objc private func dismiss() {
        delegate?.didTapCloseButton(self)
    }
}

