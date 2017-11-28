//
//  ViewController.swift
//  QRReader
//
//  Created by Andrew Tittle on 10/8/17.
//  Copyright © 2017 Andrew Tittle. All rights reserved.
//

import UIKit
//imports audio and video functions
import AVFoundation

//add AVCapture Delegete
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var square: UIImageView!
    
    //this will contain our videos and shows to user what the video is capturing
    //can see the video being taken
    var video = AVCaptureVideoPreviewLayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating a session
        let session = AVCaptureSession()
        
        //Define capture device as default device and sets media type ("withMediaType") as video ("AVMediaTypeVideo")
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do
        {
            //takes result of capture device and stores it in the constant ("input")
            let input = try AVCaptureDeviceInput(device: captureDevice)
            //adds input (the raw data) into our session
            session.addInput(input)
        }
        
        catch
        {
            //prints "Error" to console
            print("Error")
        }
        
        //Defines the output that is coming from our session
        let output = AVCaptureMetadataOutput()
        
        session.addOutput(output)
        
        //tells app we want that output processed on the main queue
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //tells app we are only interested in processing ("QRCodes") by the ("AVMetadataObjectTypeQRCode") and defines "QRCodes" as the data type from the ("metadataObjectTypes")
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        //creates a video representation of our input
        video = AVCaptureVideoPreviewLayer(session: session)
        
        //tells the app to use the whole screen for the video
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        //starts the video session
        session.startRunning()
        
    }
    
    //
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            //if we have something good it will cast it to a machine readable code object
            if let object = metadataObjects [0] as? AVMetadataMachineReadableCodeObject
            {
                //checking if the dataType (".type") is equal to a "QRCode" aka ("AVMetadataObjectTypeQRCode")
                if object.type == AVMetadataObjectTypeQRCode
                {
                    //if is a eadable "QRCode" we give the user 2 options
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    //an option to retake the photo
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

