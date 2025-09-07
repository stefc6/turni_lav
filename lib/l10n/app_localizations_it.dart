// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get language => 'Lingua';

  @override
  String get app_title => 'Turni Lavoro';

  @override
  String get calendar => 'Calendario';

  @override
  String get summary => 'Riepilogo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get info => 'Informazioni';

  @override
  String get menu => 'Menù';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get reset => 'Ripristina';

  @override
  String get reset_calendar => 'Ripristina Calendario';

  @override
  String get reset_summary => 'Ripristina Riepilogo';

  @override
  String get reset_custom_shifts => 'Ripristina Turni Pers.';

  @override
  String get reset_app => 'Ripristina App';

  @override
  String get close => 'Chiudi';

  @override
  String get add => 'Aggiungi';

  @override
  String get edit => 'Modifica';

  @override
  String get delete => 'Elimina';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Ripristina';

  @override
  String get restore_2 => 'Ripristino';

  @override
  String get backup_and_restore => 'Backup e Ripristino';

  @override
  String get contacts => 'Contatti: \n';

  @override
  String get email => 'E-Mail:';

  @override
  String get debug_mode => 'Debug Mode';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get customize_shifts => 'Personalizza turni';

  @override
  String get shift_hours => 'Ore del turno';

  @override
  String get select_duration => 'Seleziona durata turno';

  @override
  String get exit_confirmation => 'Conferma uscita';

  @override
  String get do_you_want_to_exit => 'Vuoi davvero uscire dall\'app?';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get select_month_year => 'Seleziona mese e anno';

  @override
  String get select_year => 'Seleziona Anno';

  @override
  String get select_shift => 'Seleziona turno';

  @override
  String get no_custom_shifts => 'Nessun turno salvato. Puoi aggiungerli dalla schermata Impostazioni.';

  @override
  String get no_custom_shifts_short => 'Nessun turno personalizzato';

  @override
  String get add_shift => 'Aggiungi turno';

  @override
  String get edit_shift => 'Modifica turno';

  @override
  String delete_shift_confirm(String shift) {
    return 'Sei sicuro di voler eliminare il turno \"$shift\"? Questa azione non può essere annullata.';
  }

  @override
  String get shift_name => 'Nome turno';

  @override
  String get shift_name_required => 'Nome obbligatorio';

  @override
  String get start => 'Inizio';

  @override
  String get end => 'Fine';

  @override
  String get duration => 'Durata (hh:mm)';

  @override
  String duration2(String duration2) {
    return 'Durata: $duration2';
  }

  @override
  String get initial_place => 'Luogo iniziale';

  @override
  String get final_place => 'Luogo finale';

  @override
  String get shift_duration_label => 'Durata del turno:';

  @override
  String get shift_tag => 'Tag del turno';

  @override
  String get save_shift => 'Salva';

  @override
  String get cancel_shift => 'Annulla';

  @override
  String get delete_shift => 'Elimina turno';

  @override
  String get edit_duration => 'Modifica durata turno';

  @override
  String get edit_overtime => 'Modifica straordinario';

  @override
  String get edit_summary => 'Modifica riepilogo';

  @override
  String get overtime => 'Straordinario';

  @override
  String get overtime_2 => 'Straordinario: ';

  @override
  String get overtime_gross => 'Straordinario (lordo senza pause)';

  @override
  String get overtime_net => 'Straordinario (netto delle pause)';

  @override
  String get overtime_hours => 'Straordinari (Ore)';

  @override
  String get overtime_hours_label => 'Straordinari (Ore):';

  @override
  String get overtime_calendar_hours => 'Ore di straordinari:';

  @override
  String get no_breaks => 'Nessuna pausa registrata';

  @override
  String get breaks => 'Pause non retribuite';

  @override
  String get breaks_total => 'Totale pause';

  @override
  String get breaks_total_label => 'Totale pause:';

  @override
  String get breaks_label => 'Pause:';

  @override
  String get breaks_edit => 'Modifica pausa';

  @override
  String get breaks_duration => 'Durata';

  @override
  String get add_break => 'Aggiungi pausa';

  @override
  String get delete_break => 'Elimina pausa';

  @override
  String get delete_confirm => 'Conferma eliminazione';

  @override
  String get delete_break_confirm => 'Sei sicuro di voler eliminare questa pausa?';

  @override
  String get delete_day_data => 'Elimina dati giornata';

  @override
  String get notes => 'Note aggiuntive';

  @override
  String get clear_notes => 'Cancella note';

  @override
  String get select_number => 'Seleziona un numero';

  @override
  String get shift => 'Turno';

  @override
  String get select => 'Seleziona';

  @override
  String get effective_shift => 'Effettivo del turno';

  @override
  String get schedule => 'Orario';

  @override
  String get place => 'Luogo';

  @override
  String get overtime_breaks => 'Straordinari e Pause: ';

  @override
  String get overtime_breaks2 => 'Straordinari e Pause';

  @override
  String get overtime_breaks_info => 'Dettaglio straordinari e pause';

  @override
  String get notes_short => 'Note';

  @override
  String delete_day_confirm(String date) {
    return 'Sei sicuro di voler eliminare i dati per la giornata $date?';
  }

  @override
  String get add_day => 'Aggiungi';

  @override
  String get no_day_data => 'Nessun dato trovato per questa giornata, puoi aggiungerne premendo il tasto Aggiungi.';

  @override
  String get holidays_available => 'Ferie Disponibili';

  @override
  String get holidays_left => 'Ferie Rimaste';

  @override
  String get holidays_taken => 'Ferie Usufruite';

  @override
  String get rest => 'Riposi';

  @override
  String get missed_performance => 'Mancate Prestazioni';

  @override
  String get suppressed_holidays => 'Festività Sopresse';

  @override
  String get work_suspension => 'Sospensione Lavorativa';

  @override
  String get accessory_times => 'Tempi Accessori';

  @override
  String get paid_leave => 'Permesso Retribuito';

  @override
  String get midweek_holidays => 'Festività Infrasettimanali';

  @override
  String get illness => 'Malattia';

  @override
  String get law_104 => '104';

  @override
  String get parental_leave => 'Congedo Parentale';

  @override
  String get missed_performance_adequacy => 'Mancate Prestazioni di Adeguamento';

  @override
  String get holidays_available_plus_prev => 'Ferie Disponibili: ';

  @override
  String get holidays_prev => '(+FR anno precedente)';

  @override
  String get holidays_left_label => 'Ferie Rimaste:';

  @override
  String get holidays_taken_label => 'Ferie Usufruite:';

  @override
  String get rest_label => 'Riposi:';

  @override
  String get missed_performance_label => 'Mancate Prestazioni:';

  @override
  String get suppressed_holidays_label => 'Festività Sopresse:';

  @override
  String get work_suspension_label => 'Sospensione Lavorativa:';

  @override
  String get accessory_times_label => 'Tempi Accessori:';

  @override
  String get paid_leave_label => 'Permesso Retribuito:';

  @override
  String get midweek_holidays_label => 'Festività Infrasettimanali:';

  @override
  String get illness_label => 'Malattia:';

  @override
  String get law_104_label => '104:';

  @override
  String get parental_leave_label => 'Congedo Parentale:';

  @override
  String get missed_performance_adequacy_label => 'Mancate Prestazioni di Adeguamento:';

  @override
  String backup_exported(String path) {
    return 'Backup esportato in $path';
  }

  @override
  String get backup_imported => 'Backup importato con successo!';

  @override
  String backup_export_error(String error) {
    return 'Errore durante l\'esportazione: $error';
  }

  @override
  String backup_import_error(String error) {
    return 'Errore durante l\'importazione: $error';
  }

  @override
  String get export_cancelled => 'Esportazione annullata.';

  @override
  String get element_visibility => 'Visibilità elementi';

  @override
  String get where_to_save_backup => 'Scegli dove salvare il backup';

  @override
  String get reset_visibility_confirm => 'Vuoi ripristinare la visibilità predefinita degli elementi del riepilogo e azzerare tutte le ferie disponibili e le manc. prest. di adeguamento per tutti gli anni?';

  @override
  String get reset_calendar_confirm => 'Sei sicuro di voler cancellare tutti i dati dei turni per giornata?';

  @override
  String get reset_summary_confirm => 'Vuoi ripristinare la visibilità predefinita degli elementi del riepilogo e azzerare tutte le ferie disponibili e le manc. prest. di adeguamento per tutti gli anni?';

  @override
  String get reset_custom_shifts_confirm => 'Sei sicuro di voler cancellare tutti i dati dei turni personalizzati?';

  @override
  String get reset_app_confirm => 'Sei sicuro di voler cancellare tutti i dati dell\'app?';

  @override
  String get reset_app_confirm2 => 'Questa operazione cancellerà TUTTI i dati dell\'applicazione in modo irreversibile. Vuoi davvero procedere?';

  @override
  String get reset_visibility_done => 'Impostazioni di visibilità del riepilogo ripristinate.';

  @override
  String get reset_calendar_done => 'Tutti i dati dei turni per giornata sono stati cancellati.';

  @override
  String get reset_summary_done => 'Impostazioni di visibilità e valori annuali del riepilogo ripristinati.';

  @override
  String get reset_custom_shifts_done => 'Tutti i dati dei turni personalizzati sono stati cancellati.';

  @override
  String get reset_app_done => 'Tutti i dati sono stati cancellati. L\'app verrà riavviata.';

  @override
  String get visibility_reset_confirm => 'Conferma reset visibilità';

  @override
  String get confirm_reset => 'Conferma reset';

  @override
  String get data_saved => 'Dati salvati';

  @override
  String get no_breaks_entered => 'Nessuna pausa inserita';

  @override
  String get no_custom_shifts_found => 'Nessun turno personalizzato';

  @override
  String get no_day_found => 'Nessun dato trovato per questa giornata';

  @override
  String get select_month => 'Seleziona mese';

  @override
  String get select_year_label => 'Seleziona anno';

  @override
  String get select_shift_label => 'Seleziona turno';

  @override
  String get edit_shift_label => 'Modifica turno';

  @override
  String get delete_shift_label => 'Elimina turno';

  @override
  String get add_shift_label => 'Aggiungi turno';

  @override
  String get edit_break_label => 'Modifica pausa';

  @override
  String get delete_break_label => 'Elimina pausa';

  @override
  String get add_break_label => 'Aggiungi pausa';

  @override
  String get edit_notes_label => 'Modifica note';

  @override
  String get clear_notes_label => 'Cancella note';

  @override
  String get attention => 'Attenzione!';

  @override
  String get proceed => 'Procedi';

  @override
  String get value => 'Valore';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Gio';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sab';

  @override
  String get sunday => 'Dom';
}
