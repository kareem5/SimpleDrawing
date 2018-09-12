//
//  HomeViewController.swift
//  DrawingApp
//
//  Created by Kareem Mohammed on 9/11/18.
//  Copyright © 2018 KareemDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var drawingView: contextDrawingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func colorButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            drawingView.color = .green
            break
            
        case 2:
            drawingView.color = .red
            break
            
        case 3:
            drawingView.color = .yellow
            break
            
        default:
            drawingView.color = .blue
        }
    }
    
}

extension HomeViewController {
    
    @IBAction func randomTapped(_ sender: Any) {
        drawingView.color = UIColor(red: randomFloat(), green: randomFloat(), blue: randomFloat(), alpha: 1.0)
    }
    
    @IBAction func settingsAction(_ sender: UIButton) {
        showSettingsOptions()
    }
    
    func showSettingsOptions() {
        let settingsAlertController = UIAlertController(title: "Settings", message: "What would like to do?", preferredStyle: .actionSheet)
        
        let eraseAction = UIAlertAction(title: "Erase", style: .destructive) { (action) in
            self.drawingView.eraseAll()
        }
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareTapped()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        settingsAlertController.addAction(eraseAction)
        settingsAlertController.addAction(shareAction)
        settingsAlertController.addAction(cancelAction)
        
        navigationController?.present(settingsAlertController, animated: true, completion: nil)
    }
    
    func shareTapped() {
        if let image = drawingView.bufferImage {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func randomFloat() -> CGFloat {
        return CGFloat(arc4random_uniform(1000)) / CGFloat(1000)
    }
}
