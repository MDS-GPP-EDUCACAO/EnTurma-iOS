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
        var newChart = EnTurmaLineChartView.init(doubleLineGraphframe: chartViewFrame,xValues: xData, y1Values: yData1,y2Values: yData2, graphTitleString: graphTitle,graphTextDescription: graphDescriptoin)

        newChart.animate(yAxisDuration: 2.0)
        
        var graphTitle2 = "  Ditorção"
        var newChart2 = EnTurmaLineChartView.init(singleLineGraphframe: chartViewFrame,xValues: xData, yValues: yData1, graphTitleString: graphTitle2,graphTextDescription: graphDescriptoin)

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

        
        var xLabels = NSArray(objects:  "2°ano","4°ano")
        var yValues1 = NSArray(objects: 10,20)
        var yValues2 = NSArray(objects: 67,2)
        
        var barChart = EnTurmaBarChartView(doubleBarGraphframe: chartViewFrame, xValues: xLabels, y1Values: yValues1, y2Values: yValues2, graphTitleString: "Ideb", graphTextDescription: "Ideb é um grafico bom")
        
        
        
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

