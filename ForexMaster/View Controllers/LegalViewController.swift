//
//  LegalViewController.swift
//  ForexMaster
//
//  Created by Ken Yu on 7/26/16.
//  Copyright © 2016 ken. All rights reserved.
//

import UIKit

public class LegalViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    public static let kUrl = "https://fast-forest-93779.herokuapp.com/legal"
    
    public override class var kNibName: String {
        get {
            return "LegalViewController"
        }
    }
    
    public override var navBarTitle: String {
        get {
            return "Legal Information"
        }
    }
    
    public var url: String?
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public convenience init(url: String = LegalViewController.kUrl) {
        self.init(nibName: LegalViewController.kNibName, bundle: nil)
        self.url = url
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    public override func setup() {
        super.setup()
        setupWebView()
    }
    
    public func setupWebView() {
        guard let urlStr = url else { return }
        guard let url = NSURL(string: urlStr) else { return }
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}

extension LegalViewController: UIWebViewDelegate {
    public func webViewDidFinishLoad(webView: UIWebView) {
    }
}
