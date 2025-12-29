import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Easy Vacation'**
  String get appTitle;

  /// No description provided for @your_perfect_gateway.
  ///
  /// In en, this message translates to:
  /// **'Your perfect getaway'**
  String get your_perfect_gateway;

  /// No description provided for @discrover_places.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing places and create unforgettable memories with our travel platform.'**
  String get discrover_places;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Traveler'**
  String get welcomeMessage;

  /// No description provided for @exploreMessage.
  ///
  /// In en, this message translates to:
  /// **'Explore Now'**
  String get exploreMessage;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create\nYour Account'**
  String get createAccountTitle;

  /// No description provided for @joinMessage.
  ///
  /// In en, this message translates to:
  /// **'Join EasyVacation today'**
  String get joinMessage;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterLastName;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get emailAlreadyExists;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginFailed;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again later.'**
  String get noInternetConnection;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or Continue With'**
  String get orContinueWith;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginToAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginToAccount;

  /// No description provided for @phoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Phone Or Email'**
  String get phoneOrEmail;

  /// No description provided for @pleaseEnterPhoneOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone/email'**
  String get pleaseEnterPhoneOrEmail;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @filterWilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get filterWilaya;

  /// No description provided for @filterPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get filterPrice;

  /// No description provided for @filterDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get filterDate;

  /// No description provided for @filterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filterType;

  /// No description provided for @tabStays.
  ///
  /// In en, this message translates to:
  /// **'Stays'**
  String get tabStays;

  /// No description provided for @tabVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get tabVehicles;

  /// No description provided for @tabActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get tabActivities;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @premiumSubscription.
  ///
  /// In en, this message translates to:
  /// **'Premium Subscription'**
  String get premiumSubscription;

  /// No description provided for @monthlyPlanActive.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan - Active'**
  String get monthlyPlanActive;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileSubtitle;

  /// No description provided for @myListings.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get myListings;

  /// No description provided for @myListingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage your listings'**
  String get myListingsSubtitle;

  /// No description provided for @bookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory;

  /// No description provided for @bookingHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your past and upcoming bookings'**
  String get bookingHistorySubtitle;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @subscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your subscription plan'**
  String get subscriptionSubtitle;

  /// No description provided for @blockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockedUsers;

  /// No description provided for @blockedUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See who you blocked and want to unblock'**
  String get blockedUsersSubtitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get signOutSubtitle;

  /// No description provided for @vehicles_featured_title.
  ///
  /// In en, this message translates to:
  /// **'Featured Vehicles'**
  String get vehicles_featured_title;

  /// No description provided for @recommended_title.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommended_title;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @stays_featured_title.
  ///
  /// In en, this message translates to:
  /// **'Featured Stays'**
  String get stays_featured_title;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get night;

  /// No description provided for @activities_featured_title.
  ///
  /// In en, this message translates to:
  /// **'Featured Activities'**
  String get activities_featured_title;

  /// No description provided for @subscriptions_title.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions_title;

  /// No description provided for @plan_recommended_label.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get plan_recommended_label;

  /// No description provided for @plan_current_button.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get plan_current_button;

  /// No description provided for @plan_select_button.
  ///
  /// In en, this message translates to:
  /// **'Select Plan'**
  String get plan_select_button;

  /// No description provided for @plan_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get plan_free;

  /// No description provided for @plan_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get plan_monthly;

  /// No description provided for @plan_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get plan_yearly;

  /// No description provided for @plan_detail_pay_per_cost.
  ///
  /// In en, this message translates to:
  /// **'Pay-per-cost'**
  String get plan_detail_pay_per_cost;

  /// No description provided for @plan_detail_limited_uploads.
  ///
  /// In en, this message translates to:
  /// **'Limited photo uploads'**
  String get plan_detail_limited_uploads;

  /// No description provided for @plan_detail_unlimited_listings.
  ///
  /// In en, this message translates to:
  /// **'Unlimited listings'**
  String get plan_detail_unlimited_listings;

  /// No description provided for @plan_detail_increased_visibility.
  ///
  /// In en, this message translates to:
  /// **'Increased visibility'**
  String get plan_detail_increased_visibility;

  /// No description provided for @plan_detail_monthly_benefits.
  ///
  /// In en, this message translates to:
  /// **'All Monthly benefits'**
  String get plan_detail_monthly_benefits;

  /// No description provided for @plan_detail_top_placement.
  ///
  /// In en, this message translates to:
  /// **'Top placement'**
  String get plan_detail_top_placement;

  /// No description provided for @plan_detail_special_badges.
  ///
  /// In en, this message translates to:
  /// **'Special badges'**
  String get plan_detail_special_badges;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @appBar_createListing.
  ///
  /// In en, this message translates to:
  /// **'Create Listing'**
  String get appBar_createListing;

  /// No description provided for @header_createNewListing.
  ///
  /// In en, this message translates to:
  /// **'Create New Listing'**
  String get header_createNewListing;

  /// No description provided for @header_fillDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to get started'**
  String get header_fillDetails;

  /// No description provided for @photo_addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get photo_addPhotos;

  /// No description provided for @photo_addPhotosDescription.
  ///
  /// In en, this message translates to:
  /// **'Add up to 10 photos to showcase your listing'**
  String get photo_addPhotosDescription;

  /// No description provided for @photo_addPhotosButton.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get photo_addPhotosButton;

  /// No description provided for @listingType_title.
  ///
  /// In en, this message translates to:
  /// **'Listing Type'**
  String get listingType_title;

  /// No description provided for @listingType_stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get listingType_stay;

  /// No description provided for @listingType_activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get listingType_activity;

  /// No description provided for @listingType_vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get listingType_vehicle;

  /// No description provided for @form_listingDetails.
  ///
  /// In en, this message translates to:
  /// **'Listing Details'**
  String get form_listingDetails;

  /// No description provided for @field_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get field_title;

  /// No description provided for @field_title_error.
  ///
  /// In en, this message translates to:
  /// **'Please add a title'**
  String get field_title_error;

  /// No description provided for @field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get field_description;

  /// No description provided for @field_description_error.
  ///
  /// In en, this message translates to:
  /// **'Please add a description'**
  String get field_description_error;

  /// No description provided for @field_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get field_price;

  /// No description provided for @field_price_error.
  ///
  /// In en, this message translates to:
  /// **'Please add a price'**
  String get field_price_error;

  /// No description provided for @field_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get field_location;

  /// No description provided for @field_location_error.
  ///
  /// In en, this message translates to:
  /// **'Please pin a location'**
  String get field_location_error;

  /// No description provided for @button_continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue To Payment'**
  String get button_continueToPayment;

  /// No description provided for @bottomNav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNav_home;

  /// No description provided for @bottomNav_bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bottomNav_bookings;

  /// No description provided for @bottomNav_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get bottomNav_notifications;

  /// No description provided for @bottomNav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get bottomNav_settings;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profile_posts;

  /// No description provided for @profile_followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profile_followers;

  /// No description provided for @profile_following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profile_following;

  /// No description provided for @profile_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get profile_reviews;

  /// No description provided for @profile_noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get profile_noPostsYet;

  /// No description provided for @profile_noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get profile_noReviewsYet;

  /// No description provided for @profile_follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get profile_follow;

  /// No description provided for @profile_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profile_about;

  /// No description provided for @profile_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get profile_from;

  /// No description provided for @profile_memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profile_memberSince;

  /// No description provided for @profile_countriesVisited.
  ///
  /// In en, this message translates to:
  /// **'Countries visited'**
  String get profile_countriesVisited;

  /// No description provided for @profile_reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report User'**
  String get profile_reportUser;

  /// No description provided for @profile_blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get profile_blockUser;

  /// No description provided for @profile_shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Profile'**
  String get profile_shareProfile;

  /// No description provided for @profile_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_cancel;

  /// No description provided for @profile_helpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful'**
  String get profile_helpful;

  /// No description provided for @bookings_title.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings_title;

  /// No description provided for @bookings_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookings_all;

  /// No description provided for @bookings_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookings_pending;

  /// No description provided for @bookings_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookings_confirmed;

  /// No description provided for @bookings_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookings_rejected;

  /// No description provided for @bookings_viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get bookings_viewDetails;

  /// No description provided for @bookings_yourBooking.
  ///
  /// In en, this message translates to:
  /// **'Your Booking'**
  String get bookings_yourBooking;

  /// No description provided for @bookings_noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get bookings_noBookingsYet;

  /// No description provided for @bookings_emptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming or past bookings. Time to plan your next adventure!'**
  String get bookings_emptyMessage;

  /// No description provided for @bookings_exploreStays.
  ///
  /// In en, this message translates to:
  /// **'Explore Stays'**
  String get bookings_exploreStays;

  /// No description provided for @listingDetails_title.
  ///
  /// In en, this message translates to:
  /// **'Listing Details'**
  String get listingDetails_title;

  /// No description provided for @listingDetails_perNight.
  ///
  /// In en, this message translates to:
  /// **'per night'**
  String get listingDetails_perNight;

  /// No description provided for @listingDetails_hostedBy.
  ///
  /// In en, this message translates to:
  /// **'Hosted by'**
  String get listingDetails_hostedBy;

  /// No description provided for @listingDetails_superHost.
  ///
  /// In en, this message translates to:
  /// **'Super Host'**
  String get listingDetails_superHost;

  /// No description provided for @listingDetails_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get listingDetails_reviews;

  /// No description provided for @listingDetails_availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get listingDetails_availability;

  /// No description provided for @listingDetails_reserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve Now'**
  String get listingDetails_reserveNow;

  /// No description provided for @listingDetails_selectDatesFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select dates before booking'**
  String get listingDetails_selectDatesFirst;

  /// No description provided for @listingDetails_bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed! Check your bookings.'**
  String get listingDetails_bookingConfirmed;

  /// No description provided for @listingDetails_bookingPending.
  ///
  /// In en, this message translates to:
  /// **'Your booking is pending'**
  String get listingDetails_bookingPending;

  /// No description provided for @listingDetails_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String listingDetails_daysAgo(int count);

  /// No description provided for @listingDetails_daysAgo_other.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String listingDetails_daysAgo_other(Object count);

  /// No description provided for @editProfile_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile_title;

  /// No description provided for @editProfile_changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get editProfile_changePhoto;

  /// No description provided for @editProfile_fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfile_fullName;

  /// No description provided for @editProfile_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get editProfile_emailAddress;

  /// No description provided for @editProfile_phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Profile Phone Number'**
  String get editProfile_phoneNumber;

  /// No description provided for @editProfile_location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get editProfile_location;

  /// No description provided for @editProfile_bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get editProfile_bio;

  /// No description provided for @editProfile_changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get editProfile_changePassword;

  /// No description provided for @editProfile_notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get editProfile_notificationSettings;

  /// No description provided for @editProfile_privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get editProfile_privacySettings;

  /// No description provided for @editProfile_deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get editProfile_deleteAccount;

  /// No description provided for @editProfile_profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfile_profileUpdated;

  /// No description provided for @editProfile_changeProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Picture'**
  String get editProfile_changeProfilePicture;

  /// No description provided for @editProfile_chooseOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get editProfile_chooseOption;

  /// No description provided for @editProfile_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get editProfile_camera;

  /// No description provided for @editProfile_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get editProfile_gallery;

  /// No description provided for @editProfile_deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get editProfile_deleteAccountTitle;

  /// No description provided for @editProfile_deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.'**
  String get editProfile_deleteAccountMessage;

  /// No description provided for @bookingHistory_title.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory_title;

  /// No description provided for @bookingHistory_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookingHistory_all;

  /// No description provided for @bookingHistory_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get bookingHistory_upcoming;

  /// No description provided for @bookingHistory_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingHistory_completed;

  /// No description provided for @bookingHistory_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingHistory_cancelled;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get notifications_new;

  /// No description provided for @notifications_earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifications_earlier;

  /// No description provided for @notifications_bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your booking is confirmed!'**
  String get notifications_bookingConfirmed;

  /// No description provided for @notifications_bookingConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully booked \'{listing}\' for {dates}.'**
  String notifications_bookingConfirmedMessage(String listing, String dates);

  /// No description provided for @notifications_shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience'**
  String get notifications_shareExperience;

  /// No description provided for @notifications_reviewRequest.
  ///
  /// In en, this message translates to:
  /// **'Your stay at \'{listing}\' ended yesterday. How was it?'**
  String notifications_reviewRequest(String listing);

  /// No description provided for @notifications_addReviewNow.
  ///
  /// In en, this message translates to:
  /// **'Add Review Now'**
  String get notifications_addReviewNow;

  /// No description provided for @notifications_hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String notifications_hoursAgo(int count);

  /// No description provided for @notifications_hoursAgo_other.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String notifications_hoursAgo_other(Object count);

  /// No description provided for @notifications_daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String notifications_daysAgo(int count);

  /// No description provided for @notifications_daysAgo_other.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String notifications_daysAgo_other(Object count);

  /// No description provided for @notifications_rentalReminder.
  ///
  /// In en, this message translates to:
  /// **'Your \'{vehicle}\' rental is starting in {days} days.'**
  String notifications_rentalReminder(String vehicle, int days);

  /// No description provided for @notifications_newSummerDeals.
  ///
  /// In en, this message translates to:
  /// **'New summer deals!'**
  String get notifications_newSummerDeals;

  /// No description provided for @notifications_promotionalMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out our new listings with up to 20% off.'**
  String get notifications_promotionalMessage;

  /// No description provided for @addReview_title.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview_title;

  /// No description provided for @addReview_howWasStay.
  ///
  /// In en, this message translates to:
  /// **'How was your stay?'**
  String get addReview_howWasStay;

  /// No description provided for @addReview_shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help others'**
  String get addReview_shareExperience;

  /// No description provided for @addReview_overallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get addReview_overallRating;

  /// No description provided for @addReview_tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get addReview_tapToRate;

  /// No description provided for @addReview_stars.
  ///
  /// In en, this message translates to:
  /// **'{rating}/5 Stars'**
  String addReview_stars(int rating);

  /// No description provided for @addReview_quickReaction.
  ///
  /// In en, this message translates to:
  /// **'Quick Reaction'**
  String get addReview_quickReaction;

  /// No description provided for @addReview_terrible.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get addReview_terrible;

  /// No description provided for @addReview_poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get addReview_poor;

  /// No description provided for @addReview_average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get addReview_average;

  /// No description provided for @addReview_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get addReview_good;

  /// No description provided for @addReview_excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get addReview_excellent;

  /// No description provided for @addReview_yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get addReview_yourReview;

  /// No description provided for @addReview_tellUsExperience.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get addReview_tellUsExperience;

  /// No description provided for @addReview_charactersCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/300 characters'**
  String addReview_charactersCount(int count);

  /// No description provided for @addReview_submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get addReview_submitReview;

  /// No description provided for @addReview_submitted.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted!'**
  String get addReview_submitted;

  /// No description provided for @addReview_thankYouFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get addReview_thankYouFeedback;

  /// No description provided for @addReview_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get addReview_ok;

  /// No description provided for @confirmListing_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Post'**
  String get confirmListing_title;

  /// No description provided for @confirmListing_readyToPost.
  ///
  /// In en, this message translates to:
  /// **'Ready to Post!'**
  String get confirmListing_readyToPost;

  /// No description provided for @confirmListing_reviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Review your listing details before publishing'**
  String get confirmListing_reviewDetails;

  /// No description provided for @confirmListing_pricingSummary.
  ///
  /// In en, this message translates to:
  /// **'Pricing Summary'**
  String get confirmListing_pricingSummary;

  /// No description provided for @confirmListing_basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get confirmListing_basePrice;

  /// No description provided for @confirmListing_serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get confirmListing_serviceFee;

  /// No description provided for @confirmListing_totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get confirmListing_totalAmount;

  /// No description provided for @confirmListing_premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get confirmListing_premiumPlan;

  /// No description provided for @confirmListing_subscriptionDays.
  ///
  /// In en, this message translates to:
  /// **'30 days subscription'**
  String get confirmListing_subscriptionDays;

  /// No description provided for @confirmListing_proTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips'**
  String get confirmListing_proTips;

  /// No description provided for @confirmListing_tip1.
  ///
  /// In en, this message translates to:
  /// **'Add high-quality photos'**
  String get confirmListing_tip1;

  /// No description provided for @confirmListing_tip2.
  ///
  /// In en, this message translates to:
  /// **'Highlight special offers'**
  String get confirmListing_tip2;

  /// No description provided for @confirmListing_tip3.
  ///
  /// In en, this message translates to:
  /// **'Include contact information'**
  String get confirmListing_tip3;

  /// No description provided for @confirmListing_agreement.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and confirm all details are correct.'**
  String get confirmListing_agreement;

  /// No description provided for @confirmListing_postListing.
  ///
  /// In en, this message translates to:
  /// **'Post Listing'**
  String get confirmListing_postListing;

  /// No description provided for @confirmListing_listingPosted.
  ///
  /// In en, this message translates to:
  /// **'Listing posted successfully!'**
  String get confirmListing_listingPosted;

  /// No description provided for @blockUser_title.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser_title;

  /// No description provided for @blockUser_blockingSerious.
  ///
  /// In en, this message translates to:
  /// **'Blocking is a serious action'**
  String get blockUser_blockingSerious;

  /// No description provided for @blockUser_whatHappens.
  ///
  /// In en, this message translates to:
  /// **'What happens when you block {userName}?'**
  String blockUser_whatHappens(String userName);

  /// No description provided for @blockUser_consequence1.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to see your profile, posts, or stories'**
  String get blockUser_consequence1;

  /// No description provided for @blockUser_consequence2.
  ///
  /// In en, this message translates to:
  /// **'They can\'t send you comments'**
  String get blockUser_consequence2;

  /// No description provided for @blockUser_consequence3.
  ///
  /// In en, this message translates to:
  /// **'They won\'t be able to follow you or see your updates'**
  String get blockUser_consequence3;

  /// No description provided for @blockUser_consequence4.
  ///
  /// In en, this message translates to:
  /// **'You won\'t receive any notifications from them'**
  String get blockUser_consequence4;

  /// No description provided for @blockUser_consequence5.
  ///
  /// In en, this message translates to:
  /// **'They won\'t appear in your search results'**
  String get blockUser_consequence5;

  /// No description provided for @blockUser_note.
  ///
  /// In en, this message translates to:
  /// **'Note:'**
  String get blockUser_note;

  /// No description provided for @blockUser_noteMessage.
  ///
  /// In en, this message translates to:
  /// **'If you change your mind, you can unblock this user anytime from your settings. Blocking is reversible and does not notify the other user.'**
  String get blockUser_noteMessage;

  /// No description provided for @blockUser_blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser_blockUser;

  /// No description provided for @blockUser_userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User Blocked'**
  String get blockUser_userBlocked;

  /// No description provided for @blockUser_blockedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'You have successfully blocked {userName}. This user will no longer be able to interact with you or view your profile.'**
  String blockUser_blockedSuccessfully(String userName);

  /// No description provided for @blockUser_returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get blockUser_returnToHome;

  /// No description provided for @blockedUsers_title.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockedUsers_title;

  /// No description provided for @blockedUsers_info.
  ///
  /// In en, this message translates to:
  /// **'Blocked users cannot view your profile or contact you.'**
  String get blockedUsers_info;

  /// No description provided for @blockedUsers_unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock User?'**
  String get blockedUsers_unblockUser;

  /// No description provided for @blockedUsers_unblockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock {userName}? They will be able to interact with you and view your profile again.'**
  String blockedUsers_unblockConfirm(String userName);

  /// No description provided for @blockedUsers_unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get blockedUsers_unblock;

  /// No description provided for @blockedUsers_unblocked.
  ///
  /// In en, this message translates to:
  /// **'{userName} has been unblocked'**
  String blockedUsers_unblocked(String userName);

  /// No description provided for @blockedUsers_blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked: {date}'**
  String blockedUsers_blocked(String date);

  /// No description provided for @blockedUsers_noBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'No Blocked Users'**
  String get blockedUsers_noBlockedUsers;

  /// No description provided for @blockedUsers_emptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Users you block will appear here. You can unblock them anytime if you change your mind.'**
  String get blockedUsers_emptyMessage;

  /// No description provided for @listingHistory_title.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get listingHistory_title;

  /// No description provided for @listingHistory_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get listingHistory_all;

  /// No description provided for @listingHistory_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get listingHistory_active;

  /// No description provided for @listingHistory_drafts.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get listingHistory_drafts;

  /// No description provided for @listingHistory_noPostsFound.
  ///
  /// In en, this message translates to:
  /// **'No Posts Found'**
  String get listingHistory_noPostsFound;

  /// No description provided for @listingHistory_noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any posts yet.'**
  String get listingHistory_noPostsYet;

  /// No description provided for @listingHistory_noFilterPosts.
  ///
  /// In en, this message translates to:
  /// **'No {filter} posts found.'**
  String listingHistory_noFilterPosts(String filter);

  /// No description provided for @listingHistory_published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get listingHistory_published;

  /// No description provided for @listingHistory_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get listingHistory_draft;

  /// No description provided for @listingHistory_editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get listingHistory_editPost;

  /// No description provided for @listingHistory_deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get listingHistory_deletePost;

  /// No description provided for @listingHistory_publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get listingHistory_publish;

  /// No description provided for @listingHistory_archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get listingHistory_archive;

  /// No description provided for @listingHistory_deletePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get listingHistory_deletePostTitle;

  /// No description provided for @listingHistory_editing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get listingHistory_editing;

  /// No description provided for @listingHistory_deletePostConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String listingHistory_deletePostConfirm(String title);

  /// No description provided for @listingHistory_deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting: {title}'**
  String listingHistory_deleting(String title);

  /// No description provided for @listingHistory_postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get listingHistory_postDeleted;

  /// No description provided for @listingHistory_postPublished.
  ///
  /// In en, this message translates to:
  /// **'Post published successfully'**
  String get listingHistory_postPublished;

  /// No description provided for @listingHistory_postArchived.
  ///
  /// In en, this message translates to:
  /// **'Post archived'**
  String get listingHistory_postArchived;

  /// No description provided for @reportUser_title.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportUser_title;

  /// No description provided for @reportUser_tellUsWrong.
  ///
  /// In en, this message translates to:
  /// **'Tell us what\'s wrong'**
  String get reportUser_tellUsWrong;

  /// No description provided for @reportUser_inappropriateContent.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reportUser_inappropriateContent;

  /// No description provided for @reportUser_spamOrScam.
  ///
  /// In en, this message translates to:
  /// **'Spam or scam'**
  String get reportUser_spamOrScam;

  /// No description provided for @reportUser_misleadingInfo.
  ///
  /// In en, this message translates to:
  /// **'Misleading information'**
  String get reportUser_misleadingInfo;

  /// No description provided for @reportUser_safetyConcern.
  ///
  /// In en, this message translates to:
  /// **'Safety concern'**
  String get reportUser_safetyConcern;

  /// No description provided for @reportUser_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportUser_other;

  /// No description provided for @reportUser_additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional Details (Optional)'**
  String get reportUser_additionalDetails;

  /// No description provided for @reportUser_provideMoreInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide more information'**
  String get reportUser_provideMoreInfo;

  /// No description provided for @reportUser_submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportUser_submitReport;

  /// No description provided for @reportUser_selectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for reporting'**
  String get reportUser_selectReason;

  /// No description provided for @reportUser_reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report Submitted'**
  String get reportUser_reportSubmitted;

  /// No description provided for @reportUser_thankYouReport.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your report. We will review it and take appropriate action if necessary.'**
  String get reportUser_thankYouReport;

  /// No description provided for @reportUser_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get reportUser_done;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @forgotPassword_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get forgotPassword_instructions;

  /// No description provided for @forgotPassword_helpText.
  ///
  /// In en, this message translates to:
  /// **'Check your spam folder if you don\'t receive the email within a few minutes.'**
  String get forgotPassword_helpText;

  /// No description provided for @forgotPassword_iconText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Just enter your email and we\'ll send you a reset link.'**
  String get forgotPassword_iconText;

  /// No description provided for @forgotPassword_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgotPassword_emailLabel;

  /// No description provided for @forgotPassword_emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgotPassword_emailEmptyError;

  /// No description provided for @forgotPassword_emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get forgotPassword_emailInvalidError;

  /// No description provided for @forgotPassword_resetLink.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get forgotPassword_resetLink;

  /// No description provided for @forgotPassword_sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotPassword_sendButton;

  /// No description provided for @forgotPassword_backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get forgotPassword_backToLogin;

  /// No description provided for @search_wilaya.
  ///
  /// In en, this message translates to:
  /// **'Search wilaya'**
  String get search_wilaya;

  /// No description provided for @choose_wilaya.
  ///
  /// In en, this message translates to:
  /// **'Choose wilaya'**
  String get choose_wilaya;

  /// No description provided for @enter_price.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enter_price;

  /// No description provided for @enter_max_price.
  ///
  /// In en, this message translates to:
  /// **'Enter max price'**
  String get enter_max_price;

  /// No description provided for @no_wilaya_found.
  ///
  /// In en, this message translates to:
  /// **'No wilaya found'**
  String get no_wilaya_found;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @dinars.
  ///
  /// In en, this message translates to:
  /// **'DZD'**
  String get dinars;

  /// No description provided for @subscription_update_success.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been updated successfully'**
  String get subscription_update_success;

  /// No description provided for @bookings_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bookings_cancel;

  /// No description provided for @bookings_cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get bookings_cancelBooking;

  /// No description provided for @bookings_cancelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get bookings_cancelConfirmation;

  /// No description provided for @bookings_canceledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking canceled successfully'**
  String get bookings_canceledSuccessfully;

  /// No description provided for @bookings_cancelationError.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel booking. Please try again.'**
  String get bookings_cancelationError;

  /// No description provided for @common_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get common_yes;

  /// No description provided for @common_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get common_no;

  /// No description provided for @details_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get details_description;

  /// No description provided for @details_stayType.
  ///
  /// In en, this message translates to:
  /// **'Stay Type'**
  String get details_stayType;

  /// No description provided for @details_bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get details_bedrooms;

  /// No description provided for @details_area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get details_area;

  /// No description provided for @details_vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get details_vehicleType;

  /// No description provided for @details_model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get details_model;

  /// No description provided for @details_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get details_year;

  /// No description provided for @details_fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get details_fuelType;

  /// No description provided for @details_transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get details_transmission;

  /// No description provided for @details_automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get details_automatic;

  /// No description provided for @details_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get details_manual;

  /// No description provided for @details_seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get details_seats;

  /// No description provided for @details_features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get details_features;

  /// No description provided for @details_activityType.
  ///
  /// In en, this message translates to:
  /// **'Activity Type'**
  String get details_activityType;

  /// No description provided for @details_noAdditionalDetails.
  ///
  /// In en, this message translates to:
  /// **'No additional details available'**
  String get details_noAdditionalDetails;

  /// No description provided for @details_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get details_price;

  /// No description provided for @details_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get details_available;

  /// No description provided for @details_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get details_unavailable;

  /// No description provided for @details_pricePerNight.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get details_pricePerNight;

  /// No description provided for @details_pricePerDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get details_pricePerDay;

  /// No description provided for @details_pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'person'**
  String get details_pricePerPerson;

  /// No description provided for @details_pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get details_pricePerUnit;

  /// No description provided for @no_posts_yet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get no_posts_yet;

  /// No description provided for @no_matching_posts.
  ///
  /// In en, this message translates to:
  /// **'No matching posts'**
  String get no_matching_posts;

  /// No description provided for @categorySelection_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get categorySelection_continue;

  /// No description provided for @vehicleCategory_description.
  ///
  /// In en, this message translates to:
  /// **'Rent cars, motorcycles, bicycles, or boats'**
  String get vehicleCategory_description;

  /// No description provided for @stayCategory_description.
  ///
  /// In en, this message translates to:
  /// **'Rent apartments, villas, rooms, or houses'**
  String get stayCategory_description;

  /// No description provided for @activityCategory_description.
  ///
  /// In en, this message translates to:
  /// **'Offer tours, workshops, adventures, or experiences'**
  String get activityCategory_description;

  /// No description provided for @choose_listing_category.
  ///
  /// In en, this message translates to:
  /// **'Choose Listing Category'**
  String get choose_listing_category;

  /// No description provided for @select_type_of_listing.
  ///
  /// In en, this message translates to:
  /// **'Select the type of listing you want to create'**
  String get select_type_of_listing;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @stay_details_title.
  ///
  /// In en, this message translates to:
  /// **'Stay Details'**
  String get stay_details_title;

  /// No description provided for @stay_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide details about your stay'**
  String get stay_details_subtitle;

  /// No description provided for @rate_label.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate_label;

  /// No description provided for @rate_error.
  ///
  /// In en, this message translates to:
  /// **'Please select rate'**
  String get rate_error;

  /// No description provided for @stay_type_label.
  ///
  /// In en, this message translates to:
  /// **'Stay Type'**
  String get stay_type_label;

  /// No description provided for @stay_type_error.
  ///
  /// In en, this message translates to:
  /// **'Please select stay type'**
  String get stay_type_error;

  /// No description provided for @price_label.
  ///
  /// In en, this message translates to:
  /// **'Price (DA)'**
  String get price_label;

  /// No description provided for @price_error_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get price_error_required;

  /// No description provided for @price_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get price_error_invalid;

  /// No description provided for @area_label.
  ///
  /// In en, this message translates to:
  /// **'Area (m²)'**
  String get area_label;

  /// No description provided for @area_error_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter area'**
  String get area_error_required;

  /// No description provided for @area_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get area_error_invalid;

  /// No description provided for @bedrooms_label.
  ///
  /// In en, this message translates to:
  /// **'Number of Bedrooms'**
  String get bedrooms_label;

  /// No description provided for @bedrooms_error_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter number of bedrooms'**
  String get bedrooms_error_required;

  /// No description provided for @bedrooms_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get bedrooms_error_invalid;

  /// No description provided for @form_error_fill_all.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields correctly'**
  String get form_error_fill_all;

  /// No description provided for @continue_button.
  ///
  /// In en, this message translates to:
  /// **'Continue to Location'**
  String get continue_button;

  /// No description provided for @vehicle_details_title.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicle_details_title;

  /// No description provided for @vehicle_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide details about your vehicle'**
  String get vehicle_details_subtitle;

  /// No description provided for @vehicle_type_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicle_type_label;

  /// No description provided for @vehicle_type_error.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type'**
  String get vehicle_type_error;

  /// No description provided for @model_label.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model_label;

  /// No description provided for @model_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter model'**
  String get model_error;

  /// No description provided for @year_label.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year_label;

  /// No description provided for @year_error_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter year'**
  String get year_error_empty;

  /// No description provided for @year_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get year_error_invalid;

  /// No description provided for @year_error_range.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year (1900-{maxYear})'**
  String year_error_range(int maxYear);

  /// No description provided for @fuel_type_label.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuel_type_label;

  /// No description provided for @fuel_type_error.
  ///
  /// In en, this message translates to:
  /// **'Please select fuel type'**
  String get fuel_type_error;

  /// No description provided for @transmission_label.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission_label;

  /// No description provided for @transmission_manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get transmission_manual;

  /// No description provided for @transmission_automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get transmission_automatic;

  /// No description provided for @seats_label.
  ///
  /// In en, this message translates to:
  /// **'Number of Seats'**
  String get seats_label;

  /// No description provided for @seats_error_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter number of seats'**
  String get seats_error_empty;

  /// No description provided for @seats_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get seats_error_invalid;

  /// No description provided for @seats_error_range.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid number of seats (1-100)'**
  String get seats_error_range;

  /// No description provided for @activity_details_title.
  ///
  /// In en, this message translates to:
  /// **'Activity Details'**
  String get activity_details_title;

  /// No description provided for @activity_details_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide details about your activity'**
  String get activity_details_subtitle;

  /// No description provided for @activity_type_label.
  ///
  /// In en, this message translates to:
  /// **'Activity Type'**
  String get activity_type_label;

  /// No description provided for @activity_type_error.
  ///
  /// In en, this message translates to:
  /// **'Please select activity type'**
  String get activity_type_error;

  /// No description provided for @requirements_title.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements_title;

  /// No description provided for @minimum_age.
  ///
  /// In en, this message translates to:
  /// **'Minimum Age'**
  String get minimum_age;

  /// No description provided for @minimum_age_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter minimum age'**
  String get minimum_age_error;

  /// No description provided for @valid_number_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get valid_number_error;

  /// No description provided for @years_label.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years_label;

  /// No description provided for @minimum_age_required.
  ///
  /// In en, this message translates to:
  /// **'Minimum age required'**
  String get minimum_age_required;

  /// No description provided for @duration_label.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration_label;

  /// No description provided for @duration_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter duration'**
  String get duration_error;

  /// No description provided for @hours_label.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours_label;

  /// No description provided for @duration_description.
  ///
  /// In en, this message translates to:
  /// **'Activity duration in hours'**
  String get duration_description;

  /// No description provided for @group_size_label.
  ///
  /// In en, this message translates to:
  /// **'Maximum Group Size'**
  String get group_size_label;

  /// No description provided for @group_size_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter group size'**
  String get group_size_error;

  /// No description provided for @persons_label.
  ///
  /// In en, this message translates to:
  /// **'Persons'**
  String get persons_label;

  /// No description provided for @max_participants.
  ///
  /// In en, this message translates to:
  /// **'Maximum participants allowed'**
  String get max_participants;

  /// No description provided for @additional_requirements.
  ///
  /// In en, this message translates to:
  /// **'Additional Requirements (Optional)'**
  String get additional_requirements;

  /// No description provided for @requirement_name.
  ///
  /// In en, this message translates to:
  /// **'Requirement Name'**
  String get requirement_name;

  /// No description provided for @requirement_value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get requirement_value;

  /// No description provided for @example_text.
  ///
  /// In en, this message translates to:
  /// **'Example: \"Insurance\" = \"Required\", \"Language\" = \"English\"'**
  String get example_text;

  /// No description provided for @equipment_label.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment_label;

  /// No description provided for @select_equipment.
  ///
  /// In en, this message translates to:
  /// **'Select equipment'**
  String get select_equipment;

  /// No description provided for @equipment_error.
  ///
  /// In en, this message translates to:
  /// **'Please select equipment option'**
  String get equipment_error;

  /// No description provided for @experience_label.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get experience_label;

  /// No description provided for @select_experience.
  ///
  /// In en, this message translates to:
  /// **'Select experience'**
  String get select_experience;

  /// No description provided for @experience_error.
  ///
  /// In en, this message translates to:
  /// **'Please select experience level'**
  String get experience_error;

  /// No description provided for @appbar_complete_listing.
  ///
  /// In en, this message translates to:
  /// **'Complete Listing'**
  String get appbar_complete_listing;

  /// No description provided for @header_complete_listing.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Listing'**
  String get header_complete_listing;

  /// No description provided for @subtitle_complete_listing.
  ///
  /// In en, this message translates to:
  /// **'Add location, photos, and availability'**
  String get subtitle_complete_listing;

  /// No description provided for @photos_section_title.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos_section_title;

  /// No description provided for @photos_description.
  ///
  /// In en, this message translates to:
  /// **'Add photos to make your listing more attractive'**
  String get photos_description;

  /// No description provided for @add_button.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_button;

  /// No description provided for @gallery_option.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get gallery_option;

  /// No description provided for @camera_option.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get camera_option;

  /// No description provided for @select_location_button.
  ///
  /// In en, this message translates to:
  /// **'Select Location on Map'**
  String get select_location_button;

  /// No description provided for @location_selected.
  ///
  /// In en, this message translates to:
  /// **'Location Selected ({latitude}, {longitude})'**
  String location_selected(String latitude, String longitude);

  /// No description provided for @location_preview_not_selected.
  ///
  /// In en, this message translates to:
  /// **'Select\nLocation'**
  String get location_preview_not_selected;

  /// No description provided for @location_preview_selected.
  ///
  /// In en, this message translates to:
  /// **'Location\nSelected'**
  String get location_preview_selected;

  /// No description provided for @location_section.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location_section;

  /// No description provided for @wilaya_label.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get wilaya_label;

  /// No description provided for @wilaya_validation.
  ///
  /// In en, this message translates to:
  /// **'Please select wilaya'**
  String get wilaya_validation;

  /// No description provided for @city_label.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city_label;

  /// No description provided for @city_validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get city_validation;

  /// No description provided for @address_label.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address_label;

  /// No description provided for @address_validation.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get address_validation;

  /// No description provided for @availability_section.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability_section;

  /// No description provided for @availability_description.
  ///
  /// In en, this message translates to:
  /// **'Add time periods when your listing is available'**
  String get availability_description;

  /// No description provided for @availability_empty.
  ///
  /// In en, this message translates to:
  /// **'No availability periods added'**
  String get availability_empty;

  /// No description provided for @availability_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {days} days'**
  String availability_duration(int days);

  /// No description provided for @add_availability_button.
  ///
  /// In en, this message translates to:
  /// **'Add Availability Period'**
  String get add_availability_button;

  /// No description provided for @datepicker_help.
  ///
  /// In en, this message translates to:
  /// **'Select availability period'**
  String get datepicker_help;

  /// No description provided for @submit_button.
  ///
  /// In en, this message translates to:
  /// **'Review and Submit'**
  String get submit_button;

  /// No description provided for @form_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields correctly'**
  String get form_validation_error;

  /// No description provided for @time_validation_error.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get time_validation_error;

  /// No description provided for @home_screen_choose_type.
  ///
  /// In en, this message translates to:
  /// **'choose type'**
  String get home_screen_choose_type;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password you haven’t used before.'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmptyError;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatchError;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccess;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password'**
  String get resetPasswordFailed;

  /// No description provided for @securityRedirectHint.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, you’ll be redirected to login after updating your password.'**
  String get securityRedirectHint;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password to keep your account secure.'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordLabel;

  /// No description provided for @currentPasswordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequiredError;

  /// No description provided for @newPasswordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequiredError;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordButton;

  /// No description provided for @updatePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update password'**
  String get updatePasswordFailed;

  /// No description provided for @reloginHint.
  ///
  /// In en, this message translates to:
  /// **'After changing your password, you may be asked to log in again.'**
  String get reloginHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
