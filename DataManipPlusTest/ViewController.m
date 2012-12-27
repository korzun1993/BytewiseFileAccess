//
//  ViewController.m
//  DataManipPlusTest
//
//  Created by Корзун Владислав on 25.12.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "ViewController.h"
#import "DXDataChunkGenerator.h"

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
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"car" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:imgPath];
    
    NSLog(@"URL - %@",url);
    for(int i = 0;i<1000000;i++){
        [DXDataChunkGenerator dataChunkForFileAtURL:url
                                               from:0
                                             length:2048
                                     successHandler:^(NSData *chunkData, NSUInteger pointer, BOOL isFinished) {
                                         chunkData = nil;
                                     } errorHandler:nil];
    }

}

@end
