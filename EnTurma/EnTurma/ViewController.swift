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
        
        var graphDescriptoin = " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb)."
        
        var graphTitle = "  Evasão"
        
        var newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, y1Values: yData1,y2Values: yData2, graphTitleString: graphTitle,graphTextDescription: graphDescriptoin)

        
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

