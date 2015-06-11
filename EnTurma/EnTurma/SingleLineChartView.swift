//
//  SingleLineChartView.swift
//  
//
//  Created by Thiago-Bernardes on 6/11/15.
//
//

import UIKit
import Charts

class SingleLineChartView: LineChartView, ChartViewDelegate{
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var xValues = NSArray(objects: "2008", "2009","2010", "2011","2012","2013")
        
        var yValues = NSArray(objects: 10,20,10,50,30,40)
        
        
        delegate = self
        descriptionText = "Evasão"
        noDataTextDescription = "O grafico precisa de dados"
        
        highlightEnabled = true
        dragEnabled = true
        scaleXEnabled = false
        pinchZoomEnabled = false
        setScaleEnabled(false)
        drawGridBackgroundEnabled = false

        
        xAxis.enabled = true
        xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 8)!
        xAxis.labelWidth = 2
        xAxis.drawGridLinesEnabled = false
        
        leftAxis.enabled = true
        leftAxis.startAtZeroEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        rightAxis.enabled = false
        legend.enabled = true
        legend.position = ChartLegend.ChartLegendPosition.BelowChartCenter
        
        setChartData(xValues, yValues: yValues)
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
    }
    
    func setChartData(xValues: NSArray, yValues: NSArray){
        
        var chartDataSet = convertDataToChartData(yValues)
        
        let dataSet1 = LineChartDataSet(yVals: chartDataSet as? [ChartDataEntry], label: "Índice em porcentagem")
        dataSet1.drawCubicEnabled = true
        dataSet1.cubicIntensity = 0.2
        dataSet1.drawCirclesEnabled = true
        dataSet1.drawCircleHoleEnabled = false
        dataSet1.lineWidth = 4.0
        dataSet1.circleRadius = 6.0
        dataSet1.highlightColor = UIColor.redColor()
        dataSet1.setColor(UIColor.blueColor())
        dataSet1.fillColor = UIColor.yellowColor()
        dataSet1.fillAlpha = 0.5
        dataSet1.drawFilledEnabled = true
        
        var chartData = LineChartData(xVals: xValues as? [NSObject], dataSet: dataSet1)
        
        
        
        data = chartData
        
    }
    
    func convertDataToChartData(data: NSArray) -> NSArray{
        
        var chartDataSet = NSMutableArray()
        
        for index in 0...data.count-1{
            
            var value = data.objectAtIndex(index) as! Double
            var chartDataEntry = ChartDataEntry(value: value, xIndex: index)
            chartDataSet.addObject(chartDataEntry)
        }
        
        return chartDataSet
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        NSLog(" chart value selected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        NSLog("Nothing selected")
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
