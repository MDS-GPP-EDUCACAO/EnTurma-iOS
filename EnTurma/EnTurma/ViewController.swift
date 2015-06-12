//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var params = ["year":"2008","state":"AC","grade":"1° ano","test_type":"Total","public_type":"Total","local":"Total"]
        
        var rest = RESTFullManager(params: params)
        rest.requestReport({ (<#AFHTTPRequestOperation!#>, <#AnyObject!#>) -> Void in
            <#code#>
        }, failure: <#(AFHTTPRequestOperation!, NSError!) -> Void##(AFHTTPRequestOperation!, NSError!) -> Void#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

