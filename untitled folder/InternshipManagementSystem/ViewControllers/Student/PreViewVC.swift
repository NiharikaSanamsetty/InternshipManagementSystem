import UIKit
 
 
class PreViewVC : UIViewController {

    @IBOutlet weak var dataCollectionView: UICollectionView!
    
    var currentShowingIndex = 0
    
    var attachments: [UploadFileList] = []
    var lastIndex = 0
    
       @IBOutlet weak var nextButton: UIButton!{
           didSet{
               nextButton.layer.borderWidth = 0
               nextButton.layer.borderColor = UIColor.blue.cgColor
               nextButton.layer.cornerRadius = 6
               nextButton.tintColor = .blue
           }
       }
       
       @IBOutlet weak var previousButton: UIButton!{
           didSet{
               previousButton.layer.borderWidth = 0
               previousButton.layer.borderColor = UIColor.blue.cgColor
               previousButton.layer.cornerRadius = 6
               previousButton.tintColor = .blue
           }
       }
    
    @IBOutlet weak var onDownload: UIButton!
    
    var currentPage = 0 {
           didSet {
               if currentPage == attachments.count-1 {
                   nextButton.isHidden = true
               } else if currentPage > 0 {
                   nextButton.isHidden = false
                   previousButton.isHidden = false
               } else {
                   nextButton.isHidden = false
                   previousButton.isHidden = true
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previousButton.layer.opacity = 0.8
        self.nextButton.layer.opacity = 0.8
        self.dataCollectionView.delegate = self
        self.dataCollectionView.dataSource = self
        self.dataCollectionView.registerCells([ImageOrPdfPreviewLive.self])
        self.lastIndex = attachments.count  - 1
        self.previousButton.isHidden = true
         self.dataCollectionView?.delegate?.scrollViewDidEndScrollingAnimation?(dataCollectionView)
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
            dataCollectionView.collectionViewLayout = flowLayout
        
        previousButton.isHidden = true
        
    }
    
    
  
}


extension PreViewVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout , UIScrollViewDelegate , UIScrollViewAccessibilityDelegate {
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let itemWidth = collectionView.bounds.width
          let itemHeight = collectionView.bounds.height
          return CGSize(width: itemWidth, height: itemHeight)
  }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                currentPage = indexPath.item
    }
 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return attachments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        let attachment = self.attachments[indexPath.row]
        
        var cell = UICollectionViewCell()
        
        cell.clipsToBounds = true
    
        
        if let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageOrPdfPreviewLive.idenifier, for: indexPath) as? ImageOrPdfPreviewLive {
            customCell.setData(attchment: attachments[indexPath.row], frame: self.view.frame)
            cell = customCell
        }
    
         return cell
    }
    
    
    
    
    
    @objc func rightArrowTapped(_ sender: UIButton) {
       
        let visiableCellIndex = self.dataCollectionView.visibleCurrentCellIndexPath?.row ?? -1
        
        if visiableCellIndex + 1  >= lastIndex {
           // self.rightArrow.isHidden = true
            //self.leftArrow.isHidden = false
            self.dataCollectionView.scrollToItem(at:IndexPath(item: visiableCellIndex  + 1, section: 0), at: .right, animated: false)
        }else {
            self.dataCollectionView.scrollToItem(at:IndexPath(item: visiableCellIndex  + 1, section: 0), at: .right, animated: false)
           // self.rightArrow.isHidden = false
           // self.leftArrow.isHidden = false
            
        }
        
 
//        if(visiableCellIndex - 1 == 0) {
//            self.leftArrow.isHidden = false
//        }else {
//            self.leftArrow.isHidden = true
//        }
        
      
         
    }
    
    @objc func leftArrowTapped(_ sender: UIButton) {
        
        let visiableCellIndex = self.dataCollectionView.visibleCurrentCellIndexPath?.row ?? -1
        
        if(visiableCellIndex - 1 <= 0) {
           // self.leftArrow.isHidden = true
           // self.rightArrow.isHidden = false
            self.dataCollectionView.scrollToItem(at:IndexPath(item: visiableCellIndex  - 1, section: 0), at: .right, animated: false)
        
        }else {
          //  self.leftArrow.isHidden = false
          //  self.rightArrow.isHidden = true
            self.dataCollectionView.scrollToItem(at:IndexPath(item: visiableCellIndex  - 1, section: 0), at: .right, animated: false)
        
        }
        
        if (visiableCellIndex + 1  == lastIndex) {
           // self.rightArrow.isHidden = true
        }else {
           // self.rightArrow.isHidden = false
        }
    
    }
    
    
    func showHideArrows() {
        
        let visiableCellIndex = self.dataCollectionView.visibleCurrentCellIndexPath?.row ?? 0
      
        if(visiableCellIndex == 0) {
          //  self.leftArrow.isHidden = true
        }else {
           // self.leftArrow.isHidden = false
        }
        if(visiableCellIndex == lastIndex) {
           // self.rightArrow.isHidden = true
        }else {
           // self.rightArrow.isHidden = false
        }
    }
    
    
    
}
extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}


 
extension Array {
  init(repeating: [Element], count: Int) {
    self.init([[Element]](repeating: repeating, count: count).flatMap{$0})
  }

  func repeated(count: Int) -> [Element] {
    return [Element](repeating: self, count: count)
  }
}



extension PreViewVC {
    
    

       @IBAction func nextTapped(_ sender: Any) {
           if currentPage < attachments.count-1 {

               currentPage += 1
               self.dataCollectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
           }
       }

       @IBAction func previousTapped(_ sender: Any) {
           if currentPage > 0 {

               currentPage -= 1
               self.dataCollectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
               //self.questionIndexCollectionView.reloadData()

           }
       }
    
}
