//
//  EBUCityFinderFR.h
//  FrenchCityFinder
//
//  Created by Nicolas on 06/11/2015.
//  Copyright © 2015 NGWare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCFCityFinder : NSObject

+ (id)sharedManager;

- (NSArray*)getCitiesFromZipcode:(NSString*)zipCode;

@end
