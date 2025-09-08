import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Work Shifts'**
  String get app_title;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @reset_calendar.
  ///
  /// In en, this message translates to:
  /// **'Reset Calendar'**
  String get reset_calendar;

  /// No description provided for @reset_summary.
  ///
  /// In en, this message translates to:
  /// **'Reset Summary'**
  String get reset_summary;

  /// No description provided for @reset_custom_shifts.
  ///
  /// In en, this message translates to:
  /// **'Reset Custom Shifts'**
  String get reset_custom_shifts;

  /// No description provided for @reset_app.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get reset_app;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restore_2.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore_2;

  /// No description provided for @backup_and_restore.
  ///
  /// In en, this message translates to:
  /// **'Backup and Restore'**
  String get backup_and_restore;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts: \n'**
  String get contacts;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-Mail:'**
  String get email;

  /// No description provided for @debug_mode.
  ///
  /// In en, this message translates to:
  /// **'Debug Mode'**
  String get debug_mode;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @customize_shifts.
  ///
  /// In en, this message translates to:
  /// **'Customize shifts'**
  String get customize_shifts;

  /// No description provided for @shift_hours.
  ///
  /// In en, this message translates to:
  /// **'Shift hours'**
  String get shift_hours;

  /// No description provided for @select_duration.
  ///
  /// In en, this message translates to:
  /// **'Select shift duration'**
  String get select_duration;

  /// No description provided for @exit_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm exit'**
  String get exit_confirmation;

  /// No description provided for @do_you_want_to_exit.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to exit the app?'**
  String get do_you_want_to_exit;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @select_month_year.
  ///
  /// In en, this message translates to:
  /// **'Select month and year'**
  String get select_month_year;

  /// No description provided for @select_year.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get select_year;

  /// No description provided for @select_shift.
  ///
  /// In en, this message translates to:
  /// **'Select shift'**
  String get select_shift;

  /// No description provided for @no_custom_shifts.
  ///
  /// In en, this message translates to:
  /// **'No saved shifts. You can add them from the Settings screen.'**
  String get no_custom_shifts;

  /// No description provided for @no_custom_shifts_short.
  ///
  /// In en, this message translates to:
  /// **'No custom shifts'**
  String get no_custom_shifts_short;

  /// No description provided for @add_shift.
  ///
  /// In en, this message translates to:
  /// **'Add shift'**
  String get add_shift;

  /// No description provided for @edit_shift.
  ///
  /// In en, this message translates to:
  /// **'Edit shift'**
  String get edit_shift;

  /// Confirmation message for deleting a custom shift
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the shift \"{shift}\"? This action cannot be undone.'**
  String delete_shift_confirm(String shift);

  /// No description provided for @shift_name.
  ///
  /// In en, this message translates to:
  /// **'Shift name'**
  String get shift_name;

  /// No description provided for @shift_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get shift_name_required;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration (hh:mm)'**
  String get duration;

  /// Duration with placeholder
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration2}'**
  String duration2(String duration2);

  /// No description provided for @initial_place.
  ///
  /// In en, this message translates to:
  /// **'Initial place'**
  String get initial_place;

  /// No description provided for @final_place.
  ///
  /// In en, this message translates to:
  /// **'Final place'**
  String get final_place;

  /// No description provided for @shift_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Shift duration:'**
  String get shift_duration_label;

  /// No description provided for @shift_tag.
  ///
  /// In en, this message translates to:
  /// **'Shift tag'**
  String get shift_tag;

  /// No description provided for @save_shift.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_shift;

  /// No description provided for @cancel_shift.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_shift;

  /// No description provided for @delete_shift.
  ///
  /// In en, this message translates to:
  /// **'Delete shift'**
  String get delete_shift;

  /// No description provided for @edit_duration.
  ///
  /// In en, this message translates to:
  /// **'Edit shift duration'**
  String get edit_duration;

  /// No description provided for @edit_overtime.
  ///
  /// In en, this message translates to:
  /// **'Edit overtime'**
  String get edit_overtime;

  /// No description provided for @edit_summary.
  ///
  /// In en, this message translates to:
  /// **'Edit summary'**
  String get edit_summary;

  /// No description provided for @overtime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get overtime;

  /// No description provided for @overtime_2.
  ///
  /// In en, this message translates to:
  /// **'Overtime: '**
  String get overtime_2;

  /// No description provided for @overtime_gross.
  ///
  /// In en, this message translates to:
  /// **'Overtime (gross without breaks)'**
  String get overtime_gross;

  /// No description provided for @overtime_net.
  ///
  /// In en, this message translates to:
  /// **'Overtime (net of breaks)'**
  String get overtime_net;

  /// No description provided for @overtime_hours.
  ///
  /// In en, this message translates to:
  /// **'Overtime (Hours)'**
  String get overtime_hours;

  /// No description provided for @overtime_hours_label.
  ///
  /// In en, this message translates to:
  /// **'Overtime (Hours):'**
  String get overtime_hours_label;

  /// No description provided for @overtime_calendar_hours.
  ///
  /// In en, this message translates to:
  /// **'Overtime hours:'**
  String get overtime_calendar_hours;

  /// No description provided for @no_breaks.
  ///
  /// In en, this message translates to:
  /// **'No breaks recorded'**
  String get no_breaks;

  /// No description provided for @breaks.
  ///
  /// In en, this message translates to:
  /// **'Unpaid breaks'**
  String get breaks;

  /// No description provided for @breaks_total.
  ///
  /// In en, this message translates to:
  /// **'Total breaks'**
  String get breaks_total;

  /// No description provided for @breaks_total_label.
  ///
  /// In en, this message translates to:
  /// **'Total breaks:'**
  String get breaks_total_label;

  /// No description provided for @breaks_label.
  ///
  /// In en, this message translates to:
  /// **'Breaks:'**
  String get breaks_label;

  /// No description provided for @breaks_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit break'**
  String get breaks_edit;

  /// No description provided for @breaks_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get breaks_duration;

  /// No description provided for @add_break.
  ///
  /// In en, this message translates to:
  /// **'Add break'**
  String get add_break;

  /// No description provided for @delete_break.
  ///
  /// In en, this message translates to:
  /// **'Delete break'**
  String get delete_break;

  /// No description provided for @delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get delete_confirm;

  /// No description provided for @delete_break_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this break?'**
  String get delete_break_confirm;

  /// No description provided for @delete_day_data.
  ///
  /// In en, this message translates to:
  /// **'Delete day data'**
  String get delete_day_data;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get notes;

  /// No description provided for @clear_notes.
  ///
  /// In en, this message translates to:
  /// **'Clear notes'**
  String get clear_notes;

  /// No description provided for @select_number.
  ///
  /// In en, this message translates to:
  /// **'Select a number'**
  String get select_number;

  /// No description provided for @shift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @effective_shift.
  ///
  /// In en, this message translates to:
  /// **'Effective shift'**
  String get effective_shift;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @overtime_breaks.
  ///
  /// In en, this message translates to:
  /// **'Overtime and Breaks: '**
  String get overtime_breaks;

  /// No description provided for @overtime_breaks2.
  ///
  /// In en, this message translates to:
  /// **'Overtime and Breaks'**
  String get overtime_breaks2;

  /// No description provided for @overtime_breaks_info.
  ///
  /// In en, this message translates to:
  /// **'Overtime and breaks details'**
  String get overtime_breaks_info;

  /// No description provided for @notes_short.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes_short;

  /// Confirmation message for deleting a day's data
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the data for the day {date}?'**
  String delete_day_confirm(String date);

  /// No description provided for @add_day.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_day;

  /// No description provided for @no_day_data.
  ///
  /// In en, this message translates to:
  /// **'No data found for this day, you can add some by pressing the Add button.'**
  String get no_day_data;

  /// No description provided for @holidays_available.
  ///
  /// In en, this message translates to:
  /// **'Available Holidays'**
  String get holidays_available;

  /// No description provided for @holidays_left.
  ///
  /// In en, this message translates to:
  /// **'Holidays Left'**
  String get holidays_left;

  /// No description provided for @holidays_taken.
  ///
  /// In en, this message translates to:
  /// **'Holidays Taken'**
  String get holidays_taken;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Days Off'**
  String get rest;

  /// No description provided for @missed_performance.
  ///
  /// In en, this message translates to:
  /// **'Missed Performances'**
  String get missed_performance;

  /// No description provided for @suppressed_holidays.
  ///
  /// In en, this message translates to:
  /// **'Suppressed Holidays'**
  String get suppressed_holidays;

  /// No description provided for @work_suspension.
  ///
  /// In en, this message translates to:
  /// **'Work Suspension'**
  String get work_suspension;

  /// No description provided for @accessory_times.
  ///
  /// In en, this message translates to:
  /// **'Accessory Times'**
  String get accessory_times;

  /// No description provided for @paid_leave.
  ///
  /// In en, this message translates to:
  /// **'Paid Leave'**
  String get paid_leave;

  /// No description provided for @midweek_holidays.
  ///
  /// In en, this message translates to:
  /// **'Midweek Holidays'**
  String get midweek_holidays;

  /// No description provided for @illness.
  ///
  /// In en, this message translates to:
  /// **'Sickness'**
  String get illness;

  /// No description provided for @law_104.
  ///
  /// In en, this message translates to:
  /// **'Law 104'**
  String get law_104;

  /// No description provided for @parental_leave.
  ///
  /// In en, this message translates to:
  /// **'Parental Leave'**
  String get parental_leave;

  /// No description provided for @missed_performance_adequacy.
  ///
  /// In en, this message translates to:
  /// **'Missed Performance Adjustments'**
  String get missed_performance_adequacy;

  /// No description provided for @holidays_available_plus_prev.
  ///
  /// In en, this message translates to:
  /// **'Available Holidays: '**
  String get holidays_available_plus_prev;

  /// No description provided for @holidays_prev.
  ///
  /// In en, this message translates to:
  /// **'(+AH previous year)'**
  String get holidays_prev;

  /// No description provided for @holidays_left_label.
  ///
  /// In en, this message translates to:
  /// **'Holidays Left:'**
  String get holidays_left_label;

  /// No description provided for @holidays_taken_label.
  ///
  /// In en, this message translates to:
  /// **'Holidays Taken:'**
  String get holidays_taken_label;

  /// No description provided for @rest_label.
  ///
  /// In en, this message translates to:
  /// **'Days Off:'**
  String get rest_label;

  /// No description provided for @missed_performance_label.
  ///
  /// In en, this message translates to:
  /// **'Missed Performances:'**
  String get missed_performance_label;

  /// No description provided for @suppressed_holidays_label.
  ///
  /// In en, this message translates to:
  /// **'Suppressed Holidays:'**
  String get suppressed_holidays_label;

  /// No description provided for @work_suspension_label.
  ///
  /// In en, this message translates to:
  /// **'Work Suspension:'**
  String get work_suspension_label;

  /// No description provided for @accessory_times_label.
  ///
  /// In en, this message translates to:
  /// **'Accessory Times:'**
  String get accessory_times_label;

  /// No description provided for @paid_leave_label.
  ///
  /// In en, this message translates to:
  /// **'Paid Leave:'**
  String get paid_leave_label;

  /// No description provided for @midweek_holidays_label.
  ///
  /// In en, this message translates to:
  /// **'Midweek Holidays:'**
  String get midweek_holidays_label;

  /// No description provided for @illness_label.
  ///
  /// In en, this message translates to:
  /// **'Sickness:'**
  String get illness_label;

  /// No description provided for @law_104_label.
  ///
  /// In en, this message translates to:
  /// **'Law 104:'**
  String get law_104_label;

  /// No description provided for @parental_leave_label.
  ///
  /// In en, this message translates to:
  /// **'Parental Leave:'**
  String get parental_leave_label;

  /// No description provided for @missed_performance_adequacy_label.
  ///
  /// In en, this message translates to:
  /// **'Missed Performance Adjustments:'**
  String get missed_performance_adequacy_label;

  /// Backup export confirmation message
  ///
  /// In en, this message translates to:
  /// **'Backup exported to {path}'**
  String backup_exported(String path);

  /// No description provided for @backup_imported.
  ///
  /// In en, this message translates to:
  /// **'Backup imported successfully!'**
  String get backup_imported;

  /// Backup export error message
  ///
  /// In en, this message translates to:
  /// **'Error during export: {error}'**
  String backup_export_error(String error);

  /// Backup import error message
  ///
  /// In en, this message translates to:
  /// **'Error during import: {error}'**
  String backup_import_error(String error);

  /// No description provided for @export_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Export cancelled.'**
  String get export_cancelled;

  /// No description provided for @element_visibility.
  ///
  /// In en, this message translates to:
  /// **'Element visibility'**
  String get element_visibility;

  /// No description provided for @where_to_save_backup.
  ///
  /// In en, this message translates to:
  /// **'Choose where to save the backup'**
  String get where_to_save_backup;

  /// No description provided for @reset_visibility_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to restore the default visibility of summary items and reset all available vacation and adjustment allowances for all years?'**
  String get reset_visibility_confirm;

  /// No description provided for @reset_calendar_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all daily shift data?'**
  String get reset_calendar_confirm;

  /// No description provided for @reset_summary_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to restore the default visibility of summary items and reset all available holidays and missed performance adjustments for all years?'**
  String get reset_summary_confirm;

  /// No description provided for @reset_custom_shifts_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all custom shift data?'**
  String get reset_custom_shifts_confirm;

  /// No description provided for @reset_app_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data and restart the app?'**
  String get reset_app_confirm;

  /// No description provided for @reset_app_confirm2.
  ///
  /// In en, this message translates to:
  /// **'This action will irreversibly delete ALL application data. Do you really want to proceed?'**
  String get reset_app_confirm2;

  /// No description provided for @reset_visibility_done.
  ///
  /// In en, this message translates to:
  /// **'Summary visibility settings restored.'**
  String get reset_visibility_done;

  /// No description provided for @reset_calendar_done.
  ///
  /// In en, this message translates to:
  /// **'All daily shift data has been deleted.'**
  String get reset_calendar_done;

  /// No description provided for @reset_summary_done.
  ///
  /// In en, this message translates to:
  /// **'Visibility settings and annual summary values restored.'**
  String get reset_summary_done;

  /// No description provided for @reset_custom_shifts_done.
  ///
  /// In en, this message translates to:
  /// **'All custom shift data has been deleted.'**
  String get reset_custom_shifts_done;

  /// No description provided for @reset_app_done.
  ///
  /// In en, this message translates to:
  /// **'All data has been deleted.'**
  String get reset_app_done;

  /// No description provided for @visibility_reset_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm visibility reset'**
  String get visibility_reset_confirm;

  /// No description provided for @confirm_reset.
  ///
  /// In en, this message translates to:
  /// **'Confirm reset'**
  String get confirm_reset;

  /// No description provided for @data_saved.
  ///
  /// In en, this message translates to:
  /// **'Data saved'**
  String get data_saved;

  /// No description provided for @no_breaks_entered.
  ///
  /// In en, this message translates to:
  /// **'No breaks entered'**
  String get no_breaks_entered;

  /// No description provided for @no_custom_shifts_found.
  ///
  /// In en, this message translates to:
  /// **'No custom shifts found'**
  String get no_custom_shifts_found;

  /// No description provided for @no_day_found.
  ///
  /// In en, this message translates to:
  /// **'No data found for this day'**
  String get no_day_found;

  /// No description provided for @select_month.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get select_month;

  /// No description provided for @select_year_label.
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get select_year_label;

  /// No description provided for @select_shift_label.
  ///
  /// In en, this message translates to:
  /// **'Select shift'**
  String get select_shift_label;

  /// No description provided for @edit_shift_label.
  ///
  /// In en, this message translates to:
  /// **'Edit shift'**
  String get edit_shift_label;

  /// No description provided for @delete_shift_label.
  ///
  /// In en, this message translates to:
  /// **'Delete shift'**
  String get delete_shift_label;

  /// No description provided for @add_shift_label.
  ///
  /// In en, this message translates to:
  /// **'Add shift'**
  String get add_shift_label;

  /// No description provided for @edit_break_label.
  ///
  /// In en, this message translates to:
  /// **'Edit break'**
  String get edit_break_label;

  /// No description provided for @delete_break_label.
  ///
  /// In en, this message translates to:
  /// **'Delete break'**
  String get delete_break_label;

  /// No description provided for @add_break_label.
  ///
  /// In en, this message translates to:
  /// **'Add break'**
  String get add_break_label;

  /// No description provided for @edit_notes_label.
  ///
  /// In en, this message translates to:
  /// **'Edit notes'**
  String get edit_notes_label;

  /// No description provided for @clear_notes_label.
  ///
  /// In en, this message translates to:
  /// **'Clear notes'**
  String get clear_notes_label;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get attention;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @tag_holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get tag_holidays;

  /// No description provided for @tag_rest.
  ///
  /// In en, this message translates to:
  /// **'Days Off'**
  String get tag_rest;

  /// No description provided for @tag_missed_performance.
  ///
  /// In en, this message translates to:
  /// **'Missed Performances'**
  String get tag_missed_performance;

  /// No description provided for @tag_suppressed_holidays.
  ///
  /// In en, this message translates to:
  /// **'Suppressed Holidays'**
  String get tag_suppressed_holidays;

  /// No description provided for @tag_work_suspension.
  ///
  /// In en, this message translates to:
  /// **'Work Suspension'**
  String get tag_work_suspension;

  /// No description provided for @tag_accessory_times.
  ///
  /// In en, this message translates to:
  /// **'Accessory Times'**
  String get tag_accessory_times;

  /// No description provided for @tag_paid_leave.
  ///
  /// In en, this message translates to:
  /// **'Paid Leave'**
  String get tag_paid_leave;

  /// No description provided for @tag_midweek_holidays.
  ///
  /// In en, this message translates to:
  /// **'Midweek Holidays'**
  String get tag_midweek_holidays;

  /// No description provided for @tag_illness.
  ///
  /// In en, this message translates to:
  /// **'Sickness'**
  String get tag_illness;

  /// No description provided for @tag_law_104.
  ///
  /// In en, this message translates to:
  /// **'Law 104'**
  String get tag_law_104;

  /// No description provided for @tag_parental_leave.
  ///
  /// In en, this message translates to:
  /// **'Parental Leave'**
  String get tag_parental_leave;

  /// No description provided for @tag_missed_performance_adequacy.
  ///
  /// In en, this message translates to:
  /// **'Missed Performance Adjustments'**
  String get tag_missed_performance_adequacy;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
