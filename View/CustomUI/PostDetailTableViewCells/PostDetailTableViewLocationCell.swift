//
//  PostDetailTableViewLocationCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import MapKit
import CoreLocation

class PostDetailTableViewLocationCell: UITableViewCell {
    
    @IBOutlet var departurePlaceView : UILabel!
    @IBOutlet var destionationView : UILabel!
    @IBOutlet var navigationView : MKMapView!
    @IBOutlet var starPositionShadowView : UIView!
    @IBOutlet var destinationPositionShadowView : UIView!
    @IBOutlet var navigationShadowView : UIView!
    @IBOutlet var destionationIcon : UIImageView!
    @IBOutlet var starPositionIcon : UIImageView!
    var starPosition = ""
    var destinationPosition = ""
    
    var locationManager = CLLocationManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    static let identifier = "PostDetailTableViewLocationCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewLocationCell", bundle: nil)
    }
    
    public func configure( with departurePlace : String , with destination : String, with transportationType : Transportation, with frameWidth : CGFloat, with frameHeight : CGFloat) {
        
        self.starPosition = departurePlace.components(separatedBy: .newlines).joined(separator: ", ")
        self.destinationPosition = destination.components(separatedBy: .newlines).joined(separator: ", ")
        
        self.selectionStyle = .none
        
        self.navigationView.layer.cornerRadius = 10
        self.navigationView.clipsToBounds = true
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.navigationShadowView.layer.shadowColor = UIColor.gray.cgColor
        self.navigationShadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.navigationShadowView.layer.shadowOpacity = 0.8
        self.navigationShadowView.layer.masksToBounds = false
        self.navigationShadowView.layer.cornerRadius = 10
        
        self.starPositionShadowView.layer.shadowColor = UIColor.gray.cgColor
        self.starPositionShadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.starPositionShadowView.layer.shadowOpacity = 0.8
        self.starPositionShadowView.layer.masksToBounds = false
        self.starPositionShadowView.layer.cornerRadius = 10
        
        self.starPositionShadowView.layer.zPosition = -2
        self.starPositionShadowView.backgroundColor = UIColor(named: "bgDarkBlue")
        self.starPositionShadowView.alpha = 0.8
        
        self.destinationPositionShadowView.layer.shadowColor = UIColor.gray.cgColor
        self.destinationPositionShadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.destinationPositionShadowView.layer.shadowOpacity = 0.8
        self.destinationPositionShadowView.layer.masksToBounds = false
        self.destinationPositionShadowView.layer.cornerRadius = 10
        
        self.destinationPositionShadowView.layer.zPosition = -2
        self.destinationPositionShadowView.backgroundColor = UIColor(named: "bgDarkBlue")
        self.destinationPositionShadowView.alpha = 0.8
        
        self.departurePlaceView.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.departurePlaceView.numberOfLines = 0
        self.departurePlaceView.text = "From: \n" + departurePlace.components(separatedBy: .newlines).joined(separator: ", ")
        self.departurePlaceView.textColor = .white
        
        //set touchable
        let departurePlaceGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchAppleMapWithDeparturePosition(_:)))
        departurePlaceGestureRecognizer.numberOfTapsRequired = 1
        departurePlaceGestureRecognizer.numberOfTouchesRequired = 1
        self.departurePlaceView.addGestureRecognizer(departurePlaceGestureRecognizer)
        self.departurePlaceView.isUserInteractionEnabled = true
        
        self.starPositionIcon.layer.cornerRadius = 15
        self.starPositionIcon.clipsToBounds = true
        self.starPositionIcon.backgroundColor = .white
        self.starPositionIcon.alpha = 1
        
        self.destionationView.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.destionationView.numberOfLines = 0
        self.destionationView.text = "To: \n" + destination.components(separatedBy: .newlines).joined(separator: ", ")
        self.destionationView.textColor = .white
        
        //set touchable
        let destinationGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchAppleMapWithDestinationPosition(_:)))
        destinationGestureRecognizer.numberOfTapsRequired = 1
        destinationGestureRecognizer.numberOfTouchesRequired = 1
        self.destionationView.addGestureRecognizer(destinationGestureRecognizer)
        self.destionationView.isUserInteractionEnabled = true
        
        self.destionationIcon.layer.cornerRadius = 15
        self.destionationIcon.clipsToBounds = true
        self.destionationIcon.backgroundColor = .white
        self.destionationIcon.alpha = 1
        
        // set up mapview
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        navigationView.delegate = self
        
        let geoCoder = CLGeocoder()
        guard departurePlace.count != 0 else { return }
        guard destination.count != 0 else { return }
        
        geoCoder.geocodeAddressString(departurePlace, completionHandler: {
            (placeMarks, error) in
            guard let placeMarks = placeMarks,
                  let departure = placeMarks.first?.location
            else {
                // Error Message
                print("Departure Location Not Found")
                return
            }
            
            geoCoder.geocodeAddressString(destination, completionHandler: {
                (placeMarks, error) in
                guard let placeMarks = placeMarks,
                      let destination = placeMarks.first?.location
                else {
                    // Error Message
                    print("Destination Location Not Found")
                    return
                }
                
                self.route(departureCord: departure.coordinate, destinationCord: destination.coordinate, transportationType: transportationType)
                
                
                
            })
        })
        
    }
    
    @objc func launchAppleMapWithDeparturePosition(_ gesture: UITapGestureRecognizer) {
        CLGeocoder().geocodeAddressString(self.starPosition) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else { return }
            MKMapItem(placemark: MKPlacemark(placemark: placemark)).openInMaps()
        }
    }
    
    @objc func launchAppleMapWithDestinationPosition(_ gesture: UITapGestureRecognizer) {
        CLGeocoder().geocodeAddressString(self.destinationPosition) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.first else { return }
            MKMapItem(placemark: MKPlacemark(placemark: placemark)).openInMaps()
        }
    }
    
    func route(departureCord: CLLocationCoordinate2D, destinationCord: CLLocationCoordinate2D, transportationType: Transportation) {
        
        guard let sourceCord = locationManager.location?.coordinate else { return }
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCord)
        let departurePlaceMark = MKPlacemark(coordinate: departureCord)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let departureItem = MKMapItem(placemark: departurePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        // draw from place right now to departure place
        let fromSourceToDepartureDirectionRequest = MKDirections.Request()
        fromSourceToDepartureDirectionRequest.source = sourceItem
        fromSourceToDepartureDirectionRequest.destination = departureItem
        switch transportationType {
        case .car:
            fromSourceToDepartureDirectionRequest.transportType = .automobile
        case .walk:
            fromSourceToDepartureDirectionRequest.transportType = .walking
        case .tram:
            fromSourceToDepartureDirectionRequest.transportType = .transit
        case .bike:
            fromSourceToDepartureDirectionRequest.transportType = .walking
        case .taxi:
            fromSourceToDepartureDirectionRequest.transportType = .automobile
        }
        
        fromSourceToDepartureDirectionRequest.requestsAlternateRoutes = true
        
        let routeFromSourceToDeparture = MKDirections(request: fromSourceToDepartureDirectionRequest)
        routeFromSourceToDeparture.calculate(completionHandler: {
            (response, error) in
            guard let response = response, error == nil else {
                print("route from source to departure failed")
                return
            }
            
            let routePath = response.routes[0]
            self.navigationView.addOverlay(routePath.polyline)
            self.navigationView.setVisibleMapRect(routePath.polyline.boundingMapRect, animated: true)
            
            // draw from departure to destination
            
            let fromDepartureToDestinationDirectionRequest = MKDirections.Request()
            fromDepartureToDestinationDirectionRequest.source = departureItem
            fromDepartureToDestinationDirectionRequest.destination = destinationItem
            fromDepartureToDestinationDirectionRequest.transportType = .automobile
            fromDepartureToDestinationDirectionRequest.requestsAlternateRoutes = true

            let routeFromDepartureToDestination = MKDirections(request: fromDepartureToDestinationDirectionRequest)
            routeFromDepartureToDestination.calculate(completionHandler: {
                (response, error) in
                guard let response = response, error == nil else {
                    print("route from source to departure failed")
                    return
                }

                let routePath = response.routes[0]
                self.navigationView.addOverlay(routePath.polyline)
                self.navigationView.setVisibleMapRect(routePath.polyline.boundingMapRect, animated: true)
            })
            
        })
        
    }
    
    
}

extension PostDetailTableViewLocationCell : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // You can print location like this
        // an output example:
        // [<+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 11/19/21, 11:43:18 PM Central Standard Time]
        
        //print(locations)
    }
}

extension PostDetailTableViewLocationCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}
