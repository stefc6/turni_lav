// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Langue';

  @override
  String get app_title => 'Horaires de Travail';

  @override
  String get calendar => 'Calendrier';

  @override
  String get summary => 'Résumé';

  @override
  String get settings => 'Paramètres';

  @override
  String get info => 'Informations';

  @override
  String get menu => 'Menu';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get reset_calendar => 'Réinitialiser le Calendrier';

  @override
  String get reset_summary => 'Réinitialiser le Résumé';

  @override
  String get reset_custom_shifts => 'Réinitialiser les Horaires Pers.';

  @override
  String get reset_app => 'Réinitialiser l\'App';

  @override
  String get close => 'Fermer';

  @override
  String get add => 'Ajouter';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get restore => 'Restaurer';

  @override
  String get restore_2 => 'Restauration';

  @override
  String get backup_and_restore => 'Sauvegarde et Restauration';

  @override
  String get contacts => 'Contacts : \n';

  @override
  String get email => 'E-Mail :';

  @override
  String get debug_mode => 'Mode Débogage';

  @override
  String get theme => 'Thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get customize_shifts => 'Personnaliser les horaires';

  @override
  String get shift_hours => 'Heures du poste';

  @override
  String get select_duration => 'Sélectionner la durée du poste';

  @override
  String get exit_confirmation => 'Confirmer la sortie';

  @override
  String get do_you_want_to_exit => 'Voulez-vous vraiment quitter l\'application ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get select_month_year => 'Sélectionner le mois et l\'année';

  @override
  String get select_year => 'Sélectionner l\'année';

  @override
  String get select_shift => 'Sélectionner le poste';

  @override
  String get no_custom_shifts => 'Aucun poste enregistré. Vous pouvez les ajouter depuis l\'écran Paramètres.';

  @override
  String get no_custom_shifts_short => 'Aucun poste personnalisé';

  @override
  String get add_shift => 'Ajouter un poste';

  @override
  String get edit_shift => 'Modifier le poste';

  @override
  String delete_shift_confirm(String shift) {
    return 'Êtes-vous sûr de vouloir supprimer le poste \"$shift\" ? Cette action est irréversible.';
  }

  @override
  String get shift_name => 'Nom du poste';

  @override
  String get shift_name_required => 'Nom obligatoire';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get duration => 'Durée (hh:mm)';

  @override
  String duration2(String duration2) {
    return 'Durée : $duration2';
  }

  @override
  String get initial_place => 'Lieu initial';

  @override
  String get final_place => 'Lieu final';

  @override
  String get shift_duration_label => 'Durée du poste :';

  @override
  String get shift_tag => 'Tag du poste';

  @override
  String get save_shift => 'Enregistrer';

  @override
  String get cancel_shift => 'Annuler';

  @override
  String get delete_shift => 'Supprimer le poste';

  @override
  String get edit_duration => 'Modifier la durée du poste';

  @override
  String get edit_overtime => 'Modifier les heures supplémentaires';

  @override
  String get edit_summary => 'Modifier le résumé';

  @override
  String get overtime => 'Heures supplémentaires';

  @override
  String get overtime_2 => 'Heures supplémentaires : ';

  @override
  String get overtime_gross => 'Heures supplémentaires (brut sans pauses)';

  @override
  String get overtime_net => 'Heures supplémentaires (net des pauses)';

  @override
  String get overtime_hours => 'Heures supplémentaires';

  @override
  String get overtime_hours_label => 'Heures supplémentaires :';

  @override
  String get overtime_calendar_hours => 'Heures supplémentaires :';

  @override
  String get no_breaks => 'Aucune pause enregistrée';

  @override
  String get breaks => 'Pauses non rémunérées';

  @override
  String get breaks_total => 'Total des pauses';

  @override
  String get breaks_total_label => 'Total des pauses :';

  @override
  String get breaks_label => 'Pauses :';

  @override
  String get breaks_edit => 'Modifier la pause';

  @override
  String get breaks_duration => 'Durée';

  @override
  String get add_break => 'Ajouter une pause';

  @override
  String get delete_break => 'Supprimer la pause';

  @override
  String get delete_confirm => 'Confirmer la suppression';

  @override
  String get delete_break_confirm => 'Êtes-vous sûr de vouloir supprimer cette pause ?';

  @override
  String get delete_day_data => 'Supprimer les données du jour';

  @override
  String get notes => 'Notes supplémentaires';

  @override
  String get clear_notes => 'Effacer les notes';

  @override
  String get select_number => 'Sélectionner un nombre';

  @override
  String get shift => 'Poste';

  @override
  String get select => 'Sélectionner';

  @override
  String get effective_shift => 'Poste effectif';

  @override
  String get schedule => 'Horaire';

  @override
  String get place => 'Lieu';

  @override
  String get overtime_breaks => 'Heures sup. et Pauses : ';

  @override
  String get overtime_breaks2 => 'Heures sup. et Pauses';

  @override
  String get overtime_breaks_info => 'Détail des heures sup. et pauses';

  @override
  String get notes_short => 'Notes';

  @override
  String delete_day_confirm(String date) {
    return 'Êtes-vous sûr de vouloir supprimer les données du jour $date ?';
  }

  @override
  String get add_day => 'Ajouter';

  @override
  String get no_day_data => 'Aucune donnée trouvée pour ce jour, vous pouvez en ajouter en appuyant sur le bouton Ajouter.';

  @override
  String get holidays_available => 'Congés disponibles';

  @override
  String get holidays_left => 'Congés restants';

  @override
  String get holidays_taken => 'Congés pris';

  @override
  String get rest => 'Repos';

  @override
  String get missed_performance => 'Prestations manquées';

  @override
  String get suppressed_holidays => 'Jours fériés supprimés';

  @override
  String get work_suspension => 'Suspension du travail';

  @override
  String get accessory_times => 'Temps accessoires';

  @override
  String get paid_leave => 'Congé payé';

  @override
  String get midweek_holidays => 'Jours fériés en semaine';

  @override
  String get illness => 'Maladie';

  @override
  String get law_104 => 'Loi 104';

  @override
  String get parental_leave => 'Congé parental';

  @override
  String get missed_performance_adequacy => 'Ajustements prestations manquées';

  @override
  String get holidays_available_plus_prev => 'Congés disponibles : ';

  @override
  String get holidays_prev => '(+CD année précédente)';

  @override
  String get holidays_left_label => 'Congés restants :';

  @override
  String get holidays_taken_label => 'Congés pris :';

  @override
  String get rest_label => 'Repos :';

  @override
  String get missed_performance_label => 'Prestations manquées :';

  @override
  String get suppressed_holidays_label => 'Jours fériés supprimés :';

  @override
  String get work_suspension_label => 'Suspension du travail :';

  @override
  String get accessory_times_label => 'Temps accessoires :';

  @override
  String get paid_leave_label => 'Congé payé :';

  @override
  String get midweek_holidays_label => 'Jours fériés en semaine :';

  @override
  String get illness_label => 'Maladie :';

  @override
  String get law_104_label => 'Loi 104 :';

  @override
  String get parental_leave_label => 'Congé parental :';

  @override
  String get missed_performance_adequacy_label => 'Ajustements prestations manquées :';

  @override
  String backup_exported(String path) {
    return 'Sauvegarde exportée vers $path';
  }

  @override
  String get backup_imported => 'Sauvegarde importée avec succès !';

  @override
  String backup_export_error(String error) {
    return 'Erreur lors de l\'exportation : $error';
  }

  @override
  String backup_import_error(String error) {
    return 'Erreur lors de l\'importation : $error';
  }

  @override
  String get export_cancelled => 'Exportation annulée.';

  @override
  String get element_visibility => 'Visibilité des éléments';

  @override
  String get where_to_save_backup => 'Choisissez où enregistrer la sauvegarde';

  @override
  String get reset_visibility_confirm => 'Voulez-vous réinitialiser la visibilité par défaut des éléments du résumé et remettre à zéro tous les congés disponibles et ajustements de prestations manquées pour toutes les années ?';

  @override
  String get reset_calendar_confirm => 'Êtes-vous sûr de vouloir supprimer toutes les données des postes par jour ?';

  @override
  String get reset_summary_confirm => 'Voulez-vous réinitialiser la visibilité par défaut des éléments du résumé et remettre à zéro tous les congés disponibles et ajustements de prestations manquées pour toutes les années ?';

  @override
  String get reset_custom_shifts_confirm => 'Êtes-vous sûr de vouloir supprimer toutes les données des postes personnalisés ?';

  @override
  String get reset_app_confirm => 'Êtes-vous sûr de vouloir supprimer toutes les données de l\'application ?';

  @override
  String get reset_app_confirm2 => 'Cette opération supprimera TOUS les données de l\'application de façon irréversible. Voulez-vous vraiment continuer ?';

  @override
  String get reset_visibility_done => 'Paramètres de visibilité du résumé réinitialisés.';

  @override
  String get reset_calendar_done => 'Toutes les données des postes par jour ont été supprimées.';

  @override
  String get reset_summary_done => 'Paramètres de visibilité et valeurs annuelles du résumé réinitialisés.';

  @override
  String get reset_custom_shifts_done => 'Toutes les données des postes personnalisés ont été supprimées.';

  @override
  String get reset_app_done => 'Toutes les données ont été supprimées.';

  @override
  String get visibility_reset_confirm => 'Confirmer la réinitialisation de la visibilité';

  @override
  String get confirm_reset => 'Confirmer la réinitialisation';

  @override
  String get data_saved => 'Données enregistrées';

  @override
  String get no_breaks_entered => 'Aucune pause saisie';

  @override
  String get no_custom_shifts_found => 'Aucun poste personnalisé';

  @override
  String get no_day_found => 'Aucune donnée trouvée pour ce jour';

  @override
  String get select_month => 'Sélectionner le mois';

  @override
  String get select_year_label => 'Sélectionner l\'année';

  @override
  String get select_shift_label => 'Sélectionner le poste';

  @override
  String get edit_shift_label => 'Modifier le poste';

  @override
  String get delete_shift_label => 'Supprimer le poste';

  @override
  String get add_shift_label => 'Ajouter le poste';

  @override
  String get edit_break_label => 'Modifier la pause';

  @override
  String get delete_break_label => 'Supprimer la pause';

  @override
  String get add_break_label => 'Ajouter la pause';

  @override
  String get edit_notes_label => 'Modifier les notes';

  @override
  String get clear_notes_label => 'Effacer les notes';

  @override
  String get attention => 'Attention !';

  @override
  String get proceed => 'Procéder';

  @override
  String get value => 'Valeur';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Jeu';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sam';

  @override
  String get sunday => 'Dim';

  @override
  String get tag_holidays => 'Congés';

  @override
  String get tag_rest => 'Repos';

  @override
  String get tag_missed_performance => 'Prestations manquées';

  @override
  String get tag_suppressed_holidays => 'Jours fériés supprimés';

  @override
  String get tag_work_suspension => 'Suspension du travail';

  @override
  String get tag_accessory_times => 'Temps accessoires';

  @override
  String get tag_paid_leave => 'Congé payé';

  @override
  String get tag_midweek_holidays => 'Jours fériés en semaine';

  @override
  String get tag_illness => 'Maladie';

  @override
  String get tag_law_104 => 'Loi 104';

  @override
  String get tag_parental_leave => 'Congé parental';

  @override
  String get tag_missed_performance_adequacy => 'Ajustements prestations manquées';

  @override
  String get none => 'Aucun';
}
