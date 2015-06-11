//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    var newChart: SingleLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartViewFrame = CGRectMake(20, 100, view.frame.width-40, self.view.frame.width-40)
        newChart = SingleLineChartView(frame: chartViewFrame)
        self.view.addSubview(newChart)
        
        
        
        newChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

