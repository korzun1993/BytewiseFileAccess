//
//  ViewController.m
//  DataManipPlusTest
//
//  Created by Корзун Владислав on 25.12.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "ViewController.h"
#import "BytewiseFileAccess.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self memoryTest];
}

-(void)memoryTest
{
   NSURL * url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"XMLTest" ofType:@"xml"]];
    for(int i = 0;i<1000000;i++){
        [BytewiseFileAccess dataURL:url from:0 length:2048 successHandler:^(NSData *data, NSUInteger ptr, BOOL isFinal) {
            data = nil;
        } errorHandler:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
