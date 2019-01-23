//
//  MockData.swift
//  SpiltCoffee
//
//  Created by Trevor Adcock on 7/28/18.
//  Copyright © 2018 DevMountain. All rights reserved.
//

import UIKit
import CoreLocation

class MockRoasters{
    
    //Roasters
    static let jayden = Roaster(name: "Jayden Garick", email: "jgarick@roaster.com", profilePicture: #imageLiteral(resourceName: "profile"))
    static let adam = Roaster(name: "Adam Moskovich", email: "ThePainInTheAss@gmail.com", profilePicture: #imageLiteral(resourceName: "profile"))
    
    static var roasters: [Roaster] {
        
        let roasters = [jayden, adam]
        for roaster in roasters{
            roaster.postIds = []
            roaster.companyName = "Blue Bird Coffee"
        }
        
        
        
        return roasters
    }
    
    
}

struct MockBeans {
    //Favorite Beans
    static var images: [UIImage]? = [#imageLiteral(resourceName: "DefaultPicture")]
    static let favorites: [CoffeeBean] = {
        return [
            CoffeeBean(name: "Veranda", price: 32.99, description: "Light roast which is slightly better than pikes but not by all that much", photos: images, roaster: MockRoasters.adam, roastType: .light, origin: Origin.countries[1]),
            CoffeeBean(name: "Veranda", price: 32.99, description: "Light roast which is slightly better than pikes but not by all that much", photos: images, roaster: MockRoasters.adam, roastType: .light, origin: Origin.countries[1]),
            CoffeeBean(name: "Veranda", price: 32.99, description: "Light roast which is slightly better than pikes but not by all that much", photos: images, roaster: MockRoasters.adam, roastType: .light, origin: Origin.countries[1]),
            CoffeeBean(name: "Veranda", price: 32.99, description: "Light roast which is slightly better than pikes but not by all that much", photos: images, roaster: MockRoasters.adam, roastType: .light, origin: Origin.countries[1]),
            CoffeeBean(name: "Onyx Blend", price: 23.99, description: "Medium blend with all the good stuff", photos: images, roaster: MockRoasters.jayden, roastType: .medium, origin: Origin.countries[1]),
            CoffeeBean(name: "Public Roast", price: 32.50, description: "Crisp Airly blend with only slight hints of pretentiousness", photos: images, roaster: MockRoasters.jayden, roastType: .light, origin: Origin.countries[1])
        ]
    }()
}

struct MockPosts{
    static let post1 = Post(title: "Cold Brews in New York", subtitle: "How to long is too long", date: Date(timeIntervalSinceNow: 1000000), author: MockRoasters.jayden, bodyText: "This Monday morning, we've got money on our minds: According to a new survey by TD Bank, 75% of millennial couples talk about money at least once a week. Compare that to 66% of Gen X couples and 44% of Baby Boomer couples. Is this...healthy? We'd say talk about it with your partner, but you probably are already.", photos: [#imageLiteral(resourceName: "DefaultPicture"),#imageLiteral(resourceName: "DefaultPicture")], likesCount: 42)
    static let post2 = Post(title: "NYC vs Uber", subtitle: "New York City could become the first major U.S. city to cap the number of vehicles driving for Uber", date: Date(timeIntervalSinceNow: 1000000), author: MockRoasters.adam, bodyText:
        """
        The case against Uber: City officials accuse ride-hailers of 1) eviscerating the yellow taxi industry and 2) clogging NYC's streets.
        
        Let's dive in.
        
        Gripe #1: While Uber's exploded in NYC, the classic yellow taxis have suffered.
        
        Take the price of a medallion, for example (what's required to operate a yellow cab). In 2013, they went for $1.3 million. Now? They're being sold for as low as $160,000.
        Six professional drivers have committed suicide since December.
        Gripe #2: Congestion. NYC has a traffic problem, and according to a recent study by transportation guru Bruce Schaller, ride-hailers are making the problem worse, not better.
        
        If ride-hailers weren't available, ~60% of users in large, dense cities would have either walked, biked, taken public transportation...or not traveled at all.
        Ride-hailers account for an overall 160% increase in driving on city streets.
        Uber's fighting back
        Here's what Josh Gold, a spokesman for Uber, had to say:
        
        Not only will the cap "leave New Yorkers stranded while doing nothing to prevent congestion," it'll hurt riders "who have come to rely on Uber because their communities have long been ignored by yellow taxis and do not have reliable access to public transit."
        One potential Uber ally: Vocal members of New York's black community, who do feel like they've been ignored by yellow taxis due to racial bias.
        
        Don't live in New York? You should still care
        As Frank Sinatra once sang about the city, "If I can make it there, I'm gonna make it anywhere." And we're pretty sure he was talking about ride-hailing regulation.
        
        Meaning, as other major cities around the world try to deal with the Uber phenomenon, they might look to NYC, the U.S.' most populous city, as a laboratory for reining in ride-hailers.
        """
        , photos: [#imageLiteral(resourceName: "DefaultPicture"), #imageLiteral(resourceName: "profile")], likesCount: 345)
    
    static let posts = [MockPosts.post1, MockPosts.post2, MockPosts.post1, MockPosts.post2]
}

struct MockProducts{
    static let pictures = [#imageLiteral(resourceName: "DefaultPicture")]
    static let grider = Product(name: "Coffee Grinder", price: 42.55, description: "Grinds Coffee", photos: pictures, roaster: MockRoasters.roasters[0], productType: .grinder)
    static let scale = Product(name: "Coffee Sca;e", price: 34.55, description: "Weighs Coffee", photos: pictures, roaster: MockRoasters.roasters[0], productType: .scale)
    static let other = Product(name: "Coffee Something else", price: 12.55, description: "Coffee coffee coffee", photos: pictures, roaster: MockRoasters.roasters[0], productType: .brewing)
    
    static let products: [Product] = {
        return [grider, scale, other]
    }()
}
