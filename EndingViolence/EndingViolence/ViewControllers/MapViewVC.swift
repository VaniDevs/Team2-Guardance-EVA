//
//  MapViewVC.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 06/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import MapKit

class Pin : MKAnnotationView {
    
    static var reuseID = "pinReuseID"
    
    init(image: UIImage) {
        super.init(annotation: nil, reuseIdentifier: Pin.reuseID)
        
        //draggable = true
        self.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MapMarker: NSObject, MKAnnotation {
    
    private let image: UIImage
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        
        self.image = image
        self.coordinate = coordinate
        
        super.init()
    }
    
    // MARK: MKAnnotation
    dynamic var coordinate: CLLocationCoordinate2D  // The implementation of this property must be KVO compliant.

//    var title: String? { get }
//    var subtitle: String? { get }
}

class MapViewVC : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    var session: MSession?
    
    private let modelMgr = ModelMgr()
    private var locations = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let session = session {
            locations = session.rLocations.map { $0.rLocation.coordinate }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        clearMarkers()
        
        guard locations.count > 0 else { return }
        
        let allButLastLocation = Array(locations[0..<locations.count-1])
        let markers = createMarkersForCoordinates(allButLastLocation, withImage: UIImage(named: "placeholder_prevPos")!)
        addMarkers(markers)
        
        let lastKnownLocation = locations.last!
        addMarkers([MapMarker(coordinate: lastKnownLocation, image: UIImage(named: "placeholder_curPos")!)])
        moveCameraTo(lastKnownLocation)
        
    }
    
    func moveCameraTo(coordinate: CLLocationCoordinate2D, zoom: Double = 17) {
        
        let minZoom: CLLocationDistance = 1
        let maxZoom: CLLocationDistance = 22
        let clippedZoom = max(minZoom, min(zoom, maxZoom))
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, clippedZoom * 10.0, clippedZoom * 10.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func createMarkersForCoordinates(coordinates: [CLLocationCoordinate2D], withImage image: UIImage) -> [MapMarker] {
        
        return coordinates.map {
            MapMarker(coordinate: $0, image: image)
        }
    }

    private func addMarkers(markers: [MapMarker]) {
        mapView.addAnnotations(markers)
    }

    private func clearMarkers() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension MapViewVC : MKMapViewDelegate {

    // mapView:viewForAnnotation: provides the view for each annotation.
    // This method may be called for all or some of the added annotations.
    // For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if let marker = annotation as? MapMarker {
            let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(Pin.reuseID) ?? Pin(image: marker.image)
            pin.canShowCallout = false
            return pin
        }
        return nil
    }

}
