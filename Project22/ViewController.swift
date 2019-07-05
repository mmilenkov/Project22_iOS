//
//  ViewController.swift
//  Project22
//
//  Created by Miloslav Milenkov on 05/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var distanceLabel: UILabel!
    var locationManager: CLLocationManager?
    var firstAppeared = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceLabel.text = "FAR"
                break
            case .near:
                self.view.backgroundColor = .orange
                self.distanceLabel.text = "NEAR"
                break
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceLabel.text = "RIGHT HERE"
                break
            default:
                self.view.backgroundColor = .gray
                self.distanceLabel.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            beaconFirstAppearanceCheck()
        } else {
            update(distance: .unknown)
        }
    }
    
    fileprivate func beaconFirstAppearanceCheck() {
        if firstAppeared {
            let ac = UIAlertController(title: "First Beacon", message: "You found your first beacon!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "YAY!", style: .default))
            present(ac, animated: true)
            firstAppeared = false
        }
    }


}

