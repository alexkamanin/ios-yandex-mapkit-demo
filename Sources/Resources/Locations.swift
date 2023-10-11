import YandexMapsMobile

enum Locations {
    
    enum SaintPetersburg {
        
        static let target = YMKPoint(latitude: 59.945933, longitude: 30.320045)
    }
    
    enum Moscow {
        
        static let target = YMKPoint(latitude: 55.753222, longitude: 37.622089)
        
        static var clusters: [YMKPoint] {
            get {
                let clustersCount = 2000
                var points = [YMKPoint]()
                
                for _ in 0..<clustersCount {
                    let latitude = target.latitude + Double(arc4random()) / Double(UINT32_MAX)  - 0.5
                    let longitude = target.longitude + Double(arc4random()) / Double(UINT32_MAX)  - 0.5
                    let point = YMKPoint(latitude: latitude, longitude: longitude)
                    
                    points.append(point)
                }

                return points
            }
        }
        
        static let placemarks = [
                YMKPoint(latitude: 55.755188, longitude: 37.616536),
                YMKPoint(latitude: 55.754478, longitude: 37.617818),
                YMKPoint(latitude: 55.753458, longitude: 37.619591),
                YMKPoint(latitude: 55.752565, longitude: 37.621434),
                YMKPoint(latitude: 55.752290, longitude: 37.621665),
                YMKPoint(latitude: 55.751890, longitude: 37.621969),
                YMKPoint(latitude: 55.751254, longitude: 37.622400),
                YMKPoint(latitude: 55.749803, longitude: 37.623317),
                YMKPoint(latitude: 55.749700, longitude: 37.622122),
                YMKPoint(latitude: 55.749608, longitude: 37.620420),
                YMKPoint(latitude: 55.749555, longitude: 37.618999),
                YMKPoint(latitude: 55.749350, longitude: 37.617928),
                YMKPoint(latitude: 55.748691, longitude: 37.615251),
                YMKPoint(latitude: 55.748122, longitude: 37.613692),
                YMKPoint(latitude: 55.748931, longitude: 37.612572),
                YMKPoint(latitude: 55.749447, longitude: 37.612816),
                YMKPoint(latitude: 55.750600, longitude: 37.613560),
                YMKPoint(latitude: 55.752272, longitude: 37.614488),
                YMKPoint(latitude: 55.753698, longitude: 37.615569),
        ]
        
        static let excludePlacemarks = [
            YMKPoint(latitude: 55.751937, longitude: 37.617883),
            YMKPoint(latitude: 55.751025, longitude: 37.618597),
            YMKPoint(latitude: 55.751536, longitude: 37.619504),
            YMKPoint(latitude: 55.752244, longitude: 37.618435),
        ]
        
        static var draggablePlacemarks: [YMKPoint] {
            get {
                placemarks.map { point in
                    YMKPoint(
                        latitude: point.latitude - Double.random(in: 0.005...0.01),
                        longitude: point.longitude + Double.random(in: 0.005...0.01)
                    )
                }
                .filter { _ in Bool.random() }
            }
        }
        
        static let viewPlacemarks = [
            YMKPoint(latitude: 55.747094, longitude: 37.620187)
        ]
        
        static let circlePlacemark = YMKPoint(latitude: 55.756796, longitude: 37.622787)
        
        static let polylinePoints = [
            YMKPoint(latitude: 55.752253, longitude: 37.624226),
            YMKPoint(latitude: 55.752865, longitude: 37.628599),
            YMKPoint(latitude: 55.753188, longitude: 37.632852),
        ]

        static let coloredPolylinePoints = [
            YMKPoint(latitude: 55.747464, longitude: 37.611860),
            YMKPoint(latitude: 55.748431, longitude: 37.611042),
            YMKPoint(latitude: 55.749146, longitude: 37.609522),
            YMKPoint(latitude: 55.749797, longitude: 37.609323),
            YMKPoint(latitude: 55.751747, longitude: 37.610417),
            YMKPoint(latitude: 55.752384, longitude: 37.610896),
            YMKPoint(latitude: 55.752643, longitude: 37.611184),
            YMKPoint(latitude: 55.752643, longitude: 37.611184),
            YMKPoint(latitude: 55.754573, longitude: 37.612259),
            YMKPoint(latitude: 55.756597, longitude: 37.614620),
            YMKPoint(latitude: 55.757208, longitude: 37.615923),
            YMKPoint(latitude: 55.758409, longitude: 37.617798),
            YMKPoint(latitude: 55.759436, longitude: 37.623995),
            YMKPoint(latitude: 55.759436, longitude: 37.624265),
            YMKPoint(latitude: 55.759552, longitude: 37.625469),
            YMKPoint(latitude: 55.759458, longitude: 37.625925),
            YMKPoint(latitude: 55.756691, longitude: 37.629821),
            YMKPoint(latitude: 55.756567, longitude: 37.630354),
            YMKPoint(latitude: 55.754674, longitude: 37.633032),
            YMKPoint(latitude: 55.754450, longitude: 37.633262),
            YMKPoint(latitude: 55.754027, longitude: 37.633443),
            YMKPoint(latitude: 55.753165, longitude: 37.633488),
            YMKPoint(latitude: 55.750522, longitude: 37.632587),
        ]
    }
}
