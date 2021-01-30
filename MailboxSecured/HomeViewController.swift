//
//  HomeViewController.swift
//  MailboxSecured
//
//  Created by Benjamin Simpson on 1/30/21.
//

import CoreBluetooth
import UIKit

class ParticlePeripheral: NSObject {
    public static let mailboxBluetooth = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
}

class HomeViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    let bluetoothConnectButton = UIButton()
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        bluetoothButtonConfiguration()
    }
    
    func bluetoothButtonConfiguration(){
        view.addSubview(bluetoothConnectButton)
        bluetoothConnectButton.translatesAutoresizingMaskIntoConstraints = false
        bluetoothConnectButton.layer.cornerRadius = 30
        bluetoothConnectButton.setTitle("Log In", for: .normal)
        bluetoothConnectButton.backgroundColor = .systemBlue
        
        bluetoothConnectButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        bluetoothConnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bluetoothConnectButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        bluetoothConnectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        bluetoothConnectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        bluetoothConnectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
    }
    
    @objc func buttonPressed(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // If we're powered on, start scanning
            func centralManagerDidUpdateState(_ central: CBCentralManager) {
                print("Central state update")
                if central.state != .poweredOn {
                    print("Central is not powered on")
                } else {
                    print("Central scanning for", ParticlePeripheral.mailboxBluetooth);
                    centralManager.scanForPeripherals(withServices: [ParticlePeripheral.mailboxBluetooth],
                                                      options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
                }
            }
    
    // Handles the result of the scan
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

            // We've found it so stop scan
            self.centralManager.stopScan()

            // Copy the peripheral instance
            self.peripheral = peripheral
            self.peripheral.delegate = self

            // Connect!
            self.centralManager.connect(self.peripheral, options: nil)

        }
    
    // The handler if we do connect succesfully
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            if peripheral == self.peripheral {
                print("Connected to your Mailbox!")
                peripheral.discoverServices([ParticlePeripheral.mailboxBluetooth])
                self.view.window?.rootViewController = MailBoxLock()
            }
        }
    
    // Handles discovery event
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let services = peripheral.services {
                for service in services {
                    if service.uuid == ParticlePeripheral.mailboxBluetooth {
                        print("Mailbox discovered")
                        //Now kick off discovery of characteristics
                        peripheral.discoverCharacteristics([ParticlePeripheral.mailboxBluetooth], for: service)
                        return
                    }
                }
            }
        }
    
}


