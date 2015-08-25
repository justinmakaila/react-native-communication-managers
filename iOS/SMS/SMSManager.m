//
//  SMSManager.m
//  ParentApp
//
//  Created by Justin Makaila on 7/15/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "SMSManager.h"
#import <MessageUI/MessageUI.h>

@interface SMSManager () <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) RCTResponseSenderBlock completion;

@end

@implementation SMSManager

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
  if (self.completion) {
    self.completion(@[@(result)]);
  }
  
  self.completion = nil;
  
  [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)rootViewController {
  return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(messageNumber:(NSString *)phoneNumber completion:(RCTResponseSenderBlock)completion) {
  [self messageNumber:phoneNumber message:nil completion:completion];
}

RCT_REMAP_METHOD(messageNumberWithMessage, messageNumber:(NSString *)phoneNumber message:(NSString *)message completion:(RCTResponseSenderBlock)completion) {
  if ([MFMessageComposeViewController canSendText]) {
    self.completion = completion;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:@[phoneNumber]];
    [messageController setBody:message];
    
    [[self rootViewController] presentViewController:messageController animated:YES completion:nil];
  }
  else {
    // TODO: Handle the error case
    if (completion) {
      completion(@[@"This device does not support sending text messages"]);
    }
  }
}

@end
