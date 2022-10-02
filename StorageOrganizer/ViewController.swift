//
//  ViewController.swift
//  StorageOrganizer
//
//  Created by Aaron Cleveland on 9/29/22.
//

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
    
    let qrImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(qrImageView)
        qrImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qrImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        qrImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        qrImageView.image = generateQRCode(qrText: "test")
    }
    
    func generateQRCode(qrText: String) -> UIImage? {
        let data = qrText.data(using: String.Encoding.ascii)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrImage = qrFilter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaleQRImage = qrImage.transformed(by: transform)
        
        
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaleQRImage, from: scaleQRImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
