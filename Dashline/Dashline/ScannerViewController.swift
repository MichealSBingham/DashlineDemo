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
    
    @IBOutlet var confirmPriceView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var pricePerItemLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet var finalPriceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    var item: Product? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupScanner()
        
        self.view.addSubview(confirmPriceView)
        blurView.isHidden = true
        blurView.alpha = 0.7
        confirmPriceView.alpha = 0
        confirmPriceView.center = CGPoint(x: self.view.center.x, y: self.view.center.y+200)
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
        Product.get(withID: "\(generateRandomNumber(min: 1, max: 4))") { (product) in
            
            if let product = product {
                item = product
                animateInPopup(product: product)
                
            }
        }
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
                videoPreviewLayer?.zPosition = -1
                
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
    
    @IBAction func didTapCancelItem(_ sender: Any) {
        animateOutPopup()
    }
    
    @IBAction func didConfirmItem(_ sender: Any) {
        
        shouldScanForBarcodes = true
        try! uiRealm.beginWrite()
        item!.quantity = Int(quantityLabel.text!)!
        try! uiRealm.commitWrite()
         item!.addToCart()
        animateOutPopup()
        
        let price = ShoppingCart.getCartTotal()
        finalPriceLabel.text = "$\(price)"
        
        //Add To Table
        item!.notifyProductAdded()
    }
    
    
    @IBAction func didTapIncrementItem(_ sender: Any) {
        quantityLabel.text = String(Int(quantityLabel.text!)! + 1)
        var price = Double(quantityLabel.text!)! * item!.price
        totalPriceLabel.text = "$\(price)"
        
    }
    
    
    @IBAction func didTapDecrementItem(_ sender: Any) {
        
        quantityLabel.text = String(Int(quantityLabel.text!)! - 1)
        
        var price = Double(quantityLabel.text!)! * item!.price
        totalPriceLabel.text = "$\(price)"
    }
    
    
    
    
    func animateInPopup(product: Product){
        shouldScanForBarcodes = false
        product.calculateTotal()
        productNameLabel.text = product.name
        pricePerItemLabel.text = "$\(product.price) each"
        quantityLabel.text = "\(product.quantity+1)"
        totalPriceLabel.text = "$\(product.price*Double((product.quantity+1)))"

        blurView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.confirmPriceView.alpha = 1
            self.confirmPriceView.transform = CGAffineTransform.init(translationX: 0, y: -200)
        })
    }
    
    func animateOutPopup(){
        shouldScanForBarcodes = true
        blurView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {
            self.confirmPriceView.alpha = 0
            self.confirmPriceView.transform = CGAffineTransform.init(translationX: 0, y: 200)
        })
    }

    
    
    
}

func generateRandomNumber(min: Int, max: Int) -> Int {
    let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
    return randomNum
}
