//
//  EditingPostViewController.swift
//  PetSNS
//
//  Created by 大西玲音 on 2021/08/23.
//

import UIKit

final class EditingPostViewController: UIViewController {
    
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var postButton: UIBarButtonItem!
    @IBOutlet private weak var postedPhotosView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var commentTextView: UITextView!
    
    private let indicator = Indicator(kinds: PKHUDIndicator())
    private var photoData: Data!
    func receivePhoto(photoData: Data) {
        self.photoData = photoData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPostedPhotosView()
        
    }
    
    @IBAction private func postButtonDidTapped(_ sender: Any) {
        indicator.show(.progress)
        var isSavedPost = false
        var isSavedData = false
        var errorMessage: String?
        let post = Post(id: UUID().uuidString,
                        imageData: photoData,
                        text: commentTextView.text ?? "")
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        PostUtil().save(post: post) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .failure(let title):
                errorMessage = title
            case .success:
                isSavedPost = true
            }
        }
        
        PostUtil().saveData(postId: post.id,
                            data: photoData) { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .failure(let title):
                errorMessage = title
            case .success:
                isSavedData = true
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            switch (isSavedPost, isSavedData) {
            case (true, true):
                self.indicator.flash(.success) {
                    NotificationCenter.default.post(name: .showHomeVC,
                                                    object: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.dismiss(animated: true)
                    }
                }
            default:
                self.indicator.flash(.error) {
                    self.showErrorAlert(title: errorMessage ?? "投稿できませんでした。")
                }
            }
        }
        
    }
    
    @IBAction private func cancelButtonDidTapped(_ sender: Any) {
        showTwoChoicesAlert(title: "この画面を閉じると編集中の投稿は破棄されますが、よろしいですか？",
                            cancelTitle: "キャンセル",
                            destructiveTitle: "破棄",
                            destructiveHandler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
}

// MARK: - setup
extension EditingPostViewController {
    
    private func setupPostedPhotosView() {
        guard let photoImage = UIImage(data: photoData) else { return }
        let photoImageView = UIImageView()
        photoImageView.image = photoImage
        postedPhotosView.addSubview(photoImageView)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [photoImageView.topAnchor.constraint(equalTo: postedPhotosView.topAnchor),
                           photoImageView.bottomAnchor.constraint(equalTo: postedPhotosView.bottomAnchor),
                           photoImageView.leadingAnchor.constraint(equalTo: postedPhotosView.leadingAnchor),
                           photoImageView.trailingAnchor.constraint(equalTo: postedPhotosView.trailingAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
}
