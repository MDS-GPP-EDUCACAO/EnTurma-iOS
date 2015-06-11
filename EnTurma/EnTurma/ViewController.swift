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
        
        let chartViewFrame = CGRectMake(0, 100, view.bounds.width, self.view.bounds.width)
        
        
        var xData = NSArray(objects: "1°ano", "2°ano","3°ano", "4°ano","5°ano","6°ano")
        
        var yData1 = NSArray(objects: 10,20,10,50,30,100)
        var yData2 = NSArray(objects: 25,67,2,78,12,24)

        var newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, y1Values: yData1,y2Values: yData2, graphTitleString: "  Evasão")

        
      //  newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, yValues: yDatas)
        view.addSubview(newChart)
        
        newChart.animate(yAxisDuration: 2.0)

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

