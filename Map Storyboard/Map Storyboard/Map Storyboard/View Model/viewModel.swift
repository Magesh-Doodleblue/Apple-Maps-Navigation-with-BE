import UIKit
import MapKit
import CoreLocation


class ViewModel: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    func viewLoadingFunction() {
       locationManager.delegate = self
       locationManager.requestWhenInUseAuthorization()  //request location permission to user
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.startUpdatingLocation()
       
//       mapViewOutlet.delegate = self  //update the map
//       mapViewOutlet.showsUserLocation = true
//       let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//       mapViewOutlet.addGestureRecognizer(longPressGesture)
   }
    
}

//class ViewModel: NSObject, CLLocationManagerDelegate {
//    
//    let locationManager = CLLocationManager()
//    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    func startUpdatingLocation() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization() // Request location permission from the user
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//    
//    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer, mapView: MKMapView) {
//        if gestureRecognizer.state == .began {
//            let touchPoint = gestureRecognizer.location(in: mapView)
//            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
//            
//            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            
//            let geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Reverse geocoding failed with error: \(error.localizedDescription)")
//                    return
//                }
//                if let placemark = placemarks?.first {
//                    let address = placemark.name ?? "Unknown Address Name"
//                    // Save the address, latitude, and longitude to the database
//                    let addressEntity = AddressEntity(context: self.context)
//                    addressEntity.address = address
//                    addressEntity.lat = coordinate.latitude
//                    addressEntity.long = coordinate.longitude
//                    do {
//                        try self.context.save()
//                        print("Saved address: \(address), Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
//                    } catch {
//                        print("Failed to save data to the database: \(error)")
//                    }
//                }
//            }
//        }
//    }
//    
//    func saveAddressToDatabase(address: String?, latitude: Double?, longitude: Double?) {
//        guard let address = address, let latitude = latitude, let longitude = longitude else {
//            return
//        }
//        
//        let addressEntity = AddressEntity(context: context)
//        addressEntity.address = address
//        addressEntity.lat = latitude
//        addressEntity.long = longitude
//        
//        do {
//            try context.save()
//            print("Saved address: \(address), Latitude: \(latitude), Longitude: \(longitude)")
//        } catch {
//            print("Failed to save data to the database: \(error)")
//        }
//    }
//
//    
//    func updateMapWithCity(_ cityName: String, mapView: MKMapView) {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
//            if let error = error {
//                print("Geocoding failed with error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let placemark = placemarks?.first, let location = placemark.location {
//                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//                mapView.setRegion(region, animated: true)
//                
//                // Clear existing annotations
//                mapView.removeAnnotations(mapView.annotations)
//                
//                // Add new annotation for the city
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location.coordinate
//                annotation.title = cityName
//                mapView.addAnnotation(annotation)
//            }
//        }
//    }
//    
//    func showToast(message: String, font: UIFont, onView: UIView) {
//        let toastLabel = UILabel(frame: CGRect(x: onView.frame.size.width/2 - 75, y: onView.frame.size.height-100, width: 180, height: 45))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 20;
//        toastLabel.clipsToBounds = true
//        onView.addSubview(toastLabel)
//        UIView.animate(withDuration: 3.0, delay: 0.5, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
//}
