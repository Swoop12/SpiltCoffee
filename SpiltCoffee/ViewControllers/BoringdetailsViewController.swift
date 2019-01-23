//
//  BoringdetailsViewController.swift
//  SpiltCoffee
//
//  Created by DevMountain on 10/7/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class BoringdetailsViewController: UIViewController {
    
    @IBOutlet weak var boringDetailsTextView: UITextView!
    var info: String?
    var detail: String?{
        didSet{
            print(detail)
            Firestore.firestore().document("BoringDetails/\(detail ?? "?")").getDocument { (snapshot, error) in
                if let error = error{
                    print("\(error.localizedDescription) \(error) in function: \(#function)")
                    return
                }else {
                    print(snapshot?.data())
                    self.info = snapshot?.data()?["info"] as? String
                    DispatchQueue.main.async {
                        self.updateViews()
                    }
                }
            }
        }
    }

    func updateViews(){
        guard let detail = detail else { return}
        self.title = detail
        self.boringDetailsTextView.text = info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
