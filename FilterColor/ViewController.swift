//
//  ViewController.swift
//  FilterColor
//
//  Created by Alireza Toghiani on 8/5/22.
//

import UIKit
import AVKit

class ViewController: FilterCamViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
    }
    
    func setupCamera() {
        
        let captureSession = AVCaptureSession()
        if let backCamera = AVCaptureDevice.default(for: .video) {
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                captureSession.addInput(input)
                
                // although we don't use this, it's required to get captureOutput invoked
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

                view.layer.addSublayer(previewLayer)
                
                let videoOutput = AVCaptureVideoDataOutput()
                
                let concurrentQueue = DispatchQueue(label: "sample buffer delegate", attributes: .concurrent)
                videoOutput.setSampleBufferDelegate(self, queue: concurrentQueue)
                
                captureSession.addOutput(videoOutput)
                captureSession.startRunning()
            } catch {
                print("Can't access camera")
                return
            }
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        let topMargin = topLayoutGuide.length
//
//        mainGroup.frame = CGRect(x: 0, y: topMargin, width: view.frame.width, height: view.frame.height - topMargin).insetBy(dx: 5, dy: 5)
//    }
}

extension ViewController: FilterCamViewControllerDelegate {
    func filterCamDidStartRecording(_ filterCam: FilterCamViewController) {
        
    }
    
    func filterCamDidFinishRecording(_ filterCame: FilterCamViewController) {
        
    }
    
    func filterCam(_ filterCam: FilterCamViewController, didFailToRecord error: Error) {
        
    }
    
    func filterCam(_ filterCam: FilterCamViewController, didFinishWriting outputURL: URL) {
        
    }
    
    func filterCam(_ filterCam: FilterCamViewController, didFocusAtPoint tapPoint: CGPoint) {
        
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)
        
        let filteredImage = UIImage(ciImage: cameraImage).colorized(with: .red)

//            self.imageView.image = filteredImage.colorized(with: .red)
        
        
    }
}

extension UIImage {
    func colorized(with color: UIColor) -> UIImage? {
        guard
            let ciimage = CIImage(image: self),
            let colorMatrix = CIFilter(name: "CIColorMatrix")
        else { return nil }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        colorMatrix.setDefaults()
        colorMatrix.setValue(ciimage, forKey: "inputImage")
        colorMatrix.setValue(CIVector(x: r, y: 0, z: 0, w: 0), forKey: "inputRVector")
        colorMatrix.setValue(CIVector(x: 0, y: g, z: 0, w: 0), forKey: "inputGVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: b, w: 0), forKey: "inputBVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: 0, w: a), forKey: "inputAVector")
        if let ciimage = colorMatrix.outputImage {
            return UIImage(ciImage: ciimage)
        }
        return nil
    }
}
