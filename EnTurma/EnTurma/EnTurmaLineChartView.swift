//
//  SingleLineChartView.swift
//  
//
//  Created by Thiago-Bernardes on 6/11/15.
//
//

import UIKit
import Charts

class EnTurmaLineChartView: LineChartView, ChartViewDelegate{

    init(frame: CGRect, xValues: NSArray, yValues: NSArray) {

        super.init(frame: frame)
 
        setupGraph()
        
        setSingleLineChartData(xValues, yValues: yValues)
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
    }
    
    init(frame: CGRect, xValues: NSArray, y1Values: NSArray, y2Values: NSArray) {
        
        super.init(frame: frame)
        
        setupGraph()
        
        setTwoLinesChartData(xValues, y1Values: y1Values, y2Values: y2Values)
        setVisibleXRangeMinimum(CGFloat(xValues.count-1))
        
    }
    
    func setupGraph(){
        delegate = self
        descriptionText = ""
        noDataTextDescription = "O grafico precisa de dados"
        
        highlightEnabled = true
        dragEnabled = true
        //true motherfoca
        doubleTapToZoomEnabled = false
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
        
    }
    
    func setSingleLineChartData(xValues: NSArray, yValues: NSArray){
        
        var chartDataSet = convertDataToChartData(yValues)
        
        let dataSet1 = LineChartDataSet(yVals: chartDataSet as? [ChartDataEntry], label: "Índice em porcentagem")
        dataSet1.drawCubicEnabled = true
        dataSet1.cubicIntensity = 0.2
        dataSet1.drawCirclesEnabled = true
        dataSet1.drawCircleHoleEnabled = false
        dataSet1.lineWidth = 4.0
        dataSet1.circleRadius = 6.0
        dataSet1.highlightColor = (UIColor.blueColor())
        dataSet1.setColor(UIColor.blueColor())
        dataSet1.fillColor = UIColor.blueColor()
        dataSet1.fillAlpha = 0.5
        dataSet1.drawFilledEnabled = true
        
        var chartData = LineChartData(xVals: xValues as? [NSObject], dataSet: dataSet1)
        
        
        
        data = chartData
        
    }
    
    func setTwoLinesChartData(xValues: NSArray, y1Values: NSArray, y2Values: NSArray){
        
        var chartDataSet1 = convertDataToChartData(y1Values)
        
        var chartDataSet2 = convertDataToChartData(y2Values)
        
        let dataSet1 = LineChartDataSet(yVals: chartDataSet1 as? [ChartDataEntry], label: "Turma 1")
        let dataSet2 = LineChartDataSet(yVals: chartDataSet2 as? [ChartDataEntry], label: "Turma 2")
        
        dataSet1.drawCubicEnabled = true
        dataSet1.cubicIntensity = 0.2
        dataSet1.drawCirclesEnabled = true
        dataSet1.drawCircleHoleEnabled = false
        dataSet1.circleColors = [UIColor.blueColor()]
        dataSet1.lineWidth = 3.0
        dataSet1.circleRadius = 5.0
        dataSet1.highlightColor = UIColor.blueColor()
        dataSet1.setColor(UIColor.blueColor())
        dataSet1.fillColor = UIColor.blueColor()
        dataSet1.fillAlpha = 0.2
        dataSet1.drawFilledEnabled = true
        dataSet1.drawValuesEnabled = false
        
        dataSet2.drawCubicEnabled = true
        dataSet2.cubicIntensity = 0.2
        dataSet2.drawCirclesEnabled = true
        dataSet2.circleColors = [UIColor.redColor()]
        dataSet2.drawCircleHoleEnabled = false
        dataSet2.lineWidth = 3.0
        dataSet2.circleRadius = 5.0
        dataSet2.highlightColor = UIColor.redColor()
        dataSet2.setColor(UIColor.redColor())
        dataSet2.fillColor = UIColor.redColor()
        dataSet2.fillAlpha = 0.2
        dataSet2.drawFilledEnabled = true
        dataSet2.drawValuesEnabled = false
        
        var chartData = LineChartData(xVals: xValues as? [NSObject], dataSets: [dataSet1, dataSet2])
       
        
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
