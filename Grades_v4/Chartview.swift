//
//  Chartview.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 29.03.24.
//

import SwiftUI
import Charts

struct Chartview: View {
    var storage: storageclass
    let data: [testspeicher]
    var color: Color
    //let max: Double
    //let min: Double
    
    init(storage: storageclass, color: Color) {
        self.storage = storage
        self.color = color
        
        
        var readdata: [testspeicher] = []
        for jahr in storage.schuljahre{
            if jahr.jahr == storage.activeschuljahr{
                for fach in jahr.fächer{
                    if fach.name == storage.activefach{
                        readdata = fach.tests
                    }
                }
            }
        }
        var counter = 0
        readdata = readdata.sorted{ a, b in
            a.datum_geschrieben < b.datum_geschrieben
        }
        
        for test in readdata.indices{
            readdata[test].chartid = counter
            counter += 1
        }
        //get max grade
        let sortedbygrade = readdata.sorted{ a, b in
            a.note > b.note
        }
        /*
        var valmax: Double = 0
        
        if let unwrappedfirst = sortedbygrade.first{
            valmax = unwrappedfirst.note
        }else{
            valmax = 6
        }
        
        self.max = valmax
        
        var valmin: Double = 0
        if let unwrappedmin = sortedbygrade.last{
            valmin = unwrappedmin.note
        }else{
            valmin = 4
        }
        self.min = valmin
        */
        
        
        self.data = readdata
    }
    
    func translatedata(val: Double) -> Double{
        let a = val - 3.5
        let b = 3.5 - a
        return b
    }
    
    
    var body: some View {
        
        //Text(String(min))
        //(String(max))
        
            Chart{
                ForEach(data){ datapoint in
                    LineMark(x: .value("Time", datapoint.chartid!), y: .value("Note", translatedata(val: datapoint.note)))
                }
                .interpolationMethod(.monotone)
                .foregroundStyle(color)
                .symbol(by: .value("a", "b"))
                
                ForEach(data){ datapoint in
                    AreaMark(x: .value("Time", datapoint.chartid!), y: .value("Note", translatedata(val: datapoint.note)))
                }
                .interpolationMethod(.monotone)
                .foregroundStyle(LinearGradient(colors: [color.opacity(0.4), color.opacity(0)], startPoint: .top, endPoint: .bottom))
                
            }
            //.chartYScale(domain: [min, max])
            .chartYScale(domain: [1,6])
            //.chartYAxis(.hidden)
            /*.chartYAxis{
                AxisMarks(values: [1, 2, 3, 4, 5, 6], content: { val in
                    AxisMark
                    
                })
            }*/
            .chartXAxis(.hidden)
            .chartLegend(.hidden)
            .padding(.all, 15)
    }
}

#Preview {
    Wrapper()
}

