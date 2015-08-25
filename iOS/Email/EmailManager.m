//
//  EmailManager.m
//  ParentApp
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "EmailManager.h"

#import <MessageUI/MessageUI.h>

@interface EmailManager () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation EmailManager

- (UIViewController *)rootViewController {
  return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  if (self.completion) {
    id errorObject = (error == nil) ? [NSNull null] : error;
    self.completion(@[errorObject, @(result)]);
  }
  
  self.completion = nil;
  
  [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(composeEmailTo:(NSString *)recipient completion:(RCTResponseSenderBlock)completion) {
  [self composeEmailTo:recipient subject:nil completion:completion];
}

RCT_REMAP_METHOD(composeEmailWithSubject, composeEmailTo:(NSString *)recipient subject:(NSString *)subject completion:(RCTResponseSenderBlock)completion) {
  [self composeEmailTo:recipient subject:subject body:nil completion:completion];
}

RCT_REMAP_METHOD(composeEmailWithSubjectAndBody, composeEmailTo:(NSString *)recipient subject:(NSString *)subject body:(NSString *)body completion:(RCTResponseSenderBlock)completion) {
  if ([MFMailComposeViewController canSendMail]) {
    self.completion = completion;
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setToRecipients:@[recipient]];
    [mailController setSubject:subject];
    [mailController setMessageBody:body isHTML:NO];
    
    [[self rootViewController] presentViewController:mailController animated:YES completion:nil];
  }
  else {
      // TODO: Handle the error case
    if (completion) {
      completion(@[@"This device does not support sending email"]);
    }
  }

}

@end
