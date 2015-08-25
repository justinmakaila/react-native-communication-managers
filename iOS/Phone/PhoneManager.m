//
//  PhoneManager.m
//  ParentApp
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "PhoneManager.h"
#import <UIKit/UIKit.h>

@implementation PhoneManager

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(callNumber:(NSString *)phoneNumber) {
  NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
  if ([[UIApplication sharedApplication] canOpenURL:phoneNumberURL]) {
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
  }
  else {
    UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [notPermitted show];
  }
  
}

@end
