// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Work Shifts';

  @override
  String get calendar => 'Calendar';

  @override
  String get summary => 'Summary';

  @override
  String get settings => 'Settings';

  @override
  String get info => 'Information';

  @override
  String get menu => 'Menu';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get reset => 'Reset';

  @override
  String get reset_calendar => 'Reset Calendar';

  @override
  String get reset_summary => 'Reset Summary';

  @override
  String get reset_custom_shifts => 'Reset Custom Shifts';

  @override
  String get reset_app => 'Reset App';

  @override
  String get close => 'Close';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get contacts => 'Contacts:';

  @override
  String get email => 'E-Mail:';

  @override
  String get debug_mode => 'Debug Mode';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get customize_shifts => 'Customize shifts';

  @override
  String get shift_hours => 'Shift hours';

  @override
  String get select_duration => 'Select shift duration';

  @override
  String get exit_confirmation => 'Confirm exit';

  @override
  String get do_you_want_to_exit => 'Do you really want to exit the app?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get select_month_year => 'Select month and year';

  @override
  String get select_year => 'Select Year';

  @override
  String get select_shift => 'Select shift';

  @override
  String get no_custom_shifts => 'No saved shifts. You can add them from the Settings screen.';

  @override
  String get no_custom_shifts_short => 'No custom shifts';

  @override
  String get add_shift => 'Add shift';

  @override
  String get edit_shift => 'Edit shift';

  @override
  String delete_shift_confirm(String shift) {
    return 'Are you sure you want to delete the shift \"$shift\"? This action cannot be undone.';
  }

  @override
  String get shift_name => 'Shift name';

  @override
  String get shift_name_required => 'Name required';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get duration => 'Duration (hh:mm)';

  @override
  String get initial_place => 'Initial place';

  @override
  String get final_place => 'Final place';

  @override
  String get shift_tag => 'Shift tag';

  @override
  String get save_shift => 'Save';

  @override
  String get cancel_shift => 'Cancel';

  @override
  String get delete_shift => 'Delete';

  @override
  String get edit_duration => 'Edit shift duration';

  @override
  String get edit_overtime => 'Edit overtime';

  @override
  String get overtime => 'Overtime';

  @override
  String get overtime_gross => 'Overtime (gross without breaks)';

  @override
  String get overtime_net => 'Overtime (net of breaks)';

  @override
  String get no_breaks => 'No breaks recorded';

  @override
  String get breaks => 'Unpaid breaks';

  @override
  String get breaks_total => 'Total breaks';

  @override
  String get breaks_edit => 'Edit break';

  @override
  String get breaks_duration => 'Duration';

  @override
  String get add_break => 'Add break';

  @override
  String get delete_break => 'Delete break';

  @override
  String get delete_break_confirm => 'Are you sure you want to delete this break?';

  @override
  String get notes => 'Additional notes';

  @override
  String get clear_notes => 'Clear notes';

  @override
  String get select_number => 'Select a number';

  @override
  String get shift => 'Shift';

  @override
  String get select => 'Select';

  @override
  String get effective_shift => 'Effective shift';

  @override
  String get schedule => 'Schedule';

  @override
  String get place => 'Place';

  @override
  String get notes_short => 'Notes';

  @override
  String delete_day_confirm(String date) {
    return 'Are you sure you want to delete the data for the day $date?';
  }

  @override
  String get add_day => 'Add';

  @override
  String get no_day_data => 'No data found for this day, you can add some by pressing the Add button.';

  @override
  String get holidays_available => 'Available Holidays';

  @override
  String get holidays_left => 'Holidays Left';

  @override
  String get holidays_taken => 'Holidays Taken';

  @override
  String get rest => 'Days Off';

  @override
  String get missed_performance => 'Missed Performances';

  @override
  String get suppressed_holidays => 'Suppressed Holidays';

  @override
  String get work_suspension => 'Work Suspension';

  @override
  String get accessory_times => 'Accessory Times';

  @override
  String get paid_leave => 'Paid Leave';

  @override
  String get midweek_holidays => 'Midweek Holidays';

  @override
  String get illness => 'Sickness';

  @override
  String get law_104 => 'Law 104';

  @override
  String get parental_leave => 'Parental Leave';

  @override
  String get missed_performance_adequacy => 'Missed Performance Adjustments';

  @override
  String get holidays_available_plus_prev => 'Available Holidays: (+FR previous year)';

  @override
  String get holidays_left_label => 'Holidays Left:';

  @override
  String get holidays_taken_label => 'Holidays Taken:';

  @override
  String get rest_label => 'Days Off:';

  @override
  String get missed_performance_label => 'Missed Performances:';

  @override
  String get suppressed_holidays_label => 'Suppressed Holidays:';

  @override
  String get work_suspension_label => 'Work Suspension:';

  @override
  String get accessory_times_label => 'Accessory Times:';

  @override
  String get paid_leave_label => 'Paid Leave:';

  @override
  String get midweek_holidays_label => 'Midweek Holidays:';

  @override
  String get illness_label => 'Sickness:';

  @override
  String get law_104_label => 'Law 104:';

  @override
  String get parental_leave_label => 'Parental Leave:';

  @override
  String get missed_performance_adequacy_label => 'Missed Performance Adjustments:';

  @override
  String backup_exported(String path) {
    return 'Backup exported to $path';
  }

  @override
  String get backup_imported => 'Backup imported successfully!';

  @override
  String backup_export_error(String error) {
    return 'Error during export: $error';
  }

  @override
  String backup_import_error(String error) {
    return 'Error during import: $error';
  }

  @override
  String get reset_visibility_confirm => 'Do you want to restore the default visibility of the summary items?';

  @override
  String get reset_calendar_confirm => 'Are you sure you want to delete all daily shift data?';

  @override
  String get reset_summary_confirm => 'Do you want to restore the default visibility of summary items and reset all available holidays and missed performance adjustments for all years?';

  @override
  String get reset_custom_shifts_confirm => 'Are you sure you want to delete all custom shift data?';

  @override
  String get reset_app_confirm => 'Are you sure you want to delete all data and restart the app?';

  @override
  String get reset_visibility_done => 'Summary visibility settings restored.';

  @override
  String get reset_calendar_done => 'All daily shift data has been deleted.';

  @override
  String get reset_summary_done => 'Visibility settings and annual summary values restored.';

  @override
  String get reset_custom_shifts_done => 'All custom shift data has been deleted.';

  @override
  String get reset_app_done => 'All data has been deleted. The app will restart.';

  @override
  String get data_saved => 'Data saved';

  @override
  String get no_breaks_entered => 'No breaks entered';

  @override
  String get no_custom_shifts_found => 'No custom shifts found';

  @override
  String get no_day_found => 'No data found for this day';

  @override
  String get select_month => 'Select month';

  @override
  String get select_year_label => 'Select year';

  @override
  String get select_shift_label => 'Select shift';

  @override
  String get edit_shift_label => 'Edit shift';

  @override
  String get delete_shift_label => 'Delete shift';

  @override
  String get add_shift_label => 'Add shift';

  @override
  String get edit_break_label => 'Edit break';

  @override
  String get delete_break_label => 'Delete break';

  @override
  String get add_break_label => 'Add break';

  @override
  String get edit_notes_label => 'Edit notes';

  @override
  String get clear_notes_label => 'Clear notes';
}
