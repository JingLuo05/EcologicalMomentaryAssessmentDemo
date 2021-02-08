//
//  HRViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/6/25.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit
import AVFoundation
import Charts

var customPreviewLayer: AVCaptureVideoPreviewLayer?

class HRViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var ImageV: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var HRView: UIView!
    
    
    
    var startTime = Date().timeIntervalSince1970    //system time when pressed "start button"
    var runTime = Date().timeIntervalSince1970      //system time when get sample
    
    var sampleTime = Date().timeIntervalSince1970
    var sampleTimeCopy = Date().timeIntervalSince1970
    var count = 0                                   //count how many samples have captured
    var isStarted = false                           //whether startButton is pressed
    var imageCopy: UIImage?                         //use sample copy to process
    var redChannel: [Int] = []                      //sample result: Currenly just sum RBG red value of partial pixels
    var timeStamp: [Double] = []                    //time stamp for every sample
    var redChannel_cut: [Int] = []                      //sample result: Currenly just sum RBG red value of partial pixels
    var timeStamp_cut: [Double] = []                    //time stamp for every sample
    var name: String = ""                          //user name from first storyboard
    var age = 0                                    //user age from first storyboard
    //var postData: Post                              //data set sent to backend
    
    // AWS URL
    var httpURL = "http://ec2-52-91-138-189.compute-1.amazonaws.com:8080/save"
    
    // Chart variables
    var timer = Timer()
    var lineDataEntry: [ChartDataEntry] = []
    let chartData = LineChartData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isStarted = false
        
        // Set the UI
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 10
        
        HRView.layer.cornerRadius = 5.0
        HRView.layer.masksToBounds = true
        
        // set the imageview for view from camera
        ImageV.image = UIImage(named: "AppIcon")
        ImageV.contentMode = UIView.ContentMode.scaleAspectFill
        ImageV.layer.borderWidth = 4.0
        ImageV.layer.masksToBounds = false
        ImageV.layer.borderColor = UIColor.lightGray.cgColor
        ImageV.layer.cornerRadius = 50
        ImageV.clipsToBounds = true
        
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = UIColor.white
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // put background view as the most background subviews of stack view
        stackView.insertSubview(backgroundView, at: 0)
        
        // pin the background view edge to the stack view edge
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: stackView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        
        // Set chartView
        chartView.delegate = self
        //chartView.backgroundColor = UIColor.white
        chartView.noDataTextColor = UIColor.white
        chartView.noDataText = "No heart rate data yet."
        chartView.highlightPerTapEnabled = true
        
        CaptureManager.shared.startSession()
        CaptureManager.shared.delegate = self
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        if startButton.currentTitle == "Start" {
            chartView.clearValues()
            
            CaptureManager.shared.startSession()
            toggleFlash()
            
            isStarted = true
            startTime = Date().timeIntervalSince1970
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor.green
            
            //Update chartView every 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
            }
            
        }
            
        else if startButton.currentTitle == "Stop" {
            isStarted = false
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = UIColor.white
            CaptureManager.shared.stopSession()
            toggleFlash()
            print(redChannel)
            print(timeStamp)
            
            // Send data to backend
            //get user id and age
            let defaults = UserDefaults.standard
            if let userID = defaults.string(forKey: UserDefault.id) {
                print("user ID: \(userID)")
                self.name = userID
            }
            if let userAge = defaults.string(forKey: UserDefault.age) {
                self.age = Int(userAge) ?? 0
            }
            
            // Send data to backend
            let n = redChannel.count
            // Only send data to backend when the recodring time is longer than 30 seconds
            if n > 1800 {
                // prepare json data
                // Delete first 5 seconds data
                redChannel_cut = Array(redChannel[300..<redChannel.count])
                timeStamp_cut = Array(timeStamp[300..<timeStamp.count])
                
                let json: [String: Any] = ["hr": redChannel_cut, "time": timeStamp_cut, "PTP": name, "age": self.age]

                let jsonData = try? JSONSerialization.data(withJSONObject: json)

                // create post request
                let url = URL(string: httpURL)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                // insert json data to the request
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                }
                task.resume()
            }
            
            print("name:")
            print(name)
            print(age)
            
            //clear chartData from last session
            lineDataEntry = []
            
            // Clear former redchannel and timestamp data
            count = 0
            redChannel = []
            timeStamp = []
            redChannel_cut = []
            timeStamp_cut = []
            self.chartView.clearValues()
            
        }
    }
    
    
    @objc func updateUI()  {
        // Init chart UI
        // Update data
        //Set up chart UI
        DispatchQueue.main.async {
            self.chartView.clearValues()
            let chartDataSet = LineChartDataSet(entries: self.lineDataEntry)
            self.chartData.addDataSet(chartDataSet)
            self.chartData.setDrawValues(false)
            chartDataSet.setCircleColor(UIColor.systemPink)
            chartDataSet.circleRadius = 0.0
            chartDataSet.mode = .cubicBezier
            chartDataSet.cubicIntensity = 0.3
            chartDataSet.drawCircleHoleEnabled = false
            chartDataSet.fillAlpha = 65/255
            
            //chartDataSet.valueFont = UIFont(name: "Helvetica", size: 5.0)!
            chartDataSet.valueFont = UIFont(name: "Helvetica", size: 12.0)!
            self.chartView.legend.enabled = false
            self.chartView.xAxis.drawGridLinesEnabled = true
            self.chartView.xAxis.labelPosition = .bottom
            self.chartView.rightAxis.enabled = false
            //let leftAxis = chartView.leftAxis
            self.chartView.leftAxis.drawGridLinesEnabled = false
            
            self.chartView.data = self.chartData
            
            
            //Calculate HeartRate
            // use the latest 60 data points to calculate heart rate
//            let i_startPoint = self.count - 122
//            let redChannelSlice = Array(self.redChannel[i_startPoint...(self.count-2)])
//            let timeSlice = Array(self.timeStamp[i_startPoint...(self.count - 2)])
//            let heartrate = self.calculateHR(HR: redChannelSlice, time: timeSlice, THRESHOLD: 3000, HIGHFILTER: 200, LOWFILTER: 40, startPoint: i_startPoint)
//            if heartrate != 0 {
//                self.HRLabel.text = String(heartrate)
//            }
            
        }
    }
    
}

//MARK: - Function to process captured image
extension HRViewController: CaptureManagerDelegate {
    
    func processCapturedImage(image: UIImage) {
        self.ImageV.image = image
        if isStarted {
            runTime = Date().timeIntervalSince1970
            sampleTime = runTime - startTime
            imageCopy = image
            sampleTimeCopy = sampleTime
            if imageCopy != nil {
                DispatchQueue.global(qos: .userInteractive).async {
                    let sum = (self.getRedSum(image: self.imageCopy!))
                    self.redChannel.append(sum)
                    self.timeStamp.append(self.sampleTimeCopy)
                    if self.count > 30 {
                        let dataPoint = ChartDataEntry(x: self.sampleTimeCopy, y: Double((sum * -1) / 100))
                        self.lineDataEntry.append(dataPoint)
                    }
                    // Here decides how many datapoints are showed in the chart
                    if self.lineDataEntry.count > 150 {
                        self.lineDataEntry.removeFirst()
                    }
                    //let averageColor = self.imageCopy!.averageColor(alpha: 1.0)
                    //let result = self.rgbToHue(r: averageColor.components!.red, g: averageColor.components!.green, b: averageColor.components!.blue)
                    //print("                Reslut Time: \(self.sampleTimeCopy), result: \(result.h)")
                    //print("\(self.sampleTimeCopy),\(result.h)")
                }
            }
            self.count += 1
        }
        //----------
        //        if self.count % 2 == 0
        //        {
        //            imageCopy = image
        //            sampleTimeCopy = sampleTime
        //            if imageCopy != nil {
        //                sampleTimeCopy = sampleTime
        //                DispatchQueue.global(qos: .userInteractive).async {
        //                    self.redChannel.append((self.getRedSum(image: self.imageCopy!)))
        //                    self.timeStamp.append(self.sampleTimeCopy)
        //                    //let averageColor = self.imageCopy!.averageColor(alpha: 1.0)
        //                    //let result = self.rgbToHue(r: averageColor.components!.red, g: averageColor.components!.green, b: averageColor.components!.blue)
        //                    //print("                Reslut Time: \(self.sampleTimeCopy), result: \(result.h)")
        //                    //print("\(self.sampleTimeCopy),\(result.h)")
        //                }
        //            }
        //        }
        //let averageColor = image.averageColor(alpha: 1.0)
        //let result = rgbToHue(r: averageColor.components!.red, g: averageColor.components!.green, b: averageColor.components!.blue)
        
    }
    
    func calculateHR(HR: [Int], time: [Double], THRESHOLD: Int, HIGHFILTER: Double, LOWFILTER: Double, startPoint: Int) -> Int {
        var heartRate  = 0
//        var i = 3
//        print("HR slice: \(HR)")
//        print("time slice: \(time)")
//        let max = HR.max()
//        let min = HR.min()
//        print("max = \(max ?? 0), min = \(min ?? 0)")
//
//        while i < 117  {
//            if (HR[i] < HR[i-1]) && (HR[i] < HR[i-2]) && (HR[i] < HR[i-3]) && (HR[i] <= HR[i+1]) && (HR[i] <= HR[i+2]) && (HR[i] <= HR[i+3])
//            {
//                print("i: \(i)")
//                if isSpike(x: HR[i], max: max!, min: min!) {
//                    count = count + 1;
//                    print("HR[i]: \(HR[i])")
//                    print("i: \(i)")
//                    heartbeatValue.append(HR[i])
//                    heartbeatTimeStamp.append(time[i])
//                    i = i + 4
//                } else
//                {
//                    i = i + 1;
//                    print("i: \(i)")
//                }
//            }
//            else
//            {
//                i = i + 1;
//                print("i: \(i)")
//            }
//        }
//        print("heart beat value: \(heartbeatValue)")
//        print("heart bear time: \(heartbeatTimeStamp)")
        
            let hr = self.ThresholdingAlgo(y: HR.map { Double($0) }, lag: 30, threshold: 1.8, influence: 1).0

        //Use the result to get heartbeat timestamp
        let queue = Queue<Double>()
        for i in 0 ..< hr.count {
            if (hr[i] == 1) {
               queue.enqueue(time[i])
           }
           if queue.count >= 2 {
               let firstBeat = queue.dequeue()!
               let secondBeat = queue.tail!
               let oneBeatTime = secondBeat - firstBeat
               let res = 60 / oneBeatTime
               if res < HIGHFILTER && res > LOWFILTER {
                   heartRate = Int(res)
               }
           }
       }
        
        return heartRate
    }
    
    func isSpike(x: Int, max: Int, min: Int) -> Bool {
        print("thr:\((max+min)/2)")
        if x > (max+min)/2 {return false}
        else {return true}
    }
    
    // Function to calculate the arithmetic mean
    func arithmeticMean(array: [Double]) -> Double {
        var total: Double = 0
        for number in array {
            total += number
        }
        return total / Double(array.count)
    }

    // Function to calculate the standard deviation
    func standardDeviation(array: [Double]) -> Double
    {
        let length = Double(array.count)
        let avg = array.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff = array.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }

    // Function to extract some range from an array
    func subArray<T>(array: [T], s: Int, e: Int) -> [T] {
        if e > array.count {
            return []
        }
        return Array(array[s..<min(e, array.count)])
    }

    // Smooth z-score thresholding filter
    func ThresholdingAlgo(y: [Double],lag: Int,threshold: Double,influence: Double) -> ([Int],[Double],[Double]) {

        // Create arrays
        var signals   = Array(repeating: 0, count: y.count)
        var filteredY = Array(repeating: 0.0, count: y.count)
        var avgFilter = Array(repeating: 0.0, count: y.count)
        var stdFilter = Array(repeating: 0.0, count: y.count)

        // Initialise variables
        for i in 0...lag-1 {
            signals[i] = 0
            filteredY[i] = y[i]
        }

        // Start filter
        avgFilter[lag-1] = arithmeticMean(array: subArray(array: y, s: 0, e: lag-1))
        stdFilter[lag-1] = standardDeviation(array: subArray(array: y, s: 0, e: lag-1))

        for i in lag...y.count-1 {
            if abs(y[i] - avgFilter[i-1]) > threshold*stdFilter[i-1] {
                if y[i] > avgFilter[i-1] {
                    signals[i] = 1      // Positive signal
                } else {
                    // Negative signals are turned off for this application
                    //signals[i] = -1       // Negative signal
                }
                filteredY[i] = influence*y[i] + (1-influence)*filteredY[i-1]
            } else {
                signals[i] = 0          // No signal
                filteredY[i] = y[i]
            }
            // Adjust the filters
            avgFilter[i] = arithmeticMean(array: subArray(array: filteredY, s: i-lag, e: i))
            stdFilter[i] = standardDeviation(array: subArray(array: filteredY, s: i-lag, e: i))
        }

        return (signals,avgFilter,stdFilter)
    }
    
    func getRedSum(image: UIImage) -> Int {
        let rawImageRef : CGImage = image.cgImage!
        let  data : CFData = rawImageRef.dataProvider!.data!
        let rawPixelData  =  CFDataGetBytePtr(data);
        
        //let imageHeight = rawImageRef.height
        //let imageWidth  = rawImageRef.width
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 6
        
        var red = 0
        
        // Select pixels to sum redChannel
        for row in 100...150 {
            var rowPtr = rawPixelData! + bytesPerRow * row
            for _ in 100...150 {
                red    += Int(rowPtr[0])
                rowPtr += Int(stride)
            }
        }
        
        return red
    }
    
    // Func to toggle flashlight
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    //    func rgbToHue(r:CGFloat,g:CGFloat,b:CGFloat) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
    //        let minV:CGFloat = CGFloat(min(r, g, b))
    //        let maxV:CGFloat = CGFloat(max(r, g, b))
    //        let delta:CGFloat = maxV - minV
    //        var hue:CGFloat = 0
    //        if delta != 0 {
    //            if r == maxV {
    //                hue = (g - b) / delta
    //            }
    //            else if g == maxV {
    //                hue = 2 + (b - r) / delta
    //            }
    //            else {
    //                hue = 4 + (r - g) / delta
    //            }
    //            hue *= 60
    //            if hue < 0 {
    //                hue += 360
    //            }
    //        }
    //        let saturation = maxV == 0 ? 0 : (delta / maxV)
    //        let brightness = maxV
    //        return (h:hue/360, s:saturation, b:brightness)
    //    }
}

//MARK: - Functions related to image processing
extension UIImage {
    
    func averageColor(alpha : CGFloat) -> UIColor {
        
        let rawImageRef : CGImage = self.cgImage!
        let  data : CFData = rawImageRef.dataProvider!.data!
        let rawPixelData  =  CFDataGetBytePtr(data);
        
        let imageHeight = rawImageRef.height
        let imageWidth  = rawImageRef.width
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 6
        
        var red = 0
        var green = 0
        var blue  = 0
        
        for row in 0...imageHeight {
            var rowPtr = rawPixelData! + bytesPerRow * row
            for _ in 0...imageWidth {
                red    += Int(rowPtr[0])
                green  += Int(rowPtr[1])
                blue   += Int(rowPtr[2])
                rowPtr += Int(stride)
            }
        }
        
        let  f : CGFloat = 1.0 / (255.0 * CGFloat(imageWidth) * CGFloat(imageHeight))
        return UIColor(red: f * CGFloat(red), green: f * CGFloat(green), blue: f * CGFloat(blue) , alpha: alpha)
    }
    
    
}

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }
}

