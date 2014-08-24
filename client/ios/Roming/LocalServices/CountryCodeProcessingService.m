//
//  CountryCodeProcessingService.m
//  Roming
//
//  Created by Karen Ghandilyan on 8/23/14.
//  Copyright (c) 2014 telasco. All rights reserved.
//

#import "CountryCodeProcessingService.h"
#import "CountryObject.h"

@interface CountryCodeProcessingService()

@property (nonatomic, strong) NSMutableArray *countryCodes;

@end

@implementation CountryCodeProcessingService
@synthesize countryCodes;
static id sharedInstance;

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        countryCodes = [[NSMutableArray alloc] init];
        [self loadCodesFromResourceJson];
    }
    return self;
}

-(void)loadCodesFromResourceJson {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"country_codes" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *countryDataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    for (NSDictionary *dict in countryDataArray) {
        CountryObject *obj = [[CountryObject alloc] initWithDictionary:dict];
        [countryCodes addObject:obj];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES];
    
    [countryCodes sortUsingDescriptors:@[sortDescriptor]];
}

-(NSArray *)getCountryCodes {
    return countryCodes.copy;
}
-(CountryObject *)getFirstCountry {
    return countryCodes[0];
}

@end
