//
//  WebViewController.swift
//  FoodPin
//
//  Created by Adam Iwaszkiewicz UCTI on 19/10/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var targetURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: targetURL){
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }

}
