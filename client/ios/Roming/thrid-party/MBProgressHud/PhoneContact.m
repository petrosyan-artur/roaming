//
//  PhoneContact.m
//  iOSContacts
//
//  Created by James Roche on 24/05/2014.
//  Copyright (c) 2014 James Roche. All rights reserved.
//

#import "PhoneContact.h"
#import <AddressBook/AddressBook.h>

@implementation PhoneContact

+(PhoneContact*)getFromRef:(id)ref
{
    ABRecordRef record = (__bridge ABRecordRef)(ref);
    
    PhoneContact* contact = [[PhoneContact alloc] init];
    
    NSString* firstname = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString* lastname = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    NSString* companyname = (__bridge NSString *)ABRecordCopyValue(record, kABPersonOrganizationProperty);
    
    contact.firstName = firstname;
    contact.lastName = lastname;
    contact.businessName = companyname;
    
    NSString* composite = @"";
    if(firstname != nil){composite = [composite stringByAppendingString:[NSString stringWithFormat:@"%@ ", firstname]];}
    if(lastname != nil){composite = [composite stringByAppendingString:[NSString stringWithFormat:@"%@ ", lastname]];}
    if(companyname != nil){composite = [composite stringByAppendingString:[NSString stringWithFormat:@"(%@)", companyname]];}
    
    contact.name = composite;
    contact.email = (__bridge NSString *)ABRecordCopyValue(record, kABPersonEmailProperty);
    if(![contact.email isKindOfClass:[NSString class]]) { contact.email = @""; }
    if(![contact.businessName isKindOfClass:[NSString class]]) { contact.businessName = @""; }
    if(![contact.phone isKindOfClass:[NSString class]]) { contact.phone = @""; }
    
    ABMultiValueRef phoneNumberMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
    NSUInteger phoneNumberIndex;
    for (phoneNumberIndex = 0; phoneNumberIndex < ABMultiValueGetCount(phoneNumberMultiValue); phoneNumberIndex++)
    {
        contact.phone  = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumberMultiValue, phoneNumberIndex);
    }
    return contact;
}

+(NSArray*)contacts
{
    return [self contactsWithFilter:ContactFilterAll];
}

+(NSArray*)contactsWithFilter:(ContactFilter)filter
{
    NSMutableArray* result = [NSMutableArray array];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
        {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        accessGranted = YES;
    }
    
    
    if (accessGranted)
    {
        NSArray* contacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        for(id record in contacts)
        {
            PhoneContact* contact = [PhoneContact getFromRef:record];
            switch(filter)
            {
                case ContactFilterAll:
                    [result addObject:contact];
                    break;
                case ContactFilterPhone:
                    if(contact.phone.length > 0)
                    {
                        [result addObject:contact];
                    }
                    break;
                case ContactFilterEmail:
                    if(contact.email.length > 0)
                    {
                        [result addObject:contact];
                    }
                    break;
            }
        }
    }
    return [NSArray arrayWithArray:result];
}


@end
