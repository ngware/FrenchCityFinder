//
//  ViewController.m
//  FrenchCityFinder
//
//  Created by Nicolas on 06/11/2015.
//  Copyright © 2015 NGWare. All rights reserved.
//

#import "ViewController.h"
#import "FCFCityFinder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FCFCityFinder *cityFinder = nil;
    NSArray *cities = nil;
    NSDate *methodStart = nil;
    NSDate *methodFinish = nil;
    NSTimeInterval executionTime;
    
    cityFinder = [FCFCityFinder sharedManager];
    
    methodStart = [NSDate date];
    cities = [cityFinder getCitiesFromZipCodeFast:@"37000"];
    methodFinish = [NSDate date];
    
    executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Fast method executionTime = %f", executionTime);
    NSLog(@"Ville : %@ (%@)", [cities objectAtIndex:0], cities);
    
    methodStart = [NSDate date];
    cities = [cityFinder getCitiesFromZipcode:@"37000"];
    methodFinish = [NSDate date];
    
    executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Fast method executionTime = %f", executionTime);
    NSLog(@"Ville : %@ (%@)", [cities objectAtIndex:0], cities);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
