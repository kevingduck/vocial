//
//  SignupViewController.h
//  Ribbit
//
//  Created by Kevin Duck on 8/18/14.
//  Copyright (c) 2014 Kevin Duck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)signup:(id)sender;

@end
