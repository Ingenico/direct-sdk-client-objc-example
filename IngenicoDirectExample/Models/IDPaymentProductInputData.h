//
// Do not remove or alter the notices in this preamble.
// This software code is created for Ingencio ePayments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

@protocol IDPaymentItem;
@class IDAccountOnFile;
@class IDPaymentRequest;

@interface IDPaymentProductInputData : NSObject

@property (strong, nonatomic) NSObject<IDPaymentItem> *paymentItem;
@property (strong, nonatomic) IDAccountOnFile *accountOnFile;
@property (nonatomic) BOOL tokenize;
@property (nonatomic, readonly, strong) NSArray *fields;
@property (strong, nonatomic) NSMutableArray *errors;

- (IDPaymentRequest *)paymentRequest;

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;

- (void)validate;
- (void)validateExceptFields:(NSSet *)exceptionFields;
- (void)removeAllFieldValues;

@end
