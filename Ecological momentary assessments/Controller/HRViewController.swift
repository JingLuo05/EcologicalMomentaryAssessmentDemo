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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI
        startButton.setTitle("Start", for: .normal)
        startButton.layer.cornerRadius = 10
        
        // set the imageview for camera
        //ImageV.image = UIImage(named: "AppIcon")
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
        }
    }
    
    
    
}

// Use this func to process the images
extension HRViewController: CaptureManagerDelegate {
    func processCapturedImage(image: UIImage) {
        self.ImageV.image = image
        runTime = Date().timeIntervalSince1970
        print("Time: \(runTime - startTime), Image size:\(image.size)")
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
}

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
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
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

