//
//  STATextView+PrivateHeaders.h
//  STATextField
//
//  Created by Aaron Jubbal on 12/27/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STATextView.h"

@interface STATextView (PrivateHeaders)

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
