//
//  HRViewController.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/6/25.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import UIKit
import AVFoundation

var customPreviewLayer: AVCaptureVideoPreviewLayer?

class HRViewController: UIViewController {
    
    @IBOutlet weak var ImageV: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    
    var startTime = Date().timeIntervalSince1970
    var runTime = Date().timeIntervalSince1970
    
    var sampleTime = Date().timeIntervalSince1970
    var sampleTimeCopy = Date().timeIntervalSince1970
    var count = 0
    var imageCopy: UIImage?
    var redChannel: [Int] = []
    var timeStamp: [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 10
        
        // set the imageview for camera
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
        
        CaptureManager.shared.statSession()
        CaptureManager.shared.delegate = self
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        if startButton.currentTitle == "Start" {
            startTime = Date().timeIntervalSince1970
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = UIColor.green
            toggleFlash()
        } else if startButton.currentTitle == "Stop" {
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = UIColor.white
            toggleFlash()
            CaptureManager.shared.stopSession()
            //print(redChannel)
            print(timeStamp)
        }
    }
    
    
    
}

//MARK: - Function to process captured image
extension HRViewController: CaptureManagerDelegate {
    
    
    func processCapturedImage(image: UIImage) {
        self.ImageV.image = image
        self.count += 1
        runTime = Date().timeIntervalSince1970
        sampleTime = runTime - startTime
        //print("Sample Time: \(sampleTime)")
        self.timeStamp.append(sampleTime)
        //----------
//        imageCopy = image
//        sampleTimeCopy = sampleTime
//        if imageCopy != nil {
//            DispatchQueue.global(qos: .userInteractive).async {
//                self.redChannel.append((self.getRedSum(image: self.imageCopy!)))
//                self.timeStamp.append(self.sampleTimeCopy)
//                //let averageColor = self.imageCopy!.averageColor(alpha: 1.0)
//                //let result = self.rgbToHue(r: averageColor.components!.red, g: averageColor.components!.green, b: averageColor.components!.blue)
//                //print("                Reslut Time: \(self.sampleTimeCopy), result: \(result.h)")
//                //print("\(self.sampleTimeCopy),\(result.h)")
//            }
//        }
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
    
    func getRedSum(image: UIImage) -> Int {
        let rawImageRef : CGImage = image.cgImage!
        let  data : CFData = rawImageRef.dataProvider!.data!
        let rawPixelData  =  CFDataGetBytePtr(data);
        
        let imageHeight = rawImageRef.height
        let imageWidth  = rawImageRef.width
        let bytesPerRow = rawImageRef.bytesPerRow
        let stride = rawImageRef.bitsPerPixel / 6
        
        var red = 0
        
        for row in 0...imageHeight {
            var rowPtr = rawPixelData! + bytesPerRow * row
            for _ in 0...imageWidth {
                red    += Int(rowPtr[0])
                rowPtr += Int(stride)
            }
        }
        
        return red
    }
    
    func rgbToHue(r:CGFloat,g:CGFloat,b:CGFloat) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
        let minV:CGFloat = CGFloat(min(r, g, b))
        let maxV:CGFloat = CGFloat(max(r, g, b))
        let delta:CGFloat = maxV - minV
        var hue:CGFloat = 0
        if delta != 0 {
            if r == maxV {
                hue = (g - b) / delta
            }
            else if g == maxV {
                hue = 2 + (b - r) / delta
            }
            else {
                hue = 4 + (r - g) / delta
            }
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        let saturation = maxV == 0 ? 0 : (delta / maxV)
        let brightness = maxV
        return (h:hue/360, s:saturation, b:brightness)
    }
}


//MARK: - Set up capture session
protocol CaptureManagerDelegate: class {
    func processCapturedImage(image: UIImage)
}

class CaptureManager: NSObject {
    internal static let shared = CaptureManager()
    weak var delegate: CaptureManagerDelegate?
    var session: AVCaptureSession?
    
    override init() {
        super.init()
        session = AVCaptureSession()
        
        //setup input
        let device =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        let input = try! AVCaptureDeviceInput(device: device!)
        session?.addInput(input)
        
        //setup output
        let output = AVCaptureVideoDataOutput()
        // videoSettings is a dictionary value
        //output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_16BE555]
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        session?.addOutput(output)
    }
    
    func statSession() {
        session?.startRunning()
    }
    
    func stopSession() {
        session?.stopRunning()
    }
    
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder16Little.rawValue)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        //change bitsPerComponent from 8 to 4
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        //  print(cgImage.bitmapInfo)
        //›print("bitsPerPixel: \(cgImage.bitsPerPixel)")
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
}

extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        delegate?.processCapturedImage(image: outputImage)
    }
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

