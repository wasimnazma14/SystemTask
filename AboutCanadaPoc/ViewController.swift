

import UIKit
import Foundation

import SDWebImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    
    var countryData: Country = Country()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshBarButton.target = self
        self.refreshBarButton.action = #selector(fetchAboutCountry)
   
        self.fetchAboutCountry()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        
        self.tableView.isHidden = true
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(self.countryData != nil && self.countryData.rows != nil) {
            return (self.countryData.rows!.count-1)
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailTableViewCell", for: indexPath) as! CountryDetailTableViewCell
        
        if let detail = self.countryData.rows![indexPath.row] as? Detail {
            if let detailImageUrl = detail.imageUrl {
                cell.imageViewCountry.sd_setImage(with: detailImageUrl, placeholderImage: UIImage(named: "Mask"))
            }
            
            if let title = detail.title {
                cell.lblTitle?.text = title
                cell.lblTitle.isHidden = false
            } else {
                cell.lblTitle.isHidden = true
            }
            
            if let description = detail.description {
                cell.lblDescription?.text = description
                cell.lblDescription.isHidden = false
            } else {
                cell.lblDescription.isHidden = true
            }
        }
        
        
        return cell
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func fetchAboutCountry() {
        
        if(!(ValidationHandler.isInternetAvailable())) {
            self.showAlert(message: ValidationHandler.noInternet)
        } else {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.tableView.endEditing(true)
            self.tableView.isHidden = true
        
        let webserviceHandler = WebServiceHandler()
        webserviceHandler.hitApiWithGetMethod(webApicallServiceNumber: WebApiCallServiceNumber.CountryData, anyObject: nil, completionHandler: { (statusCode, receivedData, parsedData) in
            // Update UI
            
            DispatchQueue.main.async {
                self.countryData = Country()
                self.countryData = parsedData as! Country
                
                if self.countryData.title != nil {
                    self.navigationItem.title = (self.countryData.title)!
                    print("\(String(describing: self.countryData.title))")
                } else {
                    self.navigationItem.title = "About a Country"
                }
                
                self.tableView?.reloadData()
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                self.tableView.isHidden = false
                self.tableView.endEditing(false)
                
            }
            
        })
            
    }
        
    }

    func showAlert(message: String) {
        // create the alert
        let alert = UIAlertController(title: "Country Details", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

