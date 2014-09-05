//
//  ImageViewController.m
//  Ribbit
//
//  Created by Kevin Duck on 8/25/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
		PFFile *imageFile = [self.message objectForKey:@"file"];
		NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
		NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
		self.imageView.image = [UIImage imageWithData:imageData];
		
		NSString *senderName = [self.message objectForKey:@"senderName"];
		NSString *title = [NSString stringWithFormat:@"Sent from %@", senderName];
		self.navigationItem.title = title;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(timeout)]) {
      [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Error: missing selector");
    }
    
}

- (void) timeout {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
