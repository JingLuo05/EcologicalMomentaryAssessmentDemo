//
//  CaptureManagerBrain.swift
//  Ecological momentary assessments
//
//  Created by MayLuo on 2020/7/2.
//  Copyright © 2020 Jing Luo. All rights reserved.
//

import AVFoundation
import UIKit

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
        
        // Set video to 60 Hz
        configureFPS(device: device!)
        
        //setup output
        let output = AVCaptureVideoDataOutput()
        // videoSettings is a dictionary value
        //output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_16BE555]
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: kCVPixelFormatType_32BGRA]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        session?.addOutput(output)
    }
    
    func startSession() {
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
    
    func configureFPS(device: AVCaptureDevice) {
        var finalFormat: AVCaptureDevice.Format?
        var maxFps: Double = 0
        for vFormat in device.formats
        {
            let ranges      = vFormat.videoSupportedFrameRateRanges
            let frameRates  = ranges[0]
            if frameRates.maxFrameRate >= maxFps && frameRates.maxFrameRate <= 60
            {
                maxFps = frameRates.maxFrameRate
                finalFormat = vFormat
            }
        }

        do {
            try device.lockForConfiguration()
            device.activeFormat = finalFormat!
            device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 60)
            device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 60)
            device.unlockForConfiguration()
        } catch {
            print("Fail to set frame rate")
        }

    }
    
}

extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        //print("sample buffer number: \(sampleBuffer.numSamples)")
        delegate?.processCapturedImage(image: outputImage)
    }
}
