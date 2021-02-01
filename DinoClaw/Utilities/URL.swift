//Roar

import Foundation

extension URL {
    public func addParam(name: String, value: String?) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
        var query = components.queryItems ?? [URLQueryItem]()
        query.append(URLQueryItem(name: name, value: value))
        components.queryItems = query
        return components.url ?? self
    }

    public func addParams(_ params: [String: String?]) -> URL {
        var url = self
        for param in params {
            url = url.addParam(name: param.key, value: param.value)
        }
        return url
    }
}
