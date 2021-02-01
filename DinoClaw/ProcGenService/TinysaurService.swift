import UIKit

class TinysaurService {
    
    private static let serviceURL = URL(string: "https://tiny.dinos.dev/1")!
    static var tinysaurCache = [TinysaurType: [UIImage]]()
    
    private enum TinySaurParameter: String {
        case small
        case outline
        case type
    }
    
    enum TinysaurType: String, CaseIterable {
        case ceratops
        case pachycephalosaur
        case ankylosaur
        case stegosaur
        case iguanodon
        case sauropod
        case largeTheropod
        case smallTheropod
    }
    
    private static var pendingRequests = 0
    
    public static let cacheCompleteNotification = Notification.Name(rawValue: "cacheCompleteNotification")
    
    public static func populateCache() {
        for type in TinysaurType.allCases {
            for _ in 0..<4 {
                pendingRequests += 1
                getTinysaur(small: true, outline: true, type: type) { image in
                    pendingRequests -= 1
                    print("Pending tinysaur requests: \(pendingRequests)")
                    guard let image = image else {
                        assertionFailure()
                        return
                    }
                    tinysaurCache[type] = (tinysaurCache[type] ?? []) + [image]
                    if pendingRequests == 0 {
                        NotificationCenter.default.post(name: cacheCompleteNotification, object: nil)
                    }
                }
            }
        }
    }
    
    public static func consumeCachedTinysaur(type: TinysaurType) -> UIImage? {
        guard let tinysaurs = tinysaurCache[type],
            let tinysaur = tinysaurs.last else {
            assertionFailure()
            return nil
        }
        tinysaurCache[type] = tinysaurs.dropLast()
        return tinysaur
    }
    
    public static func getTinysaur(small: Bool = true, outline: Bool = true, type: TinysaurType? = nil, completion: @escaping (UIImage?) -> Void) {
        var url = serviceURL
        if small {
            url = url.addParam(name: TinySaurParameter.small.rawValue, value: "true")
        }
        if !outline {
            url = url.addParam(name: TinySaurParameter.outline.rawValue, value: "false")
        }
        if let type = type {
            url = url.addParam(name: TinySaurParameter.type.rawValue, value: type.rawValue)
        }
        APIRequest.request(url: url, callBackOnMainThread: true) { data, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
}
