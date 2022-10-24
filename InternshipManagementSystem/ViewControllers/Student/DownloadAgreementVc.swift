 

import UIKit

class DownloadAgreementVc: UIViewController {

    @IBAction func onDownload(_ sender: Any) {
        guard let path = Bundle.main.url(forResource: "StudentAgreement", withExtension: "docx") else { return }
         
         
        // Create the Array which includes the files you want to share
        var filesToShare = [Any]()

        // Add the path of the file to the Array
        filesToShare.append(path)

        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)

 }

    
}
