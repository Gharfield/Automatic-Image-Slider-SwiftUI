//
//  ViewController.swift
//  StagINC
//
//  Created by - on 2022-01-08.
//
import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var imagePageControl: UIPageControl!
    
    //MARK: - Properties
    
    let sliderImages = [UIImage(named: "3"), UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "2")]
    
    var timer = Timer()
    var counter = 0
    
    let layout = UICollectionViewFlowLayout()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupPageControl()
        startTimer()
    }
    
    //MARK: - Setup Functions
    
    private func setupCollectionView() {
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.showsHorizontalScrollIndicator = false
        
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.isScrollEnabled = true
    }
    
    private func setupPageControl() {
        
        imagePageControl.numberOfPages = sliderImages.count
        imagePageControl.currentPage = 0
    }
    
    //MARK: - Helper Functions
    
    func startTimer() {
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: - @objc Functions
    
    @objc func changeImage() {
        
        if counter < sliderImages.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.imageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            imagePageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.imageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            imagePageControl.currentPage = counter
            counter += 1
        }
    }
}

//MARK: - UICollectionViewDataSource + UICollectionViewDelegate

extension ViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.sliderImageView.image = sliderImages[indexPath.row]
        
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        imagePageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("User touched the slider!")
        timer.invalidate()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
