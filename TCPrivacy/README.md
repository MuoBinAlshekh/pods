
<html>
<body>
<p><img alt="alt tag" src="../res/ca_logo.png" /></p>
<h1 id="privacys-implementation-guide">Privacy's Implementation Guide</h1>
<p><strong>iOS</strong></p>
<p>Last update : <em>15/07/2022</em><br />
Release version : <em>4.9.8</em></p>
<p><div id="end_first_page" /></p>

<div class="toc">
<ul>
<li><a href="#privacys-implementation-guide">Privacy's Implementation Guide</a></li>
<li><a href="#introduction">Introduction</a><ul>
<li><a href="#choose-your-privacy">Choose your privacy</a></li>
<li><a href="#setup">Setup</a><ul>
<li><a href="#with-the-sdk">With the SDK</a></li>
<li><a href="#standalone">Standalone</a></li>
</ul>
</li>
<li><a href="#saving-consent">Saving consent</a><ul>
<li><a href="#with-the-privacy-center">With the Privacy Center</a></li>
<li><a href="#manually-displayed-consent">Manually displayed consent</a></li>
<li><a href="#acceptall-refuseall">AcceptAll / RefuseAll</a></li>
</ul>
</li>
<li><a href="#retaining-consent">Retaining consent</a><ul>
<li><a href="#using-your-own-user-id">Using your own user ID</a></li>
<li><a href="#using-tc_sdk_id">Using TC_SDK_ID</a></li>
<li><a href="#displaying-chosen-id">Displaying chosen ID</a></li>
</ul>
</li>
<li><a href="#displaying-consent">Displaying consent</a></li>
<li><a href="#reacting-to-consent">Reacting to consent</a></li>
<li><a href="#forwarding-consent-to-webviews">Forwarding consent to webViews</a></li>
<li><a href="#changing-consent-version">Changing consent version</a></li>
<li><a href="#consent-internal-api">Consent internal API</a></li>
<li><a href="#privacy-center">Privacy Center</a><ul>
<li><a href="#change-the-default-state-of-the-switch-button-to-disabled">Change the default state of the switch button to disabled:</a><ul>
<li><a href="#testing-on-your-own-app">Testing on your own app</a></li>
</ul>
</li>
</ul>
</li>
<li><a href="#privacy-statistics">Privacy statistics</a></li>
<li><a href="#tcdemo">TCDemo</a></li>
</ul>
</li>
<li><a href="#support-and-contacts">Support and contacts</a></li>
</ul>
</div>
<h1 id="introduction">Introduction</h1>
<p>The privacy module can be used in a lot of different ways, after this short introduction, you will find links to each of the different ways and their specific documentations.</p>
<p>Having the user consent is essential to send sensible information like the IDFA/AAID or using any personal information to serve advertising.</p>
<p>We created this module to simplify the management of you user's privacy and the way to use it.</p>
<p>This module can:</p>
<pre><code>- Display a consent page (if needed)
- Save consent inside the phone and reload it every time the application is launched.
- Check the validity of the consent. The validity duration is set to 13 months.
- Send a hit to our servers to record the consent. For statisical purposes.
- Save the consent String (if used alongside IAB)
- Enable or disable the SDK. (if used alongside the SDK)
- Add the categories automatically to the hits the SDK sends. (if used alongside the SDK)
- Forward the consent to the developpers if they need it outside of the module.
</code></pre>
<h2 id="choose-your-privacy">Choose your privacy</h2>
<p>Privacy comes with two major flavors:</p>
<pre><code>- With Tag Management (With SDK)
- Standalone
</code></pre>
<p>And 3 different ways to display it:</p>
<pre><code>- Manually and then forwarding us the information
- Using our Privacy Center for IAB version 2
- Using our Privacy Center for simple Privacy
</code></pre>
<p>If you're unsure of which one you should use, please contact the person in charge of your account.</p>
<p><a href="../TCIAB/README.md">To use IAB V2 please see here</a></p>
<h2 id="setup">Setup</h2>
<p>/!\ If you are using our interface, you need to have a version of privacy.json inside your project. This will prevent any issues with users with bad or no internet at all. If you are using IAB please also take vendor-list.json and the translation file purposes-fr.json.
If you are not using our interface, you can't use our privacy.json, if you want a way to use a configuration file, please ask your dev team to manage this file.</p>
<p>After initialisation the Privacy module will check the consent validity. If the consent is too old a callback will be called. Please check the Callback part.
The default value is 13 months.</p>
<p>If you're using our interface, and thus our privacy.json, you can change the duration on this validity.
To do this, add "consentDurationInMonths": "6" inside the "information" bloc.</p>
<p>If you're not using our interface, you'll have to manually change it in the code.
We express this duration in months. The duration of a month is calculated by 365/12 days.
Please first call the following method before initializing the Privacy module else:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setConsentDuration: 6];
</code></pre>
<h3 id="with-the-sdk">With the SDK</h3>
<p>Modules: Core, Privacy, SDK</p>
<p>This module can use the same model you are using on the web, if you do so, please start by getting the IDs of the categories you are going to use.
Join those IDs with a "consent version". Default is 001, but if you change the implementation, it's better to increment this version.</p>
<p>The setup is really simple, pass to the TCMobilePrivacy object your site ID, application context and a pointer to your TagCommanders' SDK instance. If you want to add your consent version, you can add it to the parameters as a NSString.</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setSiteID: 3311 TCInstance: tc AndVersion: @"001"];
</code></pre>
<p>If you're using you're own Privacy Center, use the following function instead:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] customPCMSetSiteID: siteID privacyID: privacyID andTCInstance: tc];
</code></pre>
<p>This call will check the saved consent, putting the SDK on hold if nothing is fount, and start/stop the SDK if something is saved.
It will then the check the consent validity, if it's too old, you can implement a callback treating what to do then. Please check the Callback part.</p>
<p>Please note that start and stop have a notification sent with them, you can listen to them if needed: kTCNotification_StartingTheSDK and kTCNotification_StoppingTheSDK.</p>
<p>If you need to store configuration files in another bundle than the main one, you can call the following line:</p>
<pre><code>[[TCConfigurationFileFactory sharedInstance] setBundle: myBundle forConfiguration: @"vendorlist"];
</code></pre>
<p>But please call this <em>before</em> calling [TCMobilePrivacy sharedInstance].</p>
<h3 id="standalone">Standalone</h3>
<p>Modules: Core, Privacy</p>
<p>You won't need the SDK module, and will need to implement a callback to manage your solutions when consent is given or re-loaded.</p>
<p>The setup is really simple, pass to the TCPrivacy object your site ID  application context. If you want to add your consent version, you can add it to the parameters as a String.</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setSiteID: siteID andPrivacyID: privacyID];
</code></pre>
<p>If you're using you're own Privacy Center, use the following function instead:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] customPCMSetSiteID: siteID privacyID: privacyID];
</code></pre>
<h2 id="saving-consent">Saving consent</h2>
<p>Here is where the IDs of the categories matters.</p>
<h3 id="with-the-privacy-center">With the Privacy Center</h3>
<p>If you're using the Privacy Center, nothing has to be done here, it will automatically propagate the consent to all other systems. And the ID will be the one used in the configuration file. Please check the Privacy Center part for more information.</p>
<p>Please keep your category IDs between 1 and 999.</p>
<h3 id="manually-displayed-consent">Manually displayed consent</h3>
<p>Once the user validated his consent, you can the send the information to the Privacy module as follow:</p>
<pre><code>NSMutableDictionary *consent = [[NSMutableDictionary alloc] initWithCapacity: 3];
[consent setObject: @"1" forKey: @"PRIVACY_CAT_1"];
[consent setObject: @"0" forKey: @"PRIVACY_CAT_2"];
[consent setObject: @"2" forKey: @"PRIVACY_CAT_3"];
[[TCMobilePrivacy sharedInstance] saveConsent: consent fromConsentSource: Popup withPrivacyAction: Save];
</code></pre>
<p>ETCConsentSource is either "Popup" or "PrivacyCenter".</p>
<p>ETCConsentAction is either "AcceptAll", "RefuseAll", "Save"</p>
<p>Please prefix your category IDs with "PRIVACY_CAT_" and your vendor IDs with "PRIVACY_VEN_. 1 means accepting this category or vendor, 2 is for mandatory vendors or categorues, 0 is refusing.</p>
<p>If you're using the SDK, this will propagate the information to the SDK and manage its state.</p>
<h3 id="acceptall-refuseall">AcceptAll / RefuseAll</h3>
<p>/!\ Those methods only work if you are using our interface and thus have a privacy.json in your project (and maybe IAB's JSON as well).</p>
<p>Those are intended for clients that are displaying a first "popup" screen before our interfaces and that have a way to either open the privacy center of accept/refuse the consent.</p>
<p>We created functions to call if you want to create a simple way to accept or refuse all consent from outside our user interface.</p>
<pre><code>[[TCMobilePrivacy sharedInstance] acceptAllConsent];
[[TCMobilePrivacy sharedInstance] refuseAllConsent];
</code></pre>
<h2 id="retaining-consent">Retaining consent</h2>
<p>The saving of the consent on our servers is done automatically.</p>
<p>But since we are saving the consent in our servers, we need to identify the user one way or another. By default the variable used to identify the user consenting is #TC_SDK_ID#, but you can change it to anything you'd like.</p>
<p>If you're looking for a way to proove consent or reset saved information, you'll need to create a specific screen in app for this.</p>
<p>If you want to use an ID already inside the SDK:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setConsentUser: @"#TC_IDFA#"];
</code></pre>
<p>If you want to use an ID from your data layer, please first add it to the permanant store:</p>
<pre><code>[tc addPermanentData: @"MY_ID" withValue: @"12345"];
[[TCMobilePrivacy sharedInstance] setConsentUser: @"MY_ID"];
</code></pre>
<p>and if you simply want to simply pass the information:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setConsentUser: @"123456765432"];
</code></pre>
<p>This can be used to save the display of the consent, and giving the consent.</p>
<p>This ID is very important because it will be the basic information used to get back the consent when you need a proof.</p>
<h3 id="using-your-own-user-id">Using your own user ID</h3>
<p>You will be able to get the information more easily since this is an ID available by several means for you.</p>
<h3 id="using-tc_sdk_id">Using TC_SDK_ID</h3>
<p>This is the defaul variable used to save privacy. It's generated by the SDK the first time you open the app and never changes.</p>
<h3 id="displaying-chosen-id">Displaying chosen ID</h3>
<p>You might want to be able to display to your end user the ID used to save the consent, in this case we created a function to easily get it.</p>
<pre><code>[[TCMobilePrivacy sharedInstance] getPrivacyUserID];
</code></pre>
<h2 id="displaying-consent">Displaying consent</h2>
<p>If you are familiar with Commanders Act privacy for web, you know that we actually record two things. The first thing is "displaying the consent form".
This allow you to prove that a user has indeed been shown the consent screen even if he somehow left without accepting/refusing to give his consent.</p>
<p>In some cases, client also use this to infer user consent since he continued using the application after he was shown the consent screen.
We don't recommend this behaviour, please discuss it with your setup team first.</p>
<h2 id="reacting-to-consent">Reacting to consent</h2>
<p>Some of the event happening in the SDK have callbacks associated with them in the case you need to do specific actions at this specific moment.</p>
<p>Currently we have a callback function that lets you get back the categories and setup your other partners accordingly.
This is the function where you would tell your ad partner "the user don't wan't to receive personalized ads" for example.</p>
<p>/!\ Don't forget to register to the callbacks <em>before</em> the initialisation of the Privacy Module since the module will check consent at init and use the callback at this step.</p>
<p>Implement TCPrivacyCallbacks to get access to those callbacks:</p>
<pre><code>- (void) consentUpdated: (NSDictionary *) consent;
</code></pre>
<p>Called when you give us the user selected consents, or when we load the saved consent from the SDK.
We have a Dictionnary which is the same as the one given to our SDK with keys PRIVACY_CAT_n and value @"0" or @"1".</p>
<pre><code>- (void) consentOutdated;
</code></pre>
<p>This is called after 13 months without change in the user consent. This can allow you to force displaying the consent the same way you would on first launch.</p>
<pre><code>- (void) consentCategoryChanged;
</code></pre>
<p>When you make a change in the JSON, there is nothing special to do.
But when this change is adding or removing a category, or changing an ID, we should re-display the Privacy Center.</p>
<pre><code>- (void) significantChangesInPrivacy;
</code></pre>
<p>This one is slightly different from the last one, it was created for IAB and will not be sent automatically. It is conditionned by the field "significantChanges" in the privacy.json so that it will only launch when you need it to.</p>
<h2 id="forwarding-consent-to-webviews">Forwarding consent to webViews</h2>
<p>Some clients need to have the consent forwarded in their webViews to manage a web container inside it.
We created a function to get the privacy as a JSON string so you can save it inside the webView's local storage.
/!\ This function only help saving it to the local storage by giving the required format, you will still need to have JS code in the web container to use it. Please ask your consultant for this part.</p>
<pre><code>- (NSString *) getConsentAsJson;
</code></pre>
<h2 id="changing-consent-version">Changing consent version</h2>
<p>If the case you need to manually change the consent version (if you're using your own privacy center for example), you can use the following:</p>
<pre><code>[[TCMobilePrivacy sharedInstance] setConsentVersion: @"132"];
</code></pre>
<h2 id="consent-internal-api">Consent internal API</h2>
<p>We created several methods to check given consent. They are simple, but make it easier to work with consent information at any given time.
You'll find those in the class TCPrivacyAPI:</p>
<pre><code>/**
 * Checks if we should display privacy center for any reason.
 * @return True or False.
 */
+ (BOOL) shouldDisplayPrivacyCenter
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Checks if consent has already been given by checking if consent information is saved.
 * @return YES if the consent was already given, NO otherwise.
 */
+ (BOOL) isConsentAlreadyGiven;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Return the epochformatted timestamp of the last time the consent was saved.
 * @return epochformatted timestamp or 0.
 */
+ (unsigned long long) getLastTimeConsentWasSaved;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Check if a Category has been accepted.
 * @param ID the category ID.
 * @return YES or NO.
 */
+ (BOOL) isCategoryAccepted: (int) catID;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Check if a vendor has been accepted.
 * @param ID the vendor ID.
 * @return YES or NO.
 */
+ (BOOL) isVendorAccepted: (int) venID;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Get the list of all accepted vendors.
 * @return a List of PRIVACY_VEN_IDs.
 */
+ (NSArray&lt;NSString *&gt; *) getAcceptedCategories;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Get the list of all accepted vendors.
 * @return a List of PRIVACY_VEN_IDs.
 */
+ (NSArray&lt;NSString *&gt; *) getAcceptedVendors;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Get the list of everything that was accepted.
 * @return a List of PRIVACY_VEN_IDs and PRIVACY_CAT_IDs.
 */
+ (NSArray&lt;NSString *&gt; *) getAllAcceptedConsent;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Check if a purpose has been accepted.
 * @param ID the purpose ID.
 * @return YES or NO
 */
+ (BOOL) isIABPurposeAccepted: (int) ID;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Check if a vendor has been accepted.
 * @param ID the vendor ID.
 * @return YES or NO
 */
+ (BOOL) isIABVendorAccepted: (int) ID;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Check if a special feature has been accepted.
 * @param ID the vendor ID.
 * @return YES or NO
 */
+ (BOOL) isIABSpecialFeatureAccepted: (int) ID;
</code></pre>
<p>&nbsp;</p>
<pre><code>/**
 * Get the list of all google vendor accepted.
 * @return a list of acm_IDs.
 */
+ (NSArray &lt;NSString *&gt; *) getAcceptedGoogleVendors;
</code></pre>
<p>&nbsp;</p>
<h2 id="privacy-center">Privacy Center</h2>
<p>The Privacy Center is represented by a JSON file that describes the interfaces that will be created by native code inside the application.</p>
<p>For now this JSON has to be created and managed manually. And the SDK will check for updates of the file automatically.</p>
<p>Your account should have a consultant that will provide you the corresponding JSON for your project.</p>
<p>We create an UIViewController to create the privacy center view.
The offline JSON should be inside the project code folder.</p>
<pre><code>TCPrivacyCenterViewController *PCM = [[TCPrivacyCenterViewController alloc] init];
[self.navigationController pushViewController: PCM animated: YES];
</code></pre>
<p>Since we have a view controller, you can call it by pushing it. It's quite easy.</p>
<p>Some part of the Privacy Center can be customised with your code.</p>
<h3 id="change-the-default-state-of-the-switch-button-to-disabled">Change the default state of the switch button to disabled:</h3>
<pre><code>[TCMobilePrivacy sharedInstance].switchDefaultState = NO;
</code></pre>
<h4 id="testing-on-your-own-app">Testing on your own app</h4>
<p>If you wanna implement your own UI Testing on your app, you might need the following accessibilities keys for accessing our multiple UI Buttons :</p>
<p>please make sure you've already imported TCPrivacyConstants.h</p>
<table>
<thead>
<tr>
<th>Key</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>TC_POPUP_SCREEN_DETAILS_BTN</td>
<td>First layer's details button</td>
</tr>
<tr>
<td>TC_POPUP_SCREEN_ACCEPT_ALL_BTN</td>
<td>First layer's accept all button</td>
</tr>
<tr>
<td>TC_POPUP_SCREEN_REFUSE_ALL_BTN</td>
<td>First layer's refuse all button</td>
</tr>
<tr>
<td>TC_VENDORS_SCREEN_SAVE_EXIT_BTN</td>
<td>Vendors screen save and exit button</td>
</tr>
<tr>
<td>TC_VENDORS_SCREEN_ACCEPT_ALL_BTN</td>
<td>Vendors screen accept all button</td>
</tr>
<tr>
<td>TC_VENDORS_SCREEN_REFUSE_ALL_BTN</td>
<td>Vendors screen refuse all button</td>
</tr>
<tr>
<td>TC_VENDORS_SCREEN_SHOW_PURPOSES_BTN</td>
<td>Vendors screen's show purposes screen button</td>
</tr>
<tr>
<td>TC_PURPOSES_SCREEN_SAVE_EXIT_BTN</td>
<td>Purposes screen save and exit button</td>
</tr>
<tr>
<td>TC_PURPOSES_SCREEN_ACCEPT_ALL_BTN</td>
<td>Purposes screen accept all button</td>
</tr>
<tr>
<td>TC_PURPOSES_SCREEN_REFUSE_ALL_BTN</td>
<td>Purposes screen refuse all button</td>
</tr>
<tr>
<td>TC_PURPOSES_SCREEN_SHOW_VENDORS_BTN</td>
<td>Purposes screen's show vendor screen button</td>
</tr>
</tbody>
</table>
<p>Switches on the UI hold the following accessibility identifier :</p>
<table>
<thead>
<tr>
<th>Type</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>IAB Purpose</td>
<td>PRIVACY_CAT_X where X = iabId * 2 - 1 + 10000</td>
</tr>
<tr>
<td>IAB Special Feature</td>
<td>PRIVACY_CAT_X where X = iabId + 13000</td>
</tr>
<tr>
<td>IAB Vendor</td>
<td>PRIVACY_VEN_X where X = ( IAB.id * 2 ) + 1000 - 1</td>
</tr>
<tr>
<td>Custom Vendor</td>
<td>PRIVACY_VEN_ID</td>
</tr>
<tr>
<td>Custom Category</td>
<td>PRIVACY_CAT_ID</td>
</tr>
<tr>
<td>Google Vendor</td>
<td>acm_ID</td>
</tr>
</tbody>
</table>
<h2 id="privacy-statistics">Privacy statistics</h2>
<p>We have dashboards that allow to have detailed statistics on the choices your users are making.
Depending on your app privacy configuration you might have to call some additional functions.</p>
<pre><code>- Custom « banner/popup » -&gt; our privacy center
- Custom « banner/popup » -&gt; Custom privacy center
- Directly to our privacy center
- Custom privacy center
</code></pre>
<p>Whenever saveConsent* is called you will need to provide the full list of purposes and vendors that have been consented to and refused.</p>
<p>We reworked saveConsent methods to only use one. If you are using the old functions they will still work for now.
Otherwise please check the above section "Manually displayed consent" for how this method works.</p>
<p>Also please note that you will need to call statViewBanner when you display your custom banner.</p>
<p><img alt="alt tag" src="../res/TCPC_customBanner.jpeg" />
<img alt="alt tag" src="../res/TCPC_PC.jpeg" />
<img alt="alt tag" src="../res/CustomBanner.jpeg" />
<img alt="alt tag" src="../res/CustomPC.jpeg" /></p>
<h2 id="tcdemo">TCDemo</h2>
<p>You can, of course, check our demo project for a simple implementation example.</p>
<p><a href="https://github.com/TagCommander/Privacy-Demo/tree/master/iOS">Privacy Demo</a></p>
<h1 id="support-and-contacts">Support and contacts</h1>
<p><img alt="alt tag" src="../res/ca_logo.png" /></p>
<hr />
<p><strong>Support</strong>
<em>support@commandersact.com</em></p>
<p>http://www.commandersact.com</p>
<p>Commanders Act | 3/5 rue Saint Georges - 75009 PARIS - France</p>
<hr />
<p>This documentation was generated on 15/07/2022 14:25:57</p>
</body>
</html>