//
//  ImageViewController.h
//  Ribbit
//
//  Created by Kevin Duck on 8/25/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
