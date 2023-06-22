////
////  ViewController.swift
////  Map Storyboard
////
////  Created by DB-MM-011 on 20/06/23.
////
//
//
//import UIKit
//import MapKit
//import CoreLocation
//
//class ViewController: UIViewController {
//
//    var savedAddressViewController: SavedAddressViewController? // Connection between two controller files
//
//    @IBOutlet weak var mapViewOutlet: MKMapView!
//    @IBOutlet weak var textFieldOutlet: UITextField!
//    @IBOutlet weak var viewSavedButtonOutlet: UIButton! // Routing to new page
//    var addressEntity: CustomAddressEntity? // Address database model class
//
//    var viewModel: ViewModel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewModel = ViewModel()
//        textFieldOutlet.delegate = self
//
//        mapViewOutlet.delegate = self // Update the map
//        mapViewOutlet.showsUserLocation = true
//
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        mapViewOutlet.addGestureRecognizer(longPressGesture)
//
//        viewModel.startUpdatingLocation()
//    }
//
//    // MARK: Handle Longpress
//
//    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        viewModel.handleLongPress(gestureRecognizer: gestureRecognizer, mapView: mapViewOutlet)
//    }
//
//    // MARK: Save address DB button
//
//    @IBAction func saveAddressButtonOutletAction(_ sender: Any) { // Black save button
//        viewModel.saveAddressToDatabase(address: textFieldOutlet.text,
//                                        latitude: viewModel.locationManager.location?.coordinate.latitude,
//                                        longitude: viewModel.locationManager.location?.coordinate.longitude)
//    }
//
//    // MARK: Search City button
//
//    @IBAction func searchCityName(_ sender: Any) { // Search button to search city on the map
//        guard let cityName = textFieldOutlet.text else { return }
//        viewModel.updateMapWithCity(cityName, mapView: mapViewOutlet)
//        viewModel.showToast(message: "'\(cityName)' name Searched", font: .systemFont(ofSize: 14), onView: self.view)
//    }
//}
//
//extension ViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
//
//extension ViewController: MKMapViewDelegate {
//    // Add map view delegate methods here
//}



// MARK: SEGMENT


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    var savedAddressViewController: SavedAddressViewController? //connection between two controller files
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var mapViewOutlet: MKMapView!
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var ViewSavedButtonOutlet: UIButton!  //routing to new page

    var addressEntity: CustomAddressEntity? //address database model class

    var viewModel: ViewModel = ViewModel()
    
    // MARK: view did Load func
//     func viewLoadingFunction() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()  //request location permission to user
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.viewLoadingFunction()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  //request location permission to user
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapViewOutlet.delegate = self  //update the map
        mapViewOutlet.showsUserLocation = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapViewOutlet.addGestureRecognizer(longPressGesture)

    }
    // MARK: Handle Longpress
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapViewOutlet)
            let coordinate = mapViewOutlet.convert(touchPoint, toCoordinateFrom: mapViewOutlet)

            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Reverse geocoding failed with error: \(error.localizedDescription)")
                    return
                }
                if let placemark = placemarks?.first {
                    let address = placemark.name ?? "Unknown Address Name"
                    // Save the address, latitude, and longitude to the database
                    let addressEntity = AddressEntity(context: self.context)
                    addressEntity.address = address
                    addressEntity.lat = coordinate.latitude
                    addressEntity.long = coordinate.longitude
                    do {
                        try self.context.save()
                        print("Saved address: \(address), Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                    } catch {
                        print("Failed to save data to the database: \(error)")
                    }
                }
            }
        }
    }

    // MARK: Save address DB button
    @IBAction func SaveAddressButtonOutletAction(_ sender: Any) {  //black save button
        guard let address = textFieldOutlet.text,
              let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude
        else {
            return
        }
        let addressEntity = AddressEntity(context: context)
        addressEntity.address = address
        addressEntity.lat = latitude
        addressEntity.long = longitude

        do {
            try context.save()
            print("Saved address: \(address), Latitude: \(latitude), Longitude: \(longitude)")
            showToast(message: "'\(address)' Saved", font: .systemFont(ofSize: 14))

        } catch {
            print("Failed to save data to the database: \(error)")
        }
    }
    // MARK: Search City button
    @IBAction func searchCityName(_ sender: Any) {   //search button to search city in map
        guard let cityName = textFieldOutlet.text else { return }
        updateMapWithCity(cityName)
        showToast(message: "'\(cityName)' name Searched", font: .systemFont(ofSize: 14))
    }

    let locationManager = CLLocationManager()
    // MARK: Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapViewOutlet.setRegion(region, animated: true)

        let coordinate = location.coordinate

        // Print latitude and longitude
        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")

        // Reverse geocoding to get the city name
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    // Print city name
                    print("City: \(city)")
                    let locale = Locale.current
                    print(locale)
                }
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied or restricted authorization
            print("Location permission denied or restricted.")
        case .notDetermined:
            // Handle not determined authorization
            print("Location permission not determined.")
        @unknown default:
            break
        }
    }
    // MARK: Update Map city name
    func updateMapWithCity(_ cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                self.mapViewOutlet.setRegion(region, animated: true)

                // Clear existing annotations
                self.mapViewOutlet.removeAnnotations(self.mapViewOutlet.annotations)

                // Add new annotation for the city
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = cityName
                self.mapViewOutlet.addAnnotation(annotation)
            }
        }
    }

    // MARK: Toast function
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 180, height: 45))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}

//extension ViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

// textFieldOutlet.addFullBorder(color: .gray, width: 0.8,cornerRadius: 8.0)
