//
//  cAddressBook.m
//  VaxPhone
//
//  Created by VaxSoft [www.vaxvoip.com]
//  Copyright 2014 VaxSoft. All rights reserved.
//

#import "cAddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation cAddressBook

- (id) init;
{	
    mAddressBook = ABAddressBookCreate();
    
    self = [super init];
	return self;
}

- (void) dealloc;
{	
    CFRelease(mAddressBook);
    [super dealloc];
}

- (Boolean) FindRecordId :(int) nRecordId;
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(mAddressBook, nRecordId);

    if(person == NULL)
        return false;
    
    //CFRelease(person); // Not a memory leak: No need otherwise application crash.
    return true;
}

- (NSString*) FindContactNameWithPhoneNo :(NSString*) pPhoneNo;
{
     NSMutableString* pResult = [[NSMutableString new] autorelease];
    int nABContactId = -1;
    
    if(![self FindContactWithPhoneNo: pPhoneNo: pResult: &nABContactId])
        return NULL;
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(mAddressBook, nABContactId);
    
    while(true)
    {
        NSString* pName = (NSString*) ABRecordCopyCompositeName(person);
        
        if(pName != NULL)
        {
            [pResult setString: pName];
            CFRelease((CFStringRef) pName);
            break;
        }
    }

    //CFRelease(person); // Not a memory leak: No need otherwise application crash.
    return pResult;
}

+ (NSString*) FilterPhoneNo :(NSString*) pPhoneNo;
{
    pPhoneNo = [pPhoneNo stringByReplacingOccurrencesOfString:@"(" withString:@""];
    pPhoneNo = [pPhoneNo stringByReplacingOccurrencesOfString:@")" withString:@""];
    pPhoneNo = [pPhoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    pPhoneNo = [pPhoneNo stringByReplacingOccurrencesOfString:@"." withString:@""];
    pPhoneNo = [pPhoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return pPhoneNo;
}

- (Boolean) FindContactWithPhoneNo :(NSString*) pPhoneNo :(NSMutableString*) pPhoneLabel :(int*) pABRecorId;
{
    CFArrayRef RefAllPeopleAB = ABAddressBookCopyArrayOfAllPeople(mAddressBook);
    CFIndex nTotalPersonCount = ABAddressBookGetPersonCount(mAddressBook);
    
    Boolean bPhoneNoFound = false;
    
    for(CFIndex nPersonCount = 0; nPersonCount < nTotalPersonCount; nPersonCount++)
    {
        ABRecordRef RefRecordAB = CFArrayGetValueAtIndex(RefAllPeopleAB, nPersonCount);
        
        ABMultiValueRef* RefAllPhonesAB = (ABMultiValueRef*) ABRecordCopyValue(RefRecordAB, kABPersonPhoneProperty);
        
        for(CFIndex nPhoneCount = 0; nPhoneCount < ABMultiValueGetCount(RefAllPhonesAB); nPhoneCount++)
        {
            CFStringRef RefPhoneLabel = ABMultiValueCopyLabelAtIndex(RefAllPhonesAB, nPhoneCount);
            NSString *pContactPhoneLabel = (NSString*) ABAddressBookCopyLocalizedLabel(RefPhoneLabel);
            
            CFStringRef RefPhoneNumber = ABMultiValueCopyValueAtIndex(RefAllPhonesAB, nPhoneCount);
            NSString* pContactPhoneNo = (NSString *)RefPhoneNumber;
            
            pContactPhoneNo = [cAddressBook FilterPhoneNo: pContactPhoneNo];
            
            if([pContactPhoneNo isEqualToString: pPhoneNo])
            {
                [pPhoneLabel setString: pContactPhoneLabel];
                CFRelease(RefPhoneLabel);
                
                CFRelease(RefPhoneNumber);
                bPhoneNoFound = true;
                
                break;
            }
            
            CFRelease(RefPhoneNumber);
            CFRelease(RefPhoneLabel);
        }
        
        if(bPhoneNoFound)
        {
            *pABRecorId = ABRecordGetRecordID(RefRecordAB);
            
            //CFRelease(RefRecordAB); // Not a memory leak: No need otherwise application crash.
            CFRelease(RefAllPhonesAB);
            
            break;
        }
        
        //CFRelease(RefRecordAB); // Not a memory leak: No need otherwise application crash.
        CFRelease(RefAllPhonesAB);
    }
    
    CFRelease(RefAllPeopleAB);
    return bPhoneNoFound;
}

- (NSString*) PersonReadPhoneNo :(ABRecordRef) person;
{
    ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if(ABMultiValueGetCount(multiPhones) == 0)
    {
        CFRelease(multiPhones);
        return NULL;
    }
    
    NSMutableString* pPhoneNo = [[NSMutableString new] autorelease];
    
    CFStringRef refPhoneNo = ABMultiValueCopyValueAtIndex(multiPhones, 0);
    [pPhoneNo setString :(NSString*) refPhoneNo];
    
    CFRelease(refPhoneNo);
    CFRelease(multiPhones);
    
    return pPhoneNo;
}

- (NSString*) PersonReadEmail :(ABRecordRef) person;
{
    ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    if(ABMultiValueGetCount(multiEmails) == 0)
    {
        CFRelease(multiEmails);
        return NULL;
    }
    
    NSMutableString* pEmail = [[NSMutableString new] autorelease];
    
    CFStringRef refEmail = ABMultiValueCopyValueAtIndex(multiEmails, 0);
    [pEmail setString :(NSString*) refEmail];
    
    CFRelease(multiEmails);
    CFRelease(refEmail);
    
    return pEmail;
}

- (NSString*) ReadContactTitle :(ABRecordID) nABContactId;
{
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(mAddressBook, nABContactId);
    
    NSMutableString* pContactTitle = [[NSMutableString new] autorelease];
    
    if(person == NULL)
    {
        [pContactTitle setString: @"No Name"];
        return pContactTitle;
    }
    
    while(true)
    {
        NSString* pName = (NSString*) ABRecordCopyCompositeName(person);
        
        if(pName != NULL)
        {
            [pContactTitle setString: pName];
            CFRelease((CFStringRef) pName);
            break;
        }
        
        NSString* pPhoneNo = [self PersonReadPhoneNo: person];
        
        if(pPhoneNo != NULL)
        {
            [pContactTitle setString: pPhoneNo];
            break;
        }
        
        NSString* pEmail = [self PersonReadEmail: person];
        
        if(pEmail != NULL)
        {
            [pContactTitle setString: pEmail];
            break; 
        }
        
        [pContactTitle setString: @"No Name"];
        break;
    }
    
    //CFRelease(person); // Not a memory leak: No need otherwise application crash.
    return pContactTitle;
}


@end
