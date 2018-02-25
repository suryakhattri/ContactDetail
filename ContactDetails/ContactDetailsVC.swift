

import UIKit
import Contacts
import ContactsUI


class ContactDetailsVC: UIViewController, CNContactPickerDelegate {

    //MARK: - Outlet Connection
    
    @IBOutlet var lblContactDetails: UILabel!
    
    var contactStore = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Action Button
    
    @IBAction func contactDetailsButton(_ sender: Any) {
        
        //MARK: - Permission  Message
        
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)

        if authStatus == CNAuthorizationStatus.notDetermined {

            let contactStore = CNContactStore.init()
                contactStore.requestAccess(for: entityType, completionHandler: { ( success, nil ) in

                if success {
                    self.openContacts()
                }
                print(" Not Authorised ")
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {

            self.openContacts()
        }
    }

    func openContacts () {
        
         let entityType = CNEntityType.contacts
         let contactPicker = CNContactPickerViewController.init()
         contactPicker.delegate = self
         self.present(contactPicker, animated: true, completion: nil)
        
         func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
            
            contactStore.requestAccess(for: entityType, completionHandler:  { ( success,  nil ) in
                
                if success {
                    self.openContacts()
                } else {
                    DispatchQueue.main.async {
                        showSettingsAlert(completionHandler)
                    }
                }
            })
        }
        
        func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
            
            let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                completionHandler(false)
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
                completionHandler(false)
            })
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Select Contact Property
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    
        if (self.lblContactDetails) != nil {
            
            let fullName = "\(contact.givenName) \(contact.familyName)"
            var email = "Not Available"
            
            if !contact.emailAddresses.isEmpty  {
                
                let emailString = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
                email = emailString! as! String
            }
            
        var numberArray = [String]()
            
        for number in contact.phoneNumbers {
            
            let phoneNumber = number.value as CNPhoneNumber
            numberArray.append(phoneNumber.stringValue)
        }
            
        var number = ""
        let num = ""
            
        for n in numberArray {
                
                print (n)
                number = "\(number)  \(num) \(n)\n"
        
            }
            
            self.lblContactDetails.text = "Name: \(fullName)\n\nEmail: \(email)\n\nNumbers: \n\(number) "
        }
    }
    
    //MARK: - cancel property
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
