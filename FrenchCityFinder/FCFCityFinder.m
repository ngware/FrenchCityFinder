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
    }
    return self;
}

+ (id)sharedManager {
    static FCFCityFinder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)initData {
    
    NSArray *fields = [self getArrayFromCSVFile:@"base_officielle_codes_postaux_-_09102015.csv"];
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
    
    [self initData];
    
    if (zipCode.length == 5) {
        NSString *citiesString = [_zipCodeDataBase objectForKey:zipCode];
        
        cities = [citiesString componentsSeparatedByString:@";"];
    }
    return cities;
}

- (NSArray*)getCitiesFromZipCodeFast:(NSString*)zipCode {
    
    NSMutableArray *cities = nil;
    
    NSString *citiesString = nil;
    NSString *zipCodeFile = nil;
    NSArray *fields = nil;
    NSArray *splittedField = nil;
    
    if (zipCode.length == 5) {
        
        cities = [NSMutableArray new];
        zipCodeFile = [NSString stringWithFormat:@"%@.csv", [zipCode substringToIndex:2]];
        fields = [self getArrayFromCSVFile:zipCodeFile];
        
        for (NSArray *field in fields) {
            splittedField = [[field objectAtIndex:0] componentsSeparatedByString:@";"];
            if ([zipCode isEqualToString:[splittedField objectAtIndex:0]]) {
                [cities addObject:[splittedField objectAtIndex:1]];
            }
        }

    }
    return [cities copy];
}

/* CreateSmallerZipCodeFiles
 * The aim of this method is to create multiple files from the base zipCode file in order to reduce the research execution time
 * we are going to create 98 files that are containing  values corresponding to the first two digit of the zip codes
 * ex: first file contains all the cities that have a zipcode starting with 01 (01xxx), the second all starting with 02 etc.
 *
 * output: files will be written in the iTunes shared files folder of the app
*/

- (void)createSmallerZipCodeFiles {
    
    NSString *zipCode = nil;
    NSString *cityName = nil;
    NSString *zipCodeFirstTwoNumber = nil;
    NSString *field = nil;
    NSString *simplifiedField = nil; // we just need the zipCode and the corresponding city name so we won't use the original field
    NSString *filePath = nil;
    NSArray *fields = nil;
    NSArray *splittedField = nil;
    BOOL success;
    NSError *error;
    NSMutableString *fileString = nil;
    NSMutableDictionary *filesContainer = nil;
    NSMutableArray *fileContent = nil;
    
    filesContainer = [NSMutableDictionary new];
    
    fields = [self getArrayFromCSVFile:@"base_officielle_codes_postaux_-_09102015.csv"];
    
    for (NSArray *fieldArray in fields) {
        if (fieldArray.count == 1) {
            field = [fieldArray objectAtIndex:0];
            splittedField = [field componentsSeparatedByString:@";"];
            if (splittedField.count == 4) {
                zipCode = [splittedField objectAtIndex:2];
                cityName = [splittedField objectAtIndex:1];
                zipCodeFirstTwoNumber = [zipCode substringToIndex:2];
                
                if ([filesContainer objectForKey:zipCodeFirstTwoNumber] == nil) {
                    fileContent = [NSMutableArray new];
                }else {
                    fileContent = [filesContainer objectForKey:zipCodeFirstTwoNumber];
                }
                simplifiedField = [NSString stringWithFormat:@"%@;%@", zipCode, cityName];
                [fileContent addObject:simplifiedField];
                [filesContainer setObject:fileContent forKey:zipCodeFirstTwoNumber];
            }
        }
    }
    
    // now we have a dictionnary (filesContainer) thats contains arrays (fileContent) with the corresponding fields to write so lets' go
    for (NSString *key in filesContainer) {
        fileContent = [filesContainer objectForKey:key];
        fileString = [ [NSMutableString alloc] init];
        
        for (NSString *field in fileContent) {
            [fileString appendString:[NSString stringWithFormat:@"%@\n", field]];
        }
        
        filePath = [self getiTunesFilePathForFile:[NSString stringWithFormat:@"%@.csv", key]];
        
        // Now write the file to iTunes
        success = [fileString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!success)
        {
            NSLog(@"Error writing file: %@", error.localizedFailureReason);
            return;
        }
    }
}

-(NSString*)getiTunesFilePathForFile:(NSString*)fileName {
    NSString *filePath = nil;
    NSString *documentsPath = nil;
    
    documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    return filePath;
    
}

-(NSArray*)getArrayFromCSVFile:(NSString*)fileName {
    
    NSArray *result = nil;
    NSArray *fileNameComponent = [fileName componentsSeparatedByString:@"."];
    
    if (fileNameComponent.count == 2 && [[fileNameComponent objectAtIndex:1] isEqualToString:@"csv"]) {
        
        NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:[fileNameComponent objectAtIndex:0] ofType:@"csv"];
        
        if (file != nil) {
            result = [NSArray arrayWithContentsOfCSVFile:file];
        }
    }

    return result;
}

@end
