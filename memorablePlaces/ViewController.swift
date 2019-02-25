//
//  ViewController.swift
//  memorablePlaces
//
//  Created by Bibek Shrestha on 2/24/19.
//  Copyright © 2019 Bibek Shrestha. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    struct memoPlaces {
        var title = ""
        var subTitle = ""
        var latitude = 0.0
        var longitude = 0.0
    }
    var arrayMemoPlaces: [memoPlaces] = []
    
    func startingScreen(){
        
        
        let latitude: CLLocationDegrees = 32.840744
        let longitude: CLLocationDegrees = -96.994970
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.title = "Irving Mall"
        annotation.subtitle = "It's a shopping mall"
        annotation.coordinate = coordinates
        
        mapView.addAnnotation(annotation)
    }
    
    func addAnnotation(_ latitude: Double, _ longitude: Double, title: String, subTitle: String){
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subTitle
        annotation.coordinate = CLLocationCoordinate2DMake(latitude as CLLocationDegrees, longitude as CLLocationDegrees)
        
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        startingScreen()
        //reloadData()
        // Do any additional setup after loading the view, typically from a nib.
        let uiLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gestureRecognizer: )))
        uiLongPress.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(uiLongPress)
        
        
    }
    
    
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        print(coordinates.longitude)
        print(coordinates.latitude)
        getTitleAlert(latitude: coordinates.latitude, longitude: coordinates.longitude )
        
        
    }
    
    func getTitleAlert(latitude:Double,longitude: Double)
    {
        var title = ""
        var subTitle = ""
        let alert = UIAlertController(title: "Memorable Place?", message: "Please enter title and subtitle below", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your title here..."
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your subtitle here..."
        })
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            title = (alert.textFields?.first?.text)!
            subTitle = (alert.textFields?.last?.text)!
            self.addAnnotation(latitude, longitude, title: title, subTitle: subTitle)
            self.arrayMemoPlaces.append(memoPlaces(title: title, subTitle: subTitle, latitude: latitude, longitude: longitude))
            
           // UserDefaults.standard.set(self.arrayMemoPlaces, forKey: "arrayMemoPlaces")
        }))
        
        self.present(alert, animated: true)
    }
    
    func reloadData(){
        if UserDefaults.standard.value(forKey: "arrayMemoPlaces") != nil {
            arrayMemoPlaces = ((UserDefaults.standard.value(forKey: "arrayMemoPlaces") as! NSArray) as! [ViewController.memoPlaces])
            for index in 0..<arrayMemoPlaces.count {
                addAnnotation(arrayMemoPlaces[index].latitude, arrayMemoPlaces[index].longitude, title: arrayMemoPlaces[index].title, subTitle: arrayMemoPlaces[index].subTitle)
            }
        }
    
    }

}

