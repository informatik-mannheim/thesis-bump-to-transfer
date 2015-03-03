//
//  ViewController.swift
//  Bumper
//
//  Created by Benjamin on 04/11/14.
//  Copyright (c) 2014 Benjamin Grab. All rights reserved.
//

import UIKit
import AssetsLibrary
import AddressBook
import CoreBluetooth
import CoreLocation
import MultipeerConnectivity
import CoreMotion
import AudioToolbox

class ViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate, CBPeripheralManagerDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate  {

    var header: UIView!
    var footer: UIView!
    var body: UIView!
    var browserViewController: BrowserViewController!
    var outBoxViewController: OutboxViewController!
    var inBoxViewController: InboxViewController!
    var flipped = false
    var toViewController: UIViewController!
    var pan = false
    var start: CGPoint!
    
    //iBeacon
    var sender = false
    var major: CLBeaconMajorValue?
    var minor: CLBeaconMajorValue?
    var majorString: String?
    var minorString: String?
    var networkIdentifier: Int!
    
    var beaconManager: CBPeripheralManager!
    var locationManager: CLLocationManager!
    let beaconUUID = NSUUID(UUIDString: "EBEFD083-70A2-47C8-9837-E7B5634DF524")
    var transmitRegion: CLBeaconRegion?
    var rangeRegion = CLBeaconRegion()
    var data = NSDictionary()
    let beaconIdentifier = "bumperBeacon"
    
    

    
   
    // Constants
    var serviceType: String?
    
    // Optionals
    var localSession: MCSession?
    var advertiser: MCNearbyServiceAdvertiser?
    var serviceBrowser: MCNearbyServiceBrowser?
    var localPeerID: MCPeerID?
    
    // Set properties
    var connectedPeers: [MCPeerID] = []
    var buttonCounter = 0

    
    //Accelerometer
    let motionManager = CMMotionManager()
    var accelX = 0.0
    var accelY = 0.0
    var accelZ = 0.0
    var prevAccelX = 0.0
    var prevAccelY = 0.0
    var prevAccelZ = 0.0
    let kFilteringFactor = 0.1
    let updateInterval = 0.01
    var accelero = false
    var recording = false
    var deltaX: Double!
    var deltaY: Double!
    var deltaZ: Double!
    var arrayX: [Double] = []
    var arrayY: [Double] = []
    var arrayZ: [Double] = []
    
    
    
    var closestBeaconDistance: CLLocationAccuracy = 0.0
    var closestBeaconMajor: NSNumber = -1
    var closestBeaconMinor: NSNumber = -1
    var foundPeerMajor: NSNumber = -1
    var foundPeerMinor: NSNumber = -1
    var dictionary = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header = UIView(frame: Global.header)
        footer = UIView(frame: Global.footer)
        body = UIView(frame: Global.body)
        
        Global.profilePicture = ProfilePicture(frame: CGRectMake(footer.bounds.midX - 25, footer.bounds.midY - 25, 50, 50))
        footer.addSubview(Global.profilePicture)
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        Global.profilePicture.addGestureRecognizer(recognizer)
        view.addSubview(header)
        view.addSubview(footer)
        view.addSubview(body)
        header.backgroundColor = Color.LIGHTGREY.toUIColor()
        footer.backgroundColor = Color.DARKGREY.toUIColor()
        body.backgroundColor = Color.MEDIUMGREY.toUIColor()

        if (Global.phoneOwner == nil) {
            if let data = NSUserDefaults.standardUserDefaults().objectForKey("phoneOwner") as? NSData {
            Global.phoneOwner = NSKeyedUnarchiver.unarchiveObjectWithData(data) as Contact
                if (Global.phoneOwner.thumbnailImage != nil) {
                    Global.profilePicture.image = UIImage(data: Global.phoneOwner.thumbnailImage!)
                } else {
                    println("standard image")
                }
            }
        }
    
        browserViewController = BrowserViewController()
        addChildViewController(browserViewController)
        view.addSubview(browserViewController.view)
        
        outBoxViewController = OutboxViewController()
        browserViewController.addChildViewController(outBoxViewController)
        browserViewController.view.addSubview(outBoxViewController.view)
        start = browserViewController.view.center

        inBoxViewController = InboxViewController()
       
        Global.swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(Global.swipeRight)
        
        Global.swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(Global.swipeLeft)
        
        Global.swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(Global.swipeUp)
        
        Global.swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(Global.swipeDown)
        
        Global.swipeRightTwoFingers = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeRightTwoFingers.direction = UISwipeGestureRecognizerDirection.Right
        Global.swipeRightTwoFingers.numberOfTouchesRequired = 2
        view.addGestureRecognizer(Global.swipeRightTwoFingers)
        
        Global.swipeLeftTwoFingers = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeLeftTwoFingers.direction = UISwipeGestureRecognizerDirection.Left
        Global.swipeLeftTwoFingers.numberOfTouchesRequired = 2
        view.addGestureRecognizer(Global.swipeLeftTwoFingers)
        
        Global.swipeUpTwoFingers = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeUpTwoFingers.direction = UISwipeGestureRecognizerDirection.Up
        Global.swipeUpTwoFingers.numberOfTouchesRequired = 2
        view.addGestureRecognizer(Global.swipeUpTwoFingers)
        
        Global.swipeDownTwoFingers = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        Global.swipeDownTwoFingers.direction = UISwipeGestureRecognizerDirection.Down
        Global.swipeDownTwoFingers.numberOfTouchesRequired = 2
        view.addGestureRecognizer(Global.swipeDownTwoFingers)


        
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = updateInterval
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: accelerationUpdated)

        }

    }
    
//    func accelero(sender: UIButton!) {
//        if (!accelero) {
//            arrayX.removeAll(keepCapacity: false)
//            arrayY.removeAll(keepCapacity: false)
//            arrayZ.removeAll(keepCapacity: false)
//            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: accelerationUpdated)
//            accelero = true
//        } else {
//            motionManager.stopAccelerometerUpdates()
//            println("accelX")
//            for value in arrayX {
//                println(value)
//            }
//            println()
//            println("accelY")
//            for value in arrayY {
//                println(value)
//            }
//            println()
//            println("accelZ")
//            for value in arrayZ {
//                println(value)
//            }
//            accelero = false
//        }
//    }

    func accelerationUpdated(accelerometerData: CMAccelerometerData!, error: NSError!) {
        if (error != nil) {
            NSLog("\(error)")
        }
        accelY = accelerometerData.acceleration.y - ( (accelerometerData.acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor)) )
        accelX = accelerometerData.acceleration.x - ( (accelerometerData.acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor)) )
        accelZ = accelerometerData.acceleration.z - ( (accelerometerData.acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor)) )
        
        if (accelX < 0 || prevAccelX < 0) {
            deltaX = abs(accelX) + abs(prevAccelX)
        } else {
            deltaX = abs(abs(accelX) - abs(prevAccelX))
        }
        if (accelY < 0 || prevAccelY < 0) {
            deltaY = abs(accelY) + abs(prevAccelY)
        } else {
            deltaX = abs(abs(accelY) - abs(prevAccelY))
        }
        if (accelZ < 0 || prevAccelZ < 0) {
            deltaZ = abs(accelZ) + abs(prevAccelZ)
        } else {
            deltaZ = abs(abs(accelZ) - abs(prevAccelZ))
        }
        
        if ((deltaX > 0.3 && deltaY > 0.5 && deltaZ > 0.1) && !recording) {
            println(deltaX)
            println(deltaY)
            println(deltaZ)
            arrayX.append(accelX)
            arrayY.append(accelY)
            arrayZ.append(accelZ)
            recording = true
        } else if (recording) {
            if (arrayX.count < 31) {
                arrayX.append(accelX)
                arrayY.append(accelY)
                arrayZ.append(accelZ)
            } else {
                recording = false
                motionManager.stopAccelerometerUpdates()
                checkForBump(arrayX, arrayy: arrayY, arrayz: arrayZ)
            }
        }
        prevAccelY = accelY
    }
    
    func countPeaks(array: NSArray!) -> Int {
        var peaks = 0
        for (var index = 1; index < array.count-1; index++) {
            var value = array[index] as Double
            var before = array[index-1] as Double
            var next = array[index+1] as Double
            if (value < before  && value < next || value > before && value > next) {
                peaks++
            }
        }
        println(peaks)
        return peaks
    }
    
    func checkForBump(arrayx: NSArray!, arrayy: NSArray!, arrayz: NSArray!) {
        println("cheking")
        var bump = false
        var peaksX = countPeaks(arrayx)
        var peaksY = countPeaks(arrayy)
        var peaksZ = countPeaks(arrayz)
        
        if (peaksX >= arrayX.count-10 && peaksX <= arrayX.count-2 && peaksY >= arrayY.count-10 && peaksY <= arrayY.count-2 && peaksZ >= arrayZ.count-10 && peaksZ <= arrayZ.count-2) {
            bump = true
            println(bump)
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            if(beaconManager == nil) {
                startBeacon()
            }
        } else {
            bump = false
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: accelerationUpdated)
        }
        arrayX.removeAll(keepCapacity: false)
        arrayY.removeAll(keepCapacity: false)
        arrayZ.removeAll(keepCapacity: false)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        var transitionOptions: UIViewAnimationOptions!
        Global.profilePicture.userInteractionEnabled = false
        
        if (!flipped) {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
            if (Global.phoneOwner == nil) {
                toViewController = AddressBookViewController()
            } else {
                toViewController = PhoneOwnerContactViewController()
            }
            UIView.transitionFromView(outBoxViewController.view, toView: toViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                Global.profilePicture.userInteractionEnabled = true
                self.flipped = true
            })
        } else {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
            UIView.transitionFromView(toViewController.view, toView: outBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                Global.profilePicture.userInteractionEnabled = true
                self.flipped = false
            })
        }
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            var touchStartLocation = swipeGesture.locationInView(self.view)
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                if (touchLeftOfBrowser(touchStartLocation) || swipeGesture.numberOfTouchesRequired == 2 && inSideBrowserBounds(touchStartLocation)) {
                    var transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
                    if (!flipped) {
                        UIView.transitionFromView(outBoxViewController.view, toView: inBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                           self.flipped = true
                        })
                    } else {
                        UIView.transitionFromView(inBoxViewController.view, toView: outBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                            self.flipped = false
                        })
                    }
                }
            case UISwipeGestureRecognizerDirection.Left:
                if (touchRightOfBrowser(touchStartLocation) || swipeGesture.numberOfTouchesRequired == 2 && inSideBrowserBounds(touchStartLocation)) {
                    var transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
                    if (!flipped) {
                        UIView.transitionFromView(outBoxViewController.view, toView: inBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                            self.flipped = true
                        })
                    } else {
                        UIView.transitionFromView(inBoxViewController.view, toView: outBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                            self.flipped = false
                        })
                    }
                }
            case UISwipeGestureRecognizerDirection.Up:
                var startLocation = browserViewController.view.center
                var distance = browserViewController.view.frame.minY - header.frame.height
                if (touchBelowBrowser(touchStartLocation) || swipeGesture.numberOfTouchesRequired == 2 && inSideBrowserBounds(touchStartLocation)) {
                    UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear , animations: {
                            self.browserViewController.view.center = CGPointMake(self.browserViewController.view.center.x, self.browserViewController.view.center.y  - distance)
                        }, completion: {
                            (value: Bool) in
                            UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear , animations: {
                                self.browserViewController.view.center = startLocation
                                }, completion: {
                                    (value: Bool) in
                            })
                    })
                }
            case UISwipeGestureRecognizerDirection.Down:
                var startLocation = browserViewController.view.center
                var distance = browserViewController.view.frame.minY - header.frame.height
                if (touchAboveBrowser(touchStartLocation) || swipeGesture.numberOfTouchesRequired == 2 && inSideBrowserBounds(touchStartLocation)) {
                    UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear , animations: {
                        self.browserViewController.view.center = CGPointMake(self.browserViewController.view.center.x, self.browserViewController.view.center.y  + distance)
                        }, completion: {
                            (value: Bool) in
                            UIView.animateWithDuration(0.5, delay: 0, options: .CurveLinear , animations: {
                                self.browserViewController.view.center = startLocation
                                }, completion: {
                                    (value: Bool) in
                            })
                    })
                }
            default:
                break
            }
        }
    }
    
    func touchLeftOfBrowser(touchStartLocation: CGPoint) -> Bool {
        return (touchStartLocation.x <= browserViewController.view.frame.minX && touchStartLocation.y <= browserViewController.view.frame.maxY && touchStartLocation.y >= browserViewController.view.frame.minY)
    }
    
    func touchRightOfBrowser(touchStartLocation: CGPoint) -> Bool {
        return (touchStartLocation.x >= browserViewController.view.frame.maxX && touchStartLocation.y <= browserViewController.view.frame.maxY && touchStartLocation.y >= browserViewController.view.frame.minY)
    }
    
    func touchAboveBrowser(touchStartLocation: CGPoint) -> Bool {
        return (touchStartLocation.x >= browserViewController.view.frame.minX && touchStartLocation.x <= browserViewController.view.frame.maxX && touchStartLocation.y <= browserViewController.view.frame.minY && touchStartLocation.y >= header.frame.maxY)
    }
    
    func touchBelowBrowser(touchStartLocation: CGPoint) -> Bool {
        return (touchStartLocation.x >= browserViewController.view.frame.minX && touchStartLocation.x <= browserViewController.view.frame.maxX && touchStartLocation.y >= browserViewController.view.frame.maxY && touchStartLocation.y <= footer.frame.minY)
    }
    
    func inSideBrowserBounds(touchStartLocation: CGPoint) -> Bool {
        return (touchStartLocation.x >= browserViewController.view.frame.minX && touchStartLocation.x <= browserViewController.view.frame.maxX && touchStartLocation.y >= browserViewController.view.frame.minY && touchStartLocation.y <= browserViewController.view.frame.maxY)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [CLBeacon]!, inRegion region: CLBeaconRegion!) {
        let filteredBeacons = beacons.filter( { (beacon: CLBeacon) -> Bool in
            return beacon.proximity == CLProximity.Immediate
        })
        


            
//            if (filteredBeacons.last?.major.integerValue > Int(major!)) {
//                sender = false
//                chef.text = sender.description
//                networkIdentifier = filteredBeacons.last?.major.integerValue
//                networkIdendifierLabel.text = networkIdentifier.description
//                beaconManager.stopAdvertising()
//                locationManager.stopRangingBeaconsInRegion(rangeRegion)
//                //Browser
//                println(networkIdentifier.description)
//                serviceType = "Bump-" + String(networkIdentifier)
//                browser = MCNearbyServiceBrowser(peer: localPeerID!, serviceType: serviceType)
//                browser!.delegate = self
//                browser!.startBrowsingForPeers()
//            } else {
//                sender = true
//                chef.text = sender.description
//                networkIdentifier = Int(major!)
//                networkIdendifierLabel.text = networkIdentifier.description
//                beaconManager.stopAdvertising()
//                locationManager.stopRangingBeaconsInRegion(rangeRegion)
//                
//                // Advertiser
//                println(networkIdentifier.description)
//                serviceType = "Bump-" + String(networkIdentifier)
//                advertiser = MCNearbyServiceAdvertiser(peer: localPeerID!, discoveryInfo: nil, serviceType: serviceType)
//                advertiser!.delegate = self
//                advertiser!.startAdvertisingPeer()
                
                
                
//            }
        if (!beacons.isEmpty) {
        for beac in beacons {
            var beacon:CLBeacon = beac as CLBeacon
//            switch beacon.proximity {
//            case CLProximity.Far:
//                self.distance.text = "Far"
//            case CLProximity.Near:
//                self.distance.text = "Near"
//            case CLProximity.Immediate:
//                self.distance.text = "Immediate"
//            case CLProximity.Unknown:
//                self.distance.text = "Unknown Proximity"
//                return
//            }
            
            closestBeaconDistance = beacon.accuracy
            closestBeaconMajor = beacon.major
            closestBeaconMinor = beacon.minor
//            println("foundBeacon")
//            println("beaconMajor " +  beacon.major.description)
//            println("beaconMinor " + beacon.minor.description)
//            println("beaconDistance "  + beacon.accuracy.description)
        }
            if (serviceBrowser == nil) {
                setupNetwork()
            }
        }
        
}
    
    func setupNetwork() {
        localPeerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        dictionary = ["Major": majorString!, "Minor": minorString!]
        serviceType = "Bump-Network"
        
        serviceBrowser = MCNearbyServiceBrowser(peer: localPeerID!, serviceType: serviceType)
        serviceBrowser!.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID!, discoveryInfo: dictionary, serviceType: serviceType)
        advertiser!.delegate = self
        
        serviceBrowser!.startBrowsingForPeers()
        println("startBrowsingforPeers")

        advertiser!.startAdvertisingPeer()
        println("startAdvertisingPeer")
        println(connectedPeers.count)
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheral.state == CBPeripheralManagerState.PoweredOn) {
            beaconManager.startAdvertising(data)
            println("Transmitting Beacon")
            if (peripheral.state == CBPeripheralManagerState.PoweredOff) {
                beaconManager.stopAdvertising()
                println("Stop transmitting Beacon")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
    }
        
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println(error)
    }
        
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func startBeacon() {
        println("startBeacon")
        major = UInt16(arc4random() >> 16)
        minor = UInt16(arc4random() >> 16)
        majorString = major?.description
        minorString = minor?.description
        println("Beacon ownMajor " + majorString!)
        println("Beacon ownMajor " + minorString!)
        
        transmitRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: major!, minor: minor!, identifier: beaconIdentifier)
        
        data = transmitRegion!.peripheralDataWithMeasuredPower(nil)
        beaconManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        rangeRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startRangingBeaconsInRegion(rangeRegion)
    }
    
    // MCNearbyServiceAdvertiserDelegate
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        println("Received invitation from \(peerID.displayName)")
        var peerMajor = NSString(data:context, encoding: NSUTF8StringEncoding)
        println("context: " + peerMajor!)
        if (closestBeaconMajor.description == peerMajor) {
            localSession = MCSession(peer: localPeerID!, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
            localSession!.delegate = self
            invitationHandler(true, self.localSession)
        } else {
            invitationHandler(false, self.localSession)
            println("rejected")
        }
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        // Handle this error more gracefully
        println("Didn't start advertiser")
    }
    
    // MCNearbyServiceBrowserDelegate
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("Found Peer! \(peerID.displayName)")
        var infoMajor = info["Major"] as String
        var infoMinor = info["Minor"] as String
        var optionalMajor: String? = infoMajor
        var optionalMinor: String? = infoMinor
        if let major = optionalMajor {
            foundPeerMajor = major.toInt()!
        }
        if let minor = optionalMinor {
            foundPeerMinor = minor.toInt()!
        }
        println("Multi foundPeerMajor " + foundPeerMajor.description)
        println("Multi foundPeerMinor " + foundPeerMinor.description)
        println("Multi closestPeerMajor " +  closestBeaconMajor.description)
        println("Multi closestPeerMinor " + closestBeaconMinor.description)
        println(foundPeerMajor == closestBeaconMajor)
        println(foundPeerMinor == closestBeaconMinor)

        if (foundPeerMajor == closestBeaconMajor && major?.description  > foundPeerMajor.description) {
            println("Setting up session")
            localSession = MCSession(peer: localPeerID!, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
            localSession!.delegate = self
            let data = major?.description.dataUsingEncoding(NSUTF8StringEncoding)
            browser.invitePeer(peerID, toSession: localSession, withContext: data, timeout: 10)
            println("invited " + peerID.description)
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        localSession = nil
    }
    
    
    // MCSessionDelegate
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        switch state {
            case .NotConnected:
                println("State Changed to Not Connected")
                dispatch_async(dispatch_get_main_queue(), {
                    self.disconnect()
                })
//                serviceBrowser!.startBrowsingForPeers()
//                advertiser!.startAdvertisingPeer()
            case .Connecting:
                println("State Changed to Connecting")
                locationManager.stopRangingBeaconsInRegion(rangeRegion)
                beaconManager.stopAdvertising()
                serviceBrowser!.stopBrowsingForPeers()
                advertiser!.stopAdvertisingPeer()
                transmitRegion = nil
            case .Connected:
                println("State Changed to Connected")
                println("Connected to \(peerID.displayName)")
                connectedPeers.append(peerID)
                dispatch_async(dispatch_get_main_queue(), {
                    if (Global.carousel.items.count != 0) {
                        var asset = Global.carousel.items.first?.asset
                        var url = self.buildURL(asset)
                        var fileName = asset?.defaultRepresentation().filename()
                        session.sendResourceAtURL(url, withName: fileName, toPeer: self.connectedPeers.first, withCompletionHandler: ( { (error: NSError!) -> Void in
                            if (error != nil) {
                                // handle error
                                println("Error: " + error.localizedDescription);
                            } else {
                                println("Übertragung der Datei " + fileName! + " abgeschlossen")
                            }
                        }))
                    }
                })
        }
    }
    
    func buildURL(asset: ALAsset!) -> NSURL {
    
       var imageToSave = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        // Save the new image to the documents directory
       var pngData = UIImageJPEGRepresentation(imageToSave, 1.0)
        
        // Create a file path to our documents directory
        var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        var filePath = documentsPath + "/" + asset.defaultRepresentation().filename()
        pngData.writeToFile(filePath, atomically: true)
        return NSURL.fileURLWithPath(filePath)!
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        let message = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Message received \(message)")
    }
        
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("Empfang der Datei " + resourceName + " begonnen")
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("Empfang der Datei " + resourceName + " abgeschlossen")
        dispatch_async(dispatch_get_main_queue(), {
            var image =  UIImage(data: NSData(contentsOfURL: localURL)!)
            var imageView = UIImageView(image: image)
            imageView.frame = Global.browserContentFrame
            var transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft

            UIView.transitionFromView(self.outBoxViewController.view, toView: self.inBoxViewController.view, duration: 1.0, options: transitionOptions, completion: { finished in
                self.flipped = true
                self.inBoxViewController.view.addSubview(imageView)
            })
            
//            var assetsLibrary = ALAssetsLibrary()
//            assetsLibrary.writeImageToSavedPhotosAlbum(image?.CGImage, orientation: .Up, completionBlock: { (url: NSURL!, error: NSError!) -> Void in
//                if ((error) != nil) {
//                    println("Error: " + error.localizedDescription)
//                } else {
//
//                }
//            })
        })
    }
//
//    func incrementCounterAndSend(sender: UIButton!) {
//        buttonCounter++
//        let data = "Message Nr. \(buttonCounter)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//        var error: NSError? = nil
//        
//        if (!localSession!.sendData(data, toPeers: connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)){
//            println("ERROR \(error)")
//        }
//    }
    
    func disconnect() {
        localSession?.disconnect()
        localSession = nil
        serviceBrowser = nil
        beaconManager = nil
        major = nil
        minor = nil
        majorString = ""
        minorString = ""
        closestBeaconMajor = -1
        closestBeaconMinor = -1
        foundPeerMajor = -1
        foundPeerMajor = -1
        dictionary.removeAll(keepCapacity: true)
        connectedPeers.removeAll(keepCapacity: true)
        localPeerID = nil
    }
}

