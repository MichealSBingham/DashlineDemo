//
//  ScannerViewController
//  BarcodeScanner
//
//  Created by Micheal S. Bingham on 7/14/17.
//  Copyright © 2018 Micheal S. Bingham. All rights reserved.
//
import UIKit
import AVFoundation
import AudioToolbox

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    var shouldScanForBarcodes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupScanner()
        
        
        
       
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // Called when Barcode or QR is detecteed
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard shouldScanForBarcodes else {
            
            // Do not do anything if the scanner isn't activated
            return
        }
        
        if metadataObjects.count == 0 {
            
          // Nothing is detection
       
            return
        }
        
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let upc = metadataObject.stringValue else { return }
        
        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
    
        print("The barcode is :  ... \(upc)\n")
        
       
        // **** UPC / Barcode was Detected. Stop Actively Scanning for a new barcode here and show popup.
        
       
   
        
        
    }
    
  
    
    // Sets up the scanner
    func setupScanner()  {
        
        // Listen to Activate/Deactivate Scanner
        NotificationCenter.default.addObserver(self, selector: #selector(ScannerViewController.activateScanner), name: .didShowScanner, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(ScannerViewController.deactivate), name: .didLeaveScanner, object: nil)
        
        
        captureDevice = AVCaptureDevice.default(for: .video)
        
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
            
            do {
                
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39, .upce, .aztec, .code39Mod43, .code93, .dataMatrix, .ean13, .ean8]
                
              
                  captureSession.startRunning()
                
                
               
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                // Error with Device Input
                
            }
            
        }
    }
    
    // Tells scanner to look for barcodes. Call when the user is on the scanner and after a user adds a product to cart
    @objc func activateScanner()  {
        
       shouldScanForBarcodes = true
    }
    
    // Tells Scanner to stop looking for barcodes. Call this whenever the user leaves the scanner or after a user scans a product.
    @objc func deactivate()  {
        
        shouldScanForBarcodes = false
    }
}
