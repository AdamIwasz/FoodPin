//
//  MapViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 26/09/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: {
            placemarks, error in
            if let error = error{
                print(error)
                return
            }
            
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                
                let annotaion = MKPointAnnotation()
                annotaion.title = self.restaurant.name
                annotaion.subtitle = self.restaurant.type
                
                if let location = placemark.location{
                    annotaion.coordinate = location.coordinate
                    
                    self.mapView.showAnnotations([annotaion], animated: true)
                    self.mapView.selectAnnotation(annotaion, animated: true)
                }
            }
        })
        
        mapView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
        
    }
}
