//
//  TKeypadDetailViewController.m
//  Telasco
//
//  Created by Janna Hakobyan on 3/16/15.
//  Copyright (c) 2015 Telasco Communications. All rights reserved.
//

#import "TKeypadDetailViewController.h"
#import "cVaxSIPUserAgentEx.h"
#import "UIViewController+MaryPopin.h"

static cDialpadView *mDialpadView = NULL;

@interface TKeypadDetailViewController ()
{
    NSDate *startCallDate;
    NSDate *endCallDate;
    BOOL isRingging;
    NSTimeInterval startTime, endTime;
    
    RHAddressBook *addressBook;
    NSMutableArray *peoples;
}
@end

@implementation TKeypadDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    mDialpadView = (cDialpadView *)self.view;
    [[cVaxSIPUserAgentEx GetOBJ] SetPhoneDetailTableView:self];
 
    addressBook = [RHAddressBook new];
    peoples = [[addressBook peopleOrderedByUsersPreference] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Get phone %@", self.phoneNumber);
    self.phoneNumber = [Utils removeUnnecessaryStringFromPhoneNumber:self.phoneNumber];
    
    self.phoneNumberLbl.text = self.phoneNumber;
//    if (self.appDelegate.isNetworkReachable) {
        int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
        
    if(nStatus == VAX_LINE_STATUS_FREE) {
        [self removeInternPrefix];
        [self BtnDialCall];
    }
//    }
}

- (void)findParentPhoneNumber
{
    for (RHPerson *obj in peoples) {
        RHMultiValue *p = (RHMultiValue *)obj.phoneNumbers.values;
        NSMutableArray *phones = (NSMutableArray *)p;
      
        
        if ([phones containsObject:self.originalPhone]) { // find contact
            self.phoneNumberLbl.text = obj.compositeName;
            break;
        }
        
        for (NSString *phoneWithoutSpace in phones) {
            NSString *pn = [[phoneWithoutSpace componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            if ([pn isEqualToString:self.originalPhone]) { // find contact
                self.phoneNumberLbl.text = obj.compositeName;
                break;
            }
        }
    }
}

- (void)removeInternPrefix
{
    if ([self.phoneNumber hasPrefix:@"+"]) {
        self.phoneNumber = [self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:@""];
        return;
    }
    if ([self.phoneNumber hasPrefix:@"00"]) {
        self.phoneNumber = [self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:@""];
        return;
    }
    if ([self.phoneNumber hasPrefix:@"011"]) {
        self.phoneNumber = [self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(0,3) withString:@""];
        return;
    }
}

- (void)BtnDialCall;
{
    NSLog(@"Call to number %@", self.phoneNumber);
    if(![[cVaxSIPUserAgentEx GetOBJ] VaxDialCall:self.phoneNumber])
    {
        [[cVaxSIPUserAgentEx GetOBJ] ErrorMessage];
        return;
    }
    [self findParentPhoneNumber];
}

- (IBAction)dismissViewController:(id)sender
{
    int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
    
    if(nStatus != VAX_LINE_STATUS_FREE) {
        [self BtnHangUpCall];
    }

    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
    }];
    
    if (!endCallDate) {
        endCallDate = [NSDate date];
        endTime = [[NSDate date] timeIntervalSince1970];
    }
    [Utils savaRecentContacts:startCallDate endDate:endCallDate phone:self.originalPhone];
    self.phoneNumberLbl.text = self.phoneNumber;
}

- (void)BtnHangUpCall
{
    int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
    
    if(nStatus == VAX_LINE_STATUS_CONNECTING)
        [self SetTextToStatus: @"Cancelled": false];
    else {
        endCallDate = [NSDate date]; // i rejected
        endTime = [[NSDate date] timeIntervalSince1970];
        [self SetTextToStatus: @"Disconnected": false];
    }
    [[cVaxSIPUserAgentEx GetOBJ] VaxDisconnectCall];
}

- (IBAction)onClickSpeaker:(id)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxSetSpeakerPhoneState:![[cVaxSIPUserAgentEx GetOBJ] VaxGetSpeakerPhoneState]];
}

- (IBAction)onClickMute:(id)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxSetMuteMic:![[cVaxSIPUserAgentEx GetOBJ] VaxGetMuteMic]];
}

- (IBAction)onClickMuteSpk:(id)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxSetMuteSpk:YES];
    self.keypadView.hidden = NO;
    self.hideKeypadBtn.hidden = NO;
}

- (IBAction)hideMuteSpk:(id)sender
{
    self.keypadView.hidden = YES;
    self.hideKeypadBtn.hidden = YES;
    self.phoneNumberLbl.text = self.phoneNumber;
}

- (IBAction)onClickKeypad:(UIButton *)sender
{
    [[cVaxSIPUserAgentEx GetOBJ] VaxDigitDTMF:sender.tag];
    if ([self.phoneNumber isEqualToString:self.phoneNumberLbl.text]) {
        self.phoneNumberLbl.text = @"";
    }
    self.phoneNumberLbl.text = [NSString stringWithFormat:@"%@%i", self.phoneNumberLbl.text, sender.tag];
}

#pragma mark - cVaxVoIP

- (void) UpdateAccountStatusInView :(int) nStatusId :(NSString*) pStatusPhrase;
{
    if([[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus] != VAX_LINE_STATUS_FREE)
        return;
    
    m_nLastStatusId = nStatusId;
    
    if(pStatusPhrase != NULL)
        [mLastStatusPhrase setString :pStatusPhrase];
    
    [self UpdateAccountStatusInView];
}

- (void) UpdateAccountStatusInView;
{
    if([[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus] != VAX_LINE_STATUS_FREE)
        return;
    
    NSString *pStatusMsg;
    
    switch(m_nLastStatusId)
    {
        case VAX_REG_STATUS_NETWORK_NOT_FOUND:
            [self SetTextToStatus: @REGISTER_STATUS_NETWORK_NOT_FOUND: false];
            break;
            
        case VAX_REG_STATUS_ONLINE:
            [self SetTextToStatus: @REGISTER_STATUS_ONLINE: false];
            break;
            
        case VAX_REG_STATUS_OFFLINE:
            [self SetTextToStatus: @REGISTER_STATUS_OFFLINE: false];
            break;
            
        case VAX_REG_STATUS_TRYING:
            [self SetTextToStatus: @REGISTER_STATUS_REGISTERING: false];
            break;
            
        case VAX_REG_STATUS_FAILED:
            pStatusMsg = [NSString stringWithFormat: @"%@ %@", @REGISTER_STATUS_FAILED, mLastStatusPhrase];
            [self SetTextToStatus: pStatusMsg: true];
            break;
            
        case VAX_REG_STATUS_SUCCESS:
            [self SetTextToStatus: @REGISTER_STATUS_SUCCESS: false];
            break;
            
        case VAX_REREG_STATUS_TRYING:
            [self SetTextToStatus: @RE_REGISTER_STATUS_REGISTERING: false];
            break;
            
        case VAX_REREG_STATUS_FAILED:
            pStatusMsg = [NSString stringWithFormat: @"%@ %@", @RE_REGISTER_STATUS_FAILED, mLastStatusPhrase];
            [self SetTextToStatus: pStatusMsg: true];
            break;
            
        case VAX_REREG_STATUS_SUCCESS:
            [self SetTextToStatus: @RE_REGISTER_STATUS_SUCCESS: false];
            break;
            
        case VAX_UNREG_STATUS_TRYING:
            //@UN_REGISTER_STATUS_REGISTERING
            [self SetTextToStatus: @"": false];
            break;
            
        case VAX_UNREG_STATUS_FAILED:
            [self SetTextToStatus: @"": false];
            break;
            
        case VAX_UNREG_STATUS_SUCCESS:
            //@UN_REGISTER_STATUS_SUCCESS
            [self SetTextToStatus: @"": false];
            break;
            
        default:
            [self SetTextToStatus: @"": false];
            break;
    }
}

- (void) SetTextToStatus :(NSString*) pText :(Boolean) bRedColor;
{
    mStatusField.text = pText;
    [mStatusField sizeToFit];
}

- (void) UpdatePhoneStatusInView;
{
    [self SetTextToStatus: mLastStatusPhrase: m_bLastStatusError];
}

- (void) UpdatePhoneStatusInView :(NSString*) pStatusPhrase :(Boolean) bError;
{
    m_nLastStatusId = -1;
    
    if(pStatusPhrase != NULL)
        [mLastStatusPhrase setString :pStatusPhrase];
    
    [self SetTextToStatus: pStatusPhrase: bError];
}

- (void) OnFailureResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
    NSLog(@"OnFailureResponse");
    [self UpdatePhoneStatusInView :pReasonPharase :true];
//    endCallDate = [NSDate date];
//    endTime = [[NSDate date] timeIntervalSince1970];
//    [self dismissViewController:nil];
}

- (void) OnTryingToHold;
{
    NSLog(@"OnTryingToHold");
    [self UpdatePhoneStatusInView :@"Hold: Trying" :false];
}

- (void) OnTryingToUnHold;
{
    NSLog(@"OnTryingToUnHold");
    [self UpdatePhoneStatusInView :@"UnHold: Trying" :false];
}

- (void) OnFailToHold;
{
    NSLog(@"OnFailToHold");
    [self UpdatePhoneStatusInView :@"Hold: Failed" :true];
}

- (void) OnFailToUnHold;
{
    NSLog(@"OnFailToUnHold");
    [self UpdatePhoneStatusInView :@"UnHold: Failed" :true];
    [self dismissViewController:nil];
}

- (void) OnSuccessToHold;
{
    NSLog(@"OnSuccessToHold");
    [self UpdatePhoneStatusInView :@"Hold: Successful" :false];
}

- (void) OnSuccessToUnHold;
{
    NSLog(@"OnSuccessToUnHold");
    [self UpdatePhoneStatusInView :@"UnHold: Successful" :false];
}

- (void) OnFailToConnect;
{
    NSLog(@"OnFailToConnect");
    [self UpdatePhoneStatusInView :@"Call: Failed" :true];
}

- (void) OnConnected;
{
    NSLog(@"OnConnected");
    if (isRingging) {
        startCallDate = [NSDate date];
        startTime = [[NSDate date] timeIntervalSince1970];
    }
    
    [self UpdatePhoneStatusInView :@"Call: Connected" :false];
    [self UpdateButtonImage];
}

- (void) OnProvisionalResponse :(int) nStatusCode :(NSString*) pReasonPharase;
{
    if (nStatusCode == 183) {
        isRingging = YES;
    }
    [self UpdatePhoneStatusInView :pReasonPharase :false];
}

- (void) OnRedirectResponse :(int) nStatusCode :(NSString*) pReasonPharase :(NSString*) pContact;
{
    [self UpdatePhoneStatusInView :pReasonPharase :true];
    [self UpdateButtonImage];
}

- (void) OnDisconnectCall;
{
    [self UpdatePhoneStatusInView :@"Hung Up" :false];
    // user rejected
//    endCallDate = startCallDate;
    isRingging = NO;
    endCallDate = [NSDate date];
    endTime = [[NSDate date] timeIntervalSince1970];
    [self dismissViewController:nil];
    [self UpdateButtonImage];
}

- (void) OnCallTransferAccepted;
{
    //[self SetStatusToLine: nLineNo];
}

- (void) OnFailToTransfer :(int) nStatusCode :(NSString*) pReasonPharase;
{
    //[self SetStatusToLine: nLineNo];
}

- (void) OnConnecting;
{
    [self UpdatePhoneStatusInView :@"Call: Connecting..." :false];
}

- (void) UpdateButtonImage;
{
    int nStatus = [[cVaxSIPUserAgentEx GetOBJ] GetPhoneStatus];
    
    if(nStatus == VAX_LINE_STATUS_FREE)
    {
        mbButtonHoldEnabled = NO;
        mbButtonContactsEnabled = YES;
    }
    
    if ((nStatus == VAX_LINE_STATUS_CONNECTED || nStatus == VAX_LINE_STATUS_CONNECTING))
    {
        mbButtonHoldEnabled = YES;
        mbButtonContactsEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
