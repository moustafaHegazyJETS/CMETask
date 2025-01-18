//
//  LocationManager.swift
//  CountriesCMETask
//
//  Created by Moustafa Hegazy on 17/01/2025.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

	@Published var lastKnownLocation: CLLocationCoordinate2D?
	@Published var lastKnownCountryLocation: String?
	@Published var locationEnabled: Bool = false
	var manager = CLLocationManager()


	func checkLocationAuthorization() {

		manager.delegate = self
		manager.startUpdatingLocation()

		switch manager.authorizationStatus {
		case .notDetermined://The user choose allow or denny your app to get the location yet
			manager.requestWhenInUseAuthorization()
			locationEnabled = false
			
		case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
			print("Location authorizedAlways")
			locationEnabled = true

		case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
			print("Location authorized when in use")
			lastKnownLocation = manager.location?.coordinate
			locationEnabled = true

		default:
			print("Location service disabled")
			locationEnabled = false

		}
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
		checkLocationAuthorization()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		lastKnownLocation = locations.first?.coordinate
	}

	func getLocationCountry(completion: @escaping (String) -> Void) {
		let location = CLLocation(
			latitude: manager.location?.coordinate.latitude ?? 29.9602,
			longitude: manager.location?.coordinate.longitude ?? 31.2569
		)

		location.fetchCityAndCountry { city, country, error in
			guard let city = city, let country = country, error == nil else { return }
			self.lastKnownCountryLocation = country
			completion(country)
		}

	}
}

extension CLLocation {
	func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
		CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
	}
}
