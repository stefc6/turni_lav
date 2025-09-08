// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get app_title => 'Turnos de Trabajo';

  @override
  String get calendar => 'Calendario';

  @override
  String get summary => 'Resumen';

  @override
  String get settings => 'Configuración';

  @override
  String get info => 'Información';

  @override
  String get menu => 'Menú';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get reset => 'Restablecer';

  @override
  String get reset_calendar => 'Restablecer Calendario';

  @override
  String get reset_summary => 'Restablecer Resumen';

  @override
  String get reset_custom_shifts => 'Restablecer Turnos Pers.';

  @override
  String get reset_app => 'Restablecer App';

  @override
  String get close => 'Cerrar';

  @override
  String get add => 'Añadir';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get restore => 'Restaurar';

  @override
  String get restore_2 => 'Restauración';

  @override
  String get backup_and_restore => 'Copia y Restauración';

  @override
  String get contacts => 'Contactos: \n';

  @override
  String get email => 'E-Mail:';

  @override
  String get debug_mode => 'Modo Depuración';

  @override
  String get theme => 'Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get customize_shifts => 'Personalizar turnos';

  @override
  String get shift_hours => 'Horas del turno';

  @override
  String get select_duration => 'Seleccionar duración del turno';

  @override
  String get exit_confirmation => 'Confirmar salida';

  @override
  String get do_you_want_to_exit => '¿Realmente quieres salir de la app?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get select_month_year => 'Seleccionar mes y año';

  @override
  String get select_year => 'Seleccionar Año';

  @override
  String get select_shift => 'Seleccionar turno';

  @override
  String get no_custom_shifts => 'No hay turnos guardados. Puedes añadirlos desde la pantalla de Configuración.';

  @override
  String get no_custom_shifts_short => 'No hay turnos personalizados';

  @override
  String get add_shift => 'Añadir turno';

  @override
  String get edit_shift => 'Editar turno';

  @override
  String delete_shift_confirm(String shift) {
    return '¿Seguro que quieres eliminar el turno \"$shift\"? Esta acción no se puede deshacer.';
  }

  @override
  String get shift_name => 'Nombre del turno';

  @override
  String get shift_name_required => 'Nombre obligatorio';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get duration => 'Duración (hh:mm)';

  @override
  String duration2(String duration2) {
    return 'Duración: $duration2';
  }

  @override
  String get initial_place => 'Lugar inicial';

  @override
  String get final_place => 'Lugar final';

  @override
  String get shift_duration_label => 'Duración del turno:';

  @override
  String get shift_tag => 'Etiqueta del turno';

  @override
  String get save_shift => 'Guardar';

  @override
  String get cancel_shift => 'Cancelar';

  @override
  String get delete_shift => 'Eliminar turno';

  @override
  String get edit_duration => 'Editar duración del turno';

  @override
  String get edit_overtime => 'Editar horas extra';

  @override
  String get edit_summary => 'Editar resumen';

  @override
  String get overtime => 'Horas extra';

  @override
  String get overtime_2 => 'Horas extra: ';

  @override
  String get overtime_gross => 'Horas extra (bruto sin pausas)';

  @override
  String get overtime_net => 'Horas extra (neto de pausas)';

  @override
  String get overtime_hours => 'Horas extra';

  @override
  String get overtime_hours_label => 'Horas extra:';

  @override
  String get overtime_calendar_hours => 'Horas extra:';

  @override
  String get no_breaks => 'No hay pausas registradas';

  @override
  String get breaks => 'Pausas no remuneradas';

  @override
  String get breaks_total => 'Total de pausas';

  @override
  String get breaks_total_label => 'Total de pausas:';

  @override
  String get breaks_label => 'Pausas:';

  @override
  String get breaks_edit => 'Editar pausa';

  @override
  String get breaks_duration => 'Duración';

  @override
  String get add_break => 'Añadir pausa';

  @override
  String get delete_break => 'Eliminar pausa';

  @override
  String get delete_confirm => 'Confirmar eliminación';

  @override
  String get delete_break_confirm => '¿Seguro que quieres eliminar esta pausa?';

  @override
  String get delete_day_data => 'Eliminar datos del día';

  @override
  String get notes => 'Notas adicionales';

  @override
  String get clear_notes => 'Borrar notas';

  @override
  String get select_number => 'Seleccionar un número';

  @override
  String get shift => 'Turno';

  @override
  String get select => 'Seleccionar';

  @override
  String get effective_shift => 'Turno efectivo';

  @override
  String get schedule => 'Horario';

  @override
  String get place => 'Lugar';

  @override
  String get overtime_breaks => 'Horas extra y Pausas: ';

  @override
  String get overtime_breaks2 => 'Horas extra y Pausas';

  @override
  String get overtime_breaks_info => 'Detalle de horas extra y pausas';

  @override
  String get notes_short => 'Notas';

  @override
  String delete_day_confirm(String date) {
    return '¿Seguro que quieres eliminar los datos del día $date?';
  }

  @override
  String get add_day => 'Añadir';

  @override
  String get no_day_data => 'No se encontraron datos para este día, puedes añadirlos presionando el botón Añadir.';

  @override
  String get holidays_available => 'Vacaciones disponibles';

  @override
  String get holidays_left => 'Vacaciones restantes';

  @override
  String get holidays_taken => 'Vacaciones tomadas';

  @override
  String get rest => 'Descansos';

  @override
  String get missed_performance => 'Rendimientos perdidos';

  @override
  String get suppressed_holidays => 'Festivos suprimidos';

  @override
  String get work_suspension => 'Suspensión laboral';

  @override
  String get accessory_times => 'Tiempos accesorios';

  @override
  String get paid_leave => 'Permiso retribuido';

  @override
  String get midweek_holidays => 'Festivos entre semana';

  @override
  String get illness => 'Enfermedad';

  @override
  String get law_104 => 'Ley 104';

  @override
  String get parental_leave => 'Permiso parental';

  @override
  String get missed_performance_adequacy => 'Ajustes de rendimiento perdido';

  @override
  String get holidays_available_plus_prev => 'Vacaciones disponibles: ';

  @override
  String get holidays_prev => '(+VD año anterior)';

  @override
  String get holidays_left_label => 'Vacaciones restantes:';

  @override
  String get holidays_taken_label => 'Vacaciones tomadas:';

  @override
  String get rest_label => 'Descansos:';

  @override
  String get missed_performance_label => 'Rendimientos perdidos:';

  @override
  String get suppressed_holidays_label => 'Festivos suprimidos:';

  @override
  String get work_suspension_label => 'Suspensión laboral:';

  @override
  String get accessory_times_label => 'Tiempos accesorios:';

  @override
  String get paid_leave_label => 'Permiso retribuido:';

  @override
  String get midweek_holidays_label => 'Festivos entre semana:';

  @override
  String get illness_label => 'Enfermedad:';

  @override
  String get law_104_label => 'Ley 104:';

  @override
  String get parental_leave_label => 'Permiso parental:';

  @override
  String get missed_performance_adequacy_label => 'Ajustes de rendimiento perdido:';

  @override
  String backup_exported(String path) {
    return 'Copia exportada a $path';
  }

  @override
  String get backup_imported => '¡Copia importada con éxito!';

  @override
  String backup_export_error(String error) {
    return 'Error durante la exportación: $error';
  }

  @override
  String backup_import_error(String error) {
    return 'Error durante la importación: $error';
  }

  @override
  String get export_cancelled => 'Exportación cancelada.';

  @override
  String get element_visibility => 'Visibilidad de elementos';

  @override
  String get where_to_save_backup => 'Elige dónde guardar la copia';

  @override
  String get reset_visibility_confirm => '¿Quieres restablecer la visibilidad predeterminada de los elementos del resumen y reiniciar todas las vacaciones disponibles y ajustes de rendimiento perdido para todos los años?';

  @override
  String get reset_calendar_confirm => '¿Seguro que quieres eliminar todos los datos de turnos por día?';

  @override
  String get reset_summary_confirm => '¿Quieres restablecer la visibilidad predeterminada de los elementos del resumen y reiniciar todas las vacaciones disponibles y ajustes de rendimiento perdido para todos los años?';

  @override
  String get reset_custom_shifts_confirm => '¿Seguro que quieres eliminar todos los datos de turnos personalizados?';

  @override
  String get reset_app_confirm => '¿Seguro que quieres eliminar todos los datos de la app?';

  @override
  String get reset_app_confirm2 => 'Esta operación eliminará TODOS los datos de la aplicación de forma irreversible. ¿Realmente quieres continuar?';

  @override
  String get reset_visibility_done => 'Configuración de visibilidad del resumen restablecida.';

  @override
  String get reset_calendar_done => 'Todos los datos de turnos por día han sido eliminados.';

  @override
  String get reset_summary_done => 'Configuración de visibilidad y valores anuales del resumen restablecidos.';

  @override
  String get reset_custom_shifts_done => 'Todos los datos de turnos personalizados han sido eliminados.';

  @override
  String get reset_app_done => 'Todos los datos han sido eliminados.';

  @override
  String get visibility_reset_confirm => 'Confirmar restablecimiento de visibilidad';

  @override
  String get confirm_reset => 'Confirmar restablecimiento';

  @override
  String get data_saved => 'Datos guardados';

  @override
  String get no_breaks_entered => 'No se han introducido pausas';

  @override
  String get no_custom_shifts_found => 'No hay turnos personalizados';

  @override
  String get no_day_found => 'No se encontraron datos para este día';

  @override
  String get select_month => 'Seleccionar mes';

  @override
  String get select_year_label => 'Seleccionar año';

  @override
  String get select_shift_label => 'Seleccionar turno';

  @override
  String get edit_shift_label => 'Editar turno';

  @override
  String get delete_shift_label => 'Eliminar turno';

  @override
  String get add_shift_label => 'Añadir turno';

  @override
  String get edit_break_label => 'Editar pausa';

  @override
  String get delete_break_label => 'Eliminar pausa';

  @override
  String get add_break_label => 'Añadir pausa';

  @override
  String get edit_notes_label => 'Editar notas';

  @override
  String get clear_notes_label => 'Borrar notas';

  @override
  String get attention => '¡Atención!';

  @override
  String get proceed => 'Proceder';

  @override
  String get value => 'Valor';

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mié';

  @override
  String get thursday => 'Jue';

  @override
  String get friday => 'Vie';

  @override
  String get saturday => 'Sáb';

  @override
  String get sunday => 'Dom';

  @override
  String get tag_holidays => 'Vacaciones';

  @override
  String get tag_rest => 'Descansos';

  @override
  String get tag_missed_performance => 'Rendimientos perdidos';

  @override
  String get tag_suppressed_holidays => 'Festivos suprimidos';

  @override
  String get tag_work_suspension => 'Suspensión laboral';

  @override
  String get tag_accessory_times => 'Tiempos accesorios';

  @override
  String get tag_paid_leave => 'Permiso retribuido';

  @override
  String get tag_midweek_holidays => 'Festivos entre semana';

  @override
  String get tag_illness => 'Enfermedad';

  @override
  String get tag_law_104 => 'Ley 104';

  @override
  String get tag_parental_leave => 'Permiso parental';

  @override
  String get tag_missed_performance_adequacy => 'Ajustes de rendimiento perdido';

  @override
  String get none => 'Ninguno';
}
