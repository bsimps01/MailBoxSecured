//
//  HomeViewController.swift
//  MailboxSecured
//
//  Created by Benjamin Simpson on 1/30/21.
//

import Foundation
import UIKit
import CoreBluetooth

class HomeViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    var manager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    let BEAN_NAME = "Robu"
    let BEAN_SCRATCH_UUID =
      CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let BEAN_SERVICE_UUID =
      CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
        central.scanForPeripherals(withServices: nil, options: nil)
      } else {
        print("Bluetooth not available.")
      }
    }
    
    private func peripheral(
      peripheral: CBPeripheral,
      didDiscoverServices error: NSError?) {
      for service in peripheral.services! {
        let thisService = service as CBService

        if service.uuid == BEAN_SERVICE_UUID {
            peripheral.discoverCharacteristics(
                nil,
                for: thisService
          )
        }
      }
    }
    
    private func centralManager(
      central: CBCentralManager,
      didDiscoverPeripheral peripheral: CBPeripheral,
      advertisementData: [String : AnyObject],
      RSSI: NSNumber) {
      let device = (advertisementData as NSDictionary)
        .object(forKey: CBAdvertisementDataLocalNameKey)
        as? NSString
            
        if device?.contains(BEAN_NAME) == true {
        self.manager.stopScan()
                
        self.peripheral = peripheral
        self.peripheral.delegate = self
                
            manager.connect(peripheral, options: nil)
      }
    }
    
    
}

