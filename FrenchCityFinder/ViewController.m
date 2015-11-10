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
    FCFCityFinder *cityFinder = [FCFCityFinder sharedManager];
    
    NSArray *cities = [cityFinder getCitiesFromZipcode:@"75015"];
    
    NSLog(@"Ville : %@ (%@)", [cities objectAtIndex:0], cities);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
