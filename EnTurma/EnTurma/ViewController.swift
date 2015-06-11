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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartViewFrame = CGRectMake(20, 100, view.frame.width-40, self.view.frame.width-40)
        
        
        var xData = NSArray(objects: "2008", "2009","2010", "2011","2012","2013")
        
        var yData1 = NSArray(objects: 10,20,10,50,30,100)
        var yData2 = NSArray(objects: 25,67,2,78,12,24)

        var newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, y1Values: yData1, y2Values: yData2)

        
      //  newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, yValues: yDatas)
        view.addSubview(newChart)
        
        
        newChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

