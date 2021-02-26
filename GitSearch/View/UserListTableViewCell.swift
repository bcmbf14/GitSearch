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
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var job: UILabel!
    @IBOutlet var age: UILabel!
    
    func setData(_ data: User) {
        loadImage(from: data.avatarUrl ?? "")
            .observe(on: MainScheduler.instance)
            .bind(to: avatar.rx.image)
            .disposed(by: disposeBag)
        
        print(data.url)
        
        loadRepos(from: data.url ?? "")
            .map{"\($0!.publicRepos)"}
            .observe(on: MainScheduler.instance)
            .bind(to: job.rx.text)
            .disposed(by: disposeBag)
        
        
            
        
        avatar.image = nil
        name.text = data.login
//        job.text = data.login
        age.text = "(\(data.login))"
    }
    
    var disposeBag = DisposeBag()
    
    private func loadImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            guard let url = URL(string: url) ?? nil else {
                print("Invalid URL")
                emitter.onNext(UIImage(systemName: "trash"))
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
