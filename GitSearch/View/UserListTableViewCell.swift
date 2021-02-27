//
//  MemberItemCell.swift
//  GitSearch
//
//  Created by jc.kim on 2/26/21.
//

import UIKit
import RxSwift

// MARK: TableView Cell

class UserListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserListTableViewCell"
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var reposCountLabel: UILabel!
    
    func setData(_ data: User) {
        loadImage(from: data.imageUrl ?? "")
            .asDriver(onErrorJustReturn: UIImage(systemName: "person.fill"))
            .drive(profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        loadRepos(from: data.singleUrl ?? "")
            .asDriver(onErrorJustReturn: .init(publicRepos: -1))
            .map{"Numbers of Repos : \($0!.publicRepos)"}
            .drive(reposCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        profileImageView.image = nil
        nameLabel.text = data.name
    }
    
    var disposeBag = DisposeBag()
    
    private func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            guard let url = URL(string: url) ?? nil else {
                print("Invalid URL")
                emitter.onNext(UIImage(systemName: "person.fill"))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    private func loadRepos(from url: String) -> Observable<SingleUser?> {
        return Observable.create { emitter in
            guard let url = URL(string: url) ?? nil else {
                print("Invalid URL")
                emitter.onNext(SingleUser(publicRepos: 0))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                guard let data = data,
                      let singleUser = try? JSONDecoder().decode(SingleUser.self, from: data) else {
                    emitter.onCompleted()
                    return
                }
                
                emitter.onNext(singleUser)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
