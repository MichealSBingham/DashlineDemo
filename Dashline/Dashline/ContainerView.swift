//
//  ContainerView.swift
//  Dashline
//
//  Created by David Slakter on 5/19/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import UIKit


class ContainerView: UIViewController, UIScrollViewDelegate {

    var scannerFrame: CGRect!
    var scrollView: UIScrollView!
    var lastContentOffset: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add child views
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "home")
        let scannerVC = storyboard?.instantiateViewController(withIdentifier: "scanner")
        let storeVC = storyboard?.instantiateViewController(withIdentifier: "chooseStore")
        
        self.addChildViewController(homeVC!)
        self.addChildViewController(scannerVC!)
        self.addChildViewController(storeVC!)
        
    
        scrollView = UIScrollView(frame: view.bounds)
        
        //configure frames in scroll view
        scrollView.addSubview(homeVC!.view)
        scrollView.addSubview(scannerVC!.view)
        scrollView.addSubview(storeVC!.view)
        
        var frame1 = homeVC!.view.frame
        frame1.origin.y = frame1.height
        homeVC!.view.frame = frame1
        
        scannerFrame = scannerVC!.view.frame
        scannerFrame.origin.y = 2*scannerFrame.height
        scannerVC!.view.frame = scannerFrame
        
        //configure scroll view
        let scrollWidth = view.frame.width
        let scrollHeight = 3*view.frame.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(CGPoint(x: frame1.origin.x, y: frame1.origin.y+50), animated: false)
        scrollView.delegate = self
        view.addSubview(scrollView)
    
    
        //add notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.showScanner), name: .showScanner, object: nil)
        
    }
    
    @objc func showScanner(){
        scrollView.setContentOffset(CGPoint(x: scannerFrame.origin.x, y: scannerFrame.origin.y), animated: true)
        
    }
    
    
   
    
 
    
    
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            // We're at the bottom of Scroll View : (Scanner Screen)
            NotificationCenter.default.post(name: .didShowScanner, object: nil)
        }
        
        if (scrollView.contentOffset.y <= 0){
            // We're at the top of Scanner View, stop scanner
             NotificationCenter.default.post(name: .didLeaveScanner, object: nil)
         
        }
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom, stop scanner
            NotificationCenter.default.post(name: .didLeaveScanner, object: nil)
            
        }
    }



}

extension Notification.Name{
    static let showScanner = Notification.Name("showScanner")
    static let didShowScanner = Notification.Name("didShowScanner")
    static let didLeaveScanner = Notification.Name("didLeaveScanner")
}
