//
//  ViewController.swift
//  EnTurma
//
//  Created by Thiago-Bernardes on 6/10/15.
//  Copyright (c) 2015 mds. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {
    
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartViewFrame = CGRectMake(0, 10, view.bounds.width, self.view.bounds.width)
        var xData = NSArray(objects: "1°ano", "2°ano","3°ano", "4°ano","5°ano","6°ano")
        var yData1 = NSArray(objects: 10,20,10,50,30,100)
        var yData2 = NSArray(objects: 25,67,2,78,12,24)
        var graphDescriptoin = " O Índice de Evasão retrata o percentual de alunos que deixaram de frequentar a escola, caracterizando dessa forma abandono escolar. Tal índice é obtido por meio do Censo Escolar pelo Inep e compõe o Índice de Desenvolvimento da Educação Brasileira (Ideb)."
        var graphTitle = "  Evasão"
        var newChart = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, y1Values: yData1,y2Values: yData2, graphTitleString: graphTitle,graphTextDescription: graphDescriptoin)

        newChart.animate(yAxisDuration: 2.0)
        
        var graphTitle2 = "  Ditorção"
        var newChart2 = EnTurmaLineChartView.init(frame: chartViewFrame,xValues: xData, yValues: yData1, graphTitleString: graphTitle2,graphTextDescription: graphDescriptoin)

        newChart2.animate(yAxisDuration: 2.0)
        
        
        
        
        
        
        var controllerArray : [UIViewController] = []
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        var controller : UIViewController = UIViewController()
        controller.view.addSubview(newChart)
        controller.title = "Evasão"
        controllerArray.append(controller)
        
        var controller2 : UIViewController = UIViewController()
        controller2.title = " SECOND"
        controller2.view.addSubview(newChart2)
        controllerArray.append(controller2)

        
        var barChart = BarChartView(frame: chartViewFrame)
        barChart.delegate = self
        barChart.descriptionText = "";
        barChart.noDataTextDescription = "Sem dados"
        barChart.pinchZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.drawGridBackgroundEnabled = false
        

        var legend = barChart.legend;
        legend.position = ChartLegend.ChartLegendPosition.RightOfChartInside;
        legend.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        
        var xAxis = barChart.xAxis;
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        
        var leftAxis = barChart.leftAxis;
        leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter!.maximumFractionDigits = 1;
        leftAxis.drawGridLinesEnabled = false;
        leftAxis.spaceTop = 0.25;
        
        barChart.rightAxis.enabled = false;
        barChart.valueFormatter = NSNumberFormatter()
        barChart.valueFormatter.maximumFractionDigits = 1;
        

        
        var xLabels = NSArray(objects:  "2°ano","4°ano")
        var yValues1 = NSArray(objects: 10,20)
        var yValues2 = NSArray(objects: 67,2)
        
        var convertedYVals1 = convertDataToChartData(yValues1)
        var convertedYVals2 = convertDataToChartData(yValues2)
        
        let dataSet1 = BarChartDataSet(yVals: convertedYVals1 as? [BarChartDataEntry], label: "Turma1")
        dataSet1.setColor(UIColor.blueColor())
        
        let dataSet2 = BarChartDataSet(yVals: convertedYVals2 as? [BarChartDataEntry], label: "Turma2")
        dataSet2.setColor(UIColor.redColor())
        
        var dataSets = NSArray(objects: dataSet1,dataSet2)
        
        var barChartData = BarChartData(xVals: xLabels as? [NSObject], dataSets: dataSets as? [BarChartDataSet])
        
        barChartData.groupSpace = 0.5
        barChartData.setValueFont(UIFont(name: "HelveticaNeue-Light",size:10.0))
        
        barChart.data = barChartData
        
        var controller3 = UIViewController()
        controller3.title = " Bar Chart"
        controller3.view.addSubview(barChart)
        controllerArray.append(controller3)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .MenuMargin(20.0),
            .MenuHeight(40.0),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .UnselectedMenuItemLabelColor(UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 15.0)!),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorRoundEdges(false),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0)

        ]
        
        let pageMenuFrame = CGRectMake(0, 100, view.bounds.width, self.view.bounds.width+100)

        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        

        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)

        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func convertDataToChartData(data: NSArray) -> NSArray{
        
        var chartDataSet = NSMutableArray()
        
        for index in 0...data.count-1{
            
            var value = data.objectAtIndex(index) as! Double
            var chartDataEntry = BarChartDataEntry(value: value, xIndex: index)
            chartDataSet.addObject(chartDataEntry)
        }
        
        return chartDataSet
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

