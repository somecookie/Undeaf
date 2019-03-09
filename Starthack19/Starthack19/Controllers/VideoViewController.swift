/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Contains the object recognition view controller for the Breakfast Finder.
 */

import UIKit
import AVFoundation
import Vision

class VideoViewController: ViewController {
    
    private var detectionOverlay: CALayer! = nil
    
    @IBOutlet weak var debugImageView: UIImageView!
    // Vision parts
    private var requests = [VNRequest]()
    private var alphabet = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawVisionRequestResults()
        
        let startingValue = Int(("a" as UnicodeScalar).value)
        for i in 0..<2{
            if let unicode = UnicodeScalar(i + startingValue){
                alphabet.append(Character(unicode))
            }
        }
        alphabet.sort{$0 > $1}
        print(alphabet)
    }
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "inception_v3", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        let featureVec = (results[0] as! VNCoreMLFeatureValueObservation).featureValue
                        if let multiArray = featureVec.multiArrayValue{
                            print(multiArray)
                            var bestIdxSoFar = -1
                            var bestValue: Decimal = 0.0
                            for i in 0..<multiArray.count{
                                if multiArray[i].decimalValue > bestValue{
                                    bestValue = multiArray[i].decimalValue
                                    bestIdxSoFar = i
                                }
                            }
                            if bestValue > 0.75{
                                print(self.alphabet[bestIdxSoFar])
                            }
                        }
                    }
                })
            })
            objectRecognition.imageCropAndScaleOption = .centerCrop
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults() {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        let shapeLayer = self.createRoundedRectLayerWithBounds(CGRect(x: 0, y: 0, width: 200, height: 200))
        detectionOverlay.addSublayer(shapeLayer)
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        connection.videoOrientation = .portrait
        /*
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let cropWidth = 200
        let cropHeight = 200
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: baseAddress, width: cropWidth, height: cropHeight, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        // now the cropped image is inside the context.
        // you can convert it back to CVPixelBuffer
        // using CVPixelBufferCreateWithBytes if you want.
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        
        // create image
        let cgImage: CGImage = context!.makeImage()!
        let image = UIImage(cgImage: cgImage)
        DispatchQueue.main.async {
            self.debugImageView.image = image
        }*/
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0,
                                         y: 0,
                                         width: 200,
                                         height: 200)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        scale = 1.0
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionOverlay.position = CGPoint (x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
        
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.65, 0.91, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}
