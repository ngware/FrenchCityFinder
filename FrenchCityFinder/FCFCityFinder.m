//
//  EBUCityFinderFR.m
//  FrenchCityFinder
//
//  Created by Nicolas on 06/11/2015.
//  Copyright © 2015 NGWare. All rights reserved.
//

#import "FCFCityFinder.h"
#import "CHCSVParser.h"

@interface FCFCityFinder ()

@property (strong, nonatomic) NSMutableDictionary *zipCodeDataBase;

@end

@implementation FCFCityFinder

- (id)init {
    
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

+ (id)sharedManager {
    static FCFCityFinder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager initData];
    });
    return sharedMyManager;
}

- (void)initData {
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"base_officielle_codes_postaux_-_09102015" ofType:@"csv"];
    NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSArray *fields = [NSArray arrayWithContentsOfCSVFile:file];
    _zipCodeDataBase = [NSMutableDictionary new];
    for (NSArray *fieldArray in fields) {
        if (fieldArray.count == 1) {
            NSString *field = [fieldArray objectAtIndex:0];
            NSArray *splittedField = [field componentsSeparatedByString:@";"];
            if (splittedField.count == 4) {
                NSString *zipCode = [splittedField objectAtIndex:2];
                if ([_zipCodeDataBase objectForKey:zipCode] == nil) {
                    [_zipCodeDataBase setValue:[splittedField objectAtIndex:1] forKey:zipCode];
                }else {
                    NSString *concatString = [NSString stringWithFormat:@"%@;%@", [_zipCodeDataBase objectForKey:zipCode], [splittedField objectAtIndex:1]];
                    [_zipCodeDataBase setValue:concatString forKey:zipCode];
                }
            }
        }
    }
}

- (NSArray*)getCitiesFromZipcode:(NSString*)zipCode {
    
    NSArray *cities = nil;
    
    if (zipCode.length == 5) {
        NSString *citiesString = [_zipCodeDataBase objectForKey:zipCode];
        
        cities = [citiesString componentsSeparatedByString:@";"];
    }
    return cities;
}

@end
