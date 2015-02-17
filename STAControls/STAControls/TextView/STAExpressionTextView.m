//
//  STAExpressionTextView.m
//  STATextField
//
//  Created by Aaron Jubbal on 12/24/14.
//  Copyright (c) 2014 Aaron Jubbal. All rights reserved.
//

#import "STAExpressionTextView.h"
#import "STATextView+PrivateHeaders.h"
#import "NSMutableAttributedString+STAControls.h"

@implementation STAExpressionTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableAttributedString *)attributedStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)newString {
    
    NSRange limitRange;
    limitRange = NSMakeRange(0, [self.attributedText length]);
    
    NSMutableAttributedString *attributedString;
    if (!self.attributedText) {
        NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:newString];
        attributedString = [[NSMutableAttributedString alloc] initWithString:newText
                                                                  attributes:@{NSFontAttributeName : self.font}];
        return attributedString;
    } else {
        attributedString = [self.attributedText mutableCopy];
    }
    [attributedString enumerateAttributesInRange:limitRange
                                         options:0
                                      usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                                          if (attrs) {
//                                              [attributedString removeAttributesInDictionary:attrs forRange:range];
                                          }
                                      }];
    return attributedString;
}

- (NSAttributedString *)textView:(UITextView *)textView
attributedStringForChangeOfTextinRange:(NSRange)range
                 replacementText:(NSString *)text
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:text];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:newText
                                                                                                attributes:@{NSFontAttributeName : self.font}];
    NSMutableAttributedString *attributedString;
    NSCharacterSet *expressionCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.+-*/()"];
    if (text.length > 0 && [expressionCharacterSet characterIsMember:[text characterAtIndex:0]]) {
        if ([text isEqualToString:@"("]) {
            newText = [newText stringByAppendingString:@")"];
            if (!self.attributedText) {
                attributedString = [[NSMutableAttributedString alloc] initWithString:newText
                                                                          attributes:@{NSFontAttributeName : self.font}];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor grayColor]
                                         range:NSMakeRange(attributedString.length - 1, 1)];
                self.attributedText = attributedString;
            } else {
                [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@")"
                                                                                                       attributes:@{NSFontAttributeName : self.font,
                                                                                                                    NSForegroundColorAttributeName : [UIColor grayColor]}]];
                attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:mutableAttributedString];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor grayColor]
                                         range:NSMakeRange(attributedString.length - 1, 1)];
                self.attributedText = attributedString;
            }
            self.selectedRange = NSMakeRange(range.location + 1, range.length);
        }
    }
    return attributedString;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super textView:textView shouldChangeTextInRange:range replacementText:text];
    
    NSString *oldText = self.text;
    NSString *newText = [self.text stringByReplacingCharactersInRange:range withString:text];
    
    NSRange limitRange;
    NSRange effectiveRange;
    limitRange = NSMakeRange(0, [self.attributedText length]);
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:newText
                                                                                                attributes:@{NSFontAttributeName : self.font}];
    
    if (text.length == 0) return YES; // deletion case
    
//    NSMutableAttributedString *mutableAttributedString = [self attributedStringByReplacingCharactersInRange:range withString:text];
//    NSLog(@"mutableAttributedString: %@", mutableAttributedString);
//    self.attributedText = mutableAttributedString;
//    return NO;
    
    
//    [mutableAttributedString enumerateAttributesInRange:limitRange
//                                                options:0
//                                             usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//                                                 
//                                             }];
    
//    while (limitRange.length > 0) {
//        NSDictionary *attributes = [self.attributedText attributesAtIndex:limitRange.location
//                                                    longestEffectiveRange:&effectiveRange
//                                                                  inRange:limitRange];
//        if (effectiveRange.location != NSNotFound) {
//            [mutableAttributedString setAttributes:attributes range:effectiveRange];
//        }
////        [analyzer recordFontChange:attributeValue];
//        limitRange = NSMakeRange(NSMaxRange(effectiveRange),
//                                 NSMaxRange(limitRange) - NSMaxRange(effectiveRange));
//    }
    
    NSCharacterSet *expressionCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.+-*/()"];
    /*
    if (text.length > 0 && [expressionCharacterSet characterIsMember:[text characterAtIndex:0]]) {
        
//        self.selectedRange.location
        if ([text isEqualToString:@"("]) {
            newText = [newText stringByAppendingString:@")"];
            if (!self.attributedText) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newText
                                                                                                     attributes:@{NSFontAttributeName : self.font}];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor grayColor]
                                         range:NSMakeRange(attributedString.length - 1, 1)];
                self.attributedText = attributedString;
            } else {
                [mutableAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@")"
                                                                                                       attributes:@{NSFontAttributeName : self.font,
                                                                                                                    NSForegroundColorAttributeName : [UIColor grayColor]}]];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:mutableAttributedString];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor grayColor]
                                         range:NSMakeRange(attributedString.length - 1, 1)];
                self.attributedText = attributedString;
            }
            self.selectedRange = NSMakeRange(range.location + 1, range.length);
//            [super resizeSelfForText:newText];
            return NO;
        }
//        [super resizeSelfForText:newText];
        return YES;
    } else if (text.length == 0) { // deletion case
//        [super resizeSelfForText:newText];
        return YES;
    }*/
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"selected range: %@", NSStringFromRange(self.selectedRange));
    
    
}

@end