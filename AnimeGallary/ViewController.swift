//
//  ViewController.swift
//  AnimeGallary
//
//  Created by KhaleD HuSsien on 14/09/2022.

import UIKit
class ViewController: UIViewController {
    
    //MARK: - Outlets & Vars
    @IBOutlet weak var trashImageView: UIImageView!
    var animeGallary: [UIImage] = [
        #imageLiteral(resourceName: "Pin by Aelipy - on Aesthetic anime _ Anime character design, Character art, Character design"),#imageLiteral(resourceName: "chin_ishi on Twitter.jpeg"),#imageLiteral(resourceName: "Dark Anime_ 40 Unforgettable Dark Anime Characters _ Asiana Circus.jpeg"),#imageLiteral(resourceName: "Demon Slayer on Twitter.jpeg"),#imageLiteral(resourceName: "How to draw Gojo Satoru from Jujutsu Kaisen.jpeg"),#imageLiteral(resourceName: "Log in to Twitter _ Twitter.png"),#imageLiteral(resourceName: "Pin by Aelipy - on Aesthetic anime _ Anime character design, Character art, Character design.jpeg"),#imageLiteral(resourceName: "Sad boy wallpaper (HD).jpeg"),#imageLiteral(resourceName: "Toastie on Twitter.png"),#imageLiteral(resourceName: "𝙒𝙖𝙡𝙡𝙥𝙖𝙥𝙚𝙧.jpeg"),#imageLiteral(resourceName: "およ on Twitter.jpeg"),#imageLiteral(resourceName: "天外来物——半, TZ BARD.jpeg"),#imageLiteral(resourceName: "習作 on Twitter.png")
    ]
    var nextIndex = 0
    var currentImage: UIImageView?
    let originalSize: CGFloat = 300
    var activeSize: CGFloat {
        return originalSize + 10
    }
    var isAvtive = false
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextPicture()
    }
    //MARK: -functions
    func showNextPicture(){
        if let newPicture = createPicture(){
            currentImage = newPicture
            showPicture(newPicture)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            newPicture.addGestureRecognizer(tap)
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipe.direction = .up
            newPicture.addGestureRecognizer(swipe)
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            pan.delegate = self
            newPicture.addGestureRecognizer(pan)
        }else{
            nextIndex = 0
            showNextPicture()
        }
    }
    
    func createPicture()-> UIImageView? {
        guard nextIndex < animeGallary.count else{return nil}
        let imageView = UIImageView(image: animeGallary[nextIndex])
        imageView.frame = CGRect(x: view.frame.width, y: view.center.y - (originalSize/2), width: originalSize, height: originalSize)
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 10
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        
        
        
        nextIndex += 1
        return imageView
    }
    
    func showPicture(_ imageView: UIImageView){
        self.view.addSubview(imageView)
        UIView.animate(withDuration: 0.4) {
            imageView.center = self.view.center
        }
    }
    
    func deleteImage(_ image: UIImageView){
        self.animeGallary.remove(at: nextIndex - 1)
        isAvtive = false
        UIView.animate(withDuration: 0.4) {
            image.alpha = 0
        } completion: { _ in
            image.removeFromSuperview()
        }
        showNextPicture()
        
    }
    
    func activateCurrentPicture(){
        UIView.animate(withDuration: 0.3) {
            self.currentImage?.frame.size = CGSize(width: self.activeSize, height: self.activeSize)
            self.currentImage?.layer.shadowOpacity = 0.3
            self.currentImage?.layer.borderColor = UIColor.green.cgColor
        }
    }
    func deactivateCurrentPicture(){
        UIView.animate(withDuration: 0.3) {
            self.currentImage?.frame.size = CGSize(width: self.originalSize, height: self.originalSize)
            self.currentImage?.layer.shadowOpacity = 0
            self.currentImage?.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    func processPictureMovement(sender: UIPanGestureRecognizer , view: UIImageView){
        let translation = sender.translation(in: view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(.zero, in: view)
        if view.frame.intersects(self.trashImageView.frame){
            view.layer.borderColor = UIColor.red.cgColor
        }else{
            view.layer.borderColor = UIColor.green.cgColor
        }
    }
    func hidePicture(_ imageView: UIImageView){
        UIView.animate(withDuration: 0.4) {
            self.currentImage?.frame.origin.y = -self.originalSize
        } completion: { _ in
            imageView.removeFromSuperview()
        }
        
    }
    //MARK: - @Objc func
    @objc func handleTap(){
        isAvtive = !isAvtive
        if isAvtive{
            activateCurrentPicture()
        }else{
            deactivateCurrentPicture()
        }
    }
    @objc func handleSwipe(){
        guard !isAvtive else{return}
        guard let image = currentImage else {return}
        hidePicture(image)
        showNextPicture()
    }
    @objc func handlePan(sender: UIPanGestureRecognizer){
        guard let view = currentImage , isAvtive else{return}
        switch sender.state {
        case .began , .changed:
            processPictureMovement(sender: sender, view: view)
        case .ended:
            if view.frame.intersects(trashImageView.frame){
                deleteImage(view)
            }
        case .possible:
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
        }
    }
}
//MARK: - UIGestureRecognizerDelegate
extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
