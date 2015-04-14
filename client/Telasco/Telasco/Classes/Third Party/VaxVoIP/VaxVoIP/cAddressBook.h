//
//  cAddressBook.h
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface cAddressBook : NSObject
{
    ABAddressBookRef mAddressBook;
}

- (id) init;
- (void) dealloc;

- (NSString*) FindContactNameWithPhoneNo :(NSString*) pPhoneNo;
- (Boolean) FindRecordId :(int) nRecordId;
- (Boolean) FindContactWithPhoneNo :(NSString*) pPhoneNo :(NSMutableString*) pPhoneLabel :(int*) pABRecorId;
- (NSString*) ReadContactTitle :(ABRecordID) nABContactId;

+ (NSString*) FilterPhoneNo :(NSString*) pPhoneNo;

@end
