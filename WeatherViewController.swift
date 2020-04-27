//
//  ViewController.swift
//  WeatherApplication
//
//  Created by val on 23/4/20.
//  Copyright © 2020 Munis Adilov. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let networkManager = NetworkManager()
    var weatherModel: WeatherModel?
    
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
    }
    
    @IBAction func nextScreenTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCity", sender: self)
    }
    
    func receivedCityName(city: String) {
        networkManager.getWeatherDataByCity(city: city) { (result) in
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                DispatchQueue.main.async {
                    self.updateWeatherInfo(info: weatherModel)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.fadeInAndOutAnimation(view: self.wrongLabel)
                }
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCity" {
            guard let destinationVc = segue.destination as? CityViewController else { return }
            destinationVc.weatherViewController = self
        }
    }
    
    func fadeInAndOutAnimation(view: UILabel) {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/16, animations: {
                view.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 7/8, relativeDuration: 1/16, animations: {
                view.layer.opacity = 0
            })
        }, completion: nil)
    }
    
    func setupViews() {
        wrongLabel.layer.opacity = 0
        conditionIcon.image = UIImage(named: "Cloud-Refresh")
        tempLabel.text = "--℃"
        cityLabel.text = "Updating..."
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func updateWeatherInfo(info: WeatherModel) {
        tempLabel.text = Int(info.main.temp).description + "℃"
        cityLabel.text = info.name
        conditionIcon.image = UIImage(named: weatherModel?.updateWeatherIcon(condition: info.weather[0].id) ?? "")
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            networkManager.getWeatherData(lat: latitude, lon: longitude) { (result) in
                switch result {
                case .success(let weatherModel):
                    self.weatherModel = weatherModel
                    DispatchQueue.main.async {
                        self.updateWeatherInfo(info: weatherModel)
                    }
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    
}

