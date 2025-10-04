import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:turni_lav/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setSize(const Size(534, 950));
      await windowManager.setTitle('Turni Lavoro');
            // Ottieni info sullo schermo principale
      final display = await windowManager.getBounds();
      final screenHeight = display.size.height;

      // Imposta la posizione in base all'altezza dello schermo
      double topOffset;
      if (screenHeight >= 1080 && screenHeight < 1440) {
        topOffset = 50;
      } else if (screenHeight >= 1440 && screenHeight < 2160) {
        topOffset = 150;
      } else if (screenHeight >= 2160) {
        topOffset = 300;
      } else {
        topOffset = 20;
      }
      await windowManager.setPosition(Offset(100, topOffset));
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? mpaColor;

  const CustomColors({required this.mpaColor});

  @override
  CustomColors copyWith({Color? mpaColor}) {
    return CustomColors(mpaColor: mpaColor ?? this.mpaColor);
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(mpaColor: Color.lerp(mpaColor, other.mpaColor, t));
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
    Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void _changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1976D2),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF1976D2),
        secondary: const Color(0xFF90CAF9),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF1976D2),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const CustomColors(
          mpaColor: Color.fromARGB(226, 73, 73, 73),
        ), // esempio: rosso scuro
      ],
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF90CAF9),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF90CAF9),
        secondary: const Color(0xFF1976D2),
        surface: const Color(0xFF23272F),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF181A20),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF23272F),
        foregroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF90CAF9),
        foregroundColor: Colors.black,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF23272F),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF23272F)),
      extensions: <ThemeExtension<dynamic>>[
        const CustomColors(
          mpaColor: Color.fromARGB(134, 255, 255, 255),
        ), // esempio: rosso chiaro
      ],
    );

    return MaterialApp(
      title: "Turni Lavoro",
      debugShowCheckedModeBanner: true,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyHomePage(
        title: "Turni Lavoro",
        onThemeChanged: (mode) {
          setState(() {
            _themeMode = mode;
          });
        },
        onLanguageChanged: _changeLanguage,
        themeMode: _themeMode,
      ),
    );
  }
}

// Variabili globali
bool _exitDialogShown = true;
bool _debugMode = true; // Variabile globale per la modalità debug
// FIne Variabili globali

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    this.initialSection = DrawerSection.calendar,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.themeMode,
  });

  final String title;
  final DrawerSection initialSection;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Locale>? onLanguageChanged;
  final ThemeMode themeMode;

  static const List<String> tagList = [
    'Ferie',
    'Riposo',
    'Mancate prestazioni',
    'Festività sopresse',
    'Sospensione lavorativa',
    'Tempi accessori',
    'Permesso retribuito',
    'Festività infrasettimanali',
    'Malattia',
    '104',
    'Congedo parentale',
  ];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum DrawerSection { home, calendar, summary, settings, info }

class _MyHomePageState extends State<MyHomePage> {
  late DrawerSection _selectedSection;
  TimeOfDay? _inizio;
  TimeOfDay? _fine;
  Duration oreDiLavoroPredefinite = const Duration(hours: 7);
  DateTime _calendarFocusedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );
  DateTime _selectedDate = DateTime.now(); // <--- AGGIUNTA
  String? _selectedTurnoName;
  Duration? _durataTurnoSelezionato; // Nuova variabile di stato
  String? _selectedTag; // <--- AGGIUNTA: tag del turno selezionato
  // AGGIUNTA: Stato per anno selezionato in Riepilogo
  int _summaryFocusedYear = DateTime.now().year;
  int _riposoCount = 0; // Contatore turni Riposo
  bool _isCountingRiposo = false;
  // AGGIUNTA: Mappa per i contatori di tutti i tag
  Map<String, int> _tagCounts = {};
  // AGGIUNTA: Map per tenere traccia della visibilità degli elementi nel riepilogo
  final Map<String, bool> _elementVisibility = {
    'Straordinari (Ore)': true, // AGGIUNTA: visibilità straordinari
    'Ferie Disponibili': true,
    'Ferie Rimaste': true,
    'Ferie': true,
    'Riposo': true,
    'Mancate prestazioni': true,
    'Festività sopresse': true,
    'Sospensione lavorativa': true,
    'Tempi accessori': true,
    'Permesso retribuito': true,
    'Festività infrasettimanali': true,
    'Malattia': true,
    '104': true,
    'Congedo parentale': true,
    'Mancate Prestazioni di Adeguamento': true,
  };

  // Lista dei tag nell'ordine del menù a tendina, escluso 'Nessuno'
  static const List<String> _tagList = [
    'Ferie',
    'Riposo',
    'Mancate prestazioni',
    'Festività sopresse',
    'Sospensione lavorativa',
    'Tempi accessori',
    'Permesso retribuito',
    'Festività infrasettimanali',
    'Malattia',
    '104',
    'Congedo parentale',
    'Mancate Prestazioni di Adeguamento',
  ];

  String getTagLabel(BuildContext context, String tag) {
    switch (tag) {
      case 'Ferie':
        return AppLocalizations.of(context)!.tag_holidays;
      case 'Riposo':
        return AppLocalizations.of(context)!.tag_rest;
      case 'Mancate prestazioni':
        return AppLocalizations.of(context)!.tag_missed_performance;
      case 'Festività sopresse':
        return AppLocalizations.of(context)!.tag_suppressed_holidays;
      case 'Sospensione lavorativa':
        return AppLocalizations.of(context)!.tag_work_suspension;
      case 'Tempi accessori':
        return AppLocalizations.of(context)!.tag_accessory_times;
      case 'Permesso retribuito':
        return AppLocalizations.of(context)!.tag_paid_leave;
      case 'Festività infrasettimanali':
        return AppLocalizations.of(context)!.tag_midweek_holidays;
      case 'Malattia':
        return AppLocalizations.of(context)!.tag_illness;
      case '104':
        return AppLocalizations.of(context)!.tag_law_104;
      case 'Congedo parentale':
        return AppLocalizations.of(context)!.tag_parental_leave;
      case 'Mancate Prestazioni di Adeguamento':
        return AppLocalizations.of(context)!.tag_missed_performance_adequacy;
      default:
        return tag;
    }
  }

  void _onCalendarMonthChanged(int delta) {
    setState(() {
      _calendarFocusedMonth = DateTime(
        _calendarFocusedMonth.year,
        _calendarFocusedMonth.month + delta,
      );
    });
  }

  String get _mediaOrariaString {
    final durata = _durataTurnoSelezionato ?? oreDiLavoroPredefinite;
    final ore = durata.inHours;
    final minuti = durata.inMinutes % 60;
    String oreLabel = (ore == 1) ? 'ora' : 'ore';
    if (minuti == 0) {
      return '$ore $oreLabel';
    } else {
      return '$ore $oreLabel e $minuti minuti';
    }
  }

  // Calcolo straordinario come differenza tra durata effettiva e durata del turno selezionato (se presente), altrimenti oreDiLavoroPredefinite
  String get _straordinarioHHmm {
    if (_inizio == null || _fine == null) return '--:--';
    final inizioMin = _inizio!.hour * 60 + _inizio!.minute;
    final fineMin = _fine!.hour * 60 + _fine!.minute;
    int diff = fineMin - inizioMin;
    if (diff < 0) diff += 24 * 60;
    final durataLavorata = Duration(minutes: diff);
    final durataRiferimento = _durataTurnoSelezionato ?? oreDiLavoroPredefinite;
    final extra = durataLavorata - durataRiferimento;
    final sign = extra.inMinutes < 0 ? '-' : '';
    final absMinutes = extra.inMinutes.abs();
    final ore = absMinutes ~/ 60;
    final minuti = absMinutes % 60;
    return '$sign${ore.toString().padLeft(2, '0')}:${minuti.toString().padLeft(2, '0')}';
  }

  // Stato per la modifica straordinario
  String? _straordinarioEditValue;

  void _showStraordinarioEditDialog() {
    final current = _straordinarioEditValue ?? _straordinarioHHmm;
    final isNeg = current.startsWith('-');
    final time = current.replaceFirst('-', '');
    int ore = 0;
    int minuti = 0;
    if (time != '--:--') {
      final parts = time.split(':');
      ore = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
      minuti = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    }
    bool neg = isNeg;

    void updateStraordinario(int newOre, int newMinuti) {
      ore = newOre;
      minuti = newMinuti;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.edit_overtime,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: ore, minute: minuti),
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(
                                    context,
                                  ).copyWith(alwaysUse24HourFormat: true),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                updateStraordinario(picked.hour, picked.minute);
                              });
                            }
                          },
                          child: const Icon(Icons.timer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              neg = !neg;
                            });
                          },
                          child: const Icon(
                            Icons.exposure,
                          ), // +/- icona statica
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.overtime_2,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (neg)
                          const Text(
                            '-',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        Text(
                          '${ore.toString().padLeft(2, '0')}:${minuti.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _straordinarioEditValue =
                          '${neg ? '-' : ''}${ore.toString().padLeft(2, '0')}:${minuti.toString().padLeft(2, '0')}';
                    });
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _selectSection(DrawerSection section) {
    if (_selectedSection != section) {
      setState(() {
        _selectedSection = section;
        if (section == DrawerSection.summary) {
          _aggiornaRiposoCount(); // Aggiorna il contatore ogni volta che si entra in Riepilogo
          _loadElementVisibility(); // Carica la visibilità degli elementi
        }
      });
    }
    Navigator.of(context).pop(); // Chiude il drawer
  }

  String _getAppBarTitle() {
    switch (_selectedSection) {
      case DrawerSection.settings:
        return AppLocalizations.of(context)!.settings;
      case DrawerSection.info:
        return AppLocalizations.of(context)!.info;
      case DrawerSection.calendar:
        return '';
      case DrawerSection.summary:
        return AppLocalizations.of(context)!.summary;
      case DrawerSection.home:
        return widget.title;
    }
  }

  Widget _getBody() {
    switch (_selectedSection) {
      case DrawerSection.settings:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // --- INIZIO: Lingua ---
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      DropdownMenu<Locale>(
                        initialSelection: Localizations.localeOf(context),
                        dropdownMenuEntries: AppLocalizations.supportedLocales.map((locale) {
                          String label;
                          switch (locale.languageCode) {
                            case 'it':
                              label = 'Italiano';
                              break;
                            case 'en':
                              label = 'English';
                              break;
                            case 'es':
                              label = 'Español';
                              break;
                            case 'fr':
                              label = 'Français';
                              break;
                            default:
                              label = locale.languageCode;
                          }
                          return DropdownMenuEntry(value: locale, label: label);
                        }).toList(),
                        onSelected: (Locale? value) {
                          if (value != null) widget.onLanguageChanged!(value);
                        },
                        width: 120,
                        enableFilter: false,
                        enableSearch: false,
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        trailingIcon: const Icon(Icons.expand_more_rounded),
                        selectedTrailingIcon: const Icon(Icons.expand_less_rounded),
                      ),
                      // Blocca solo la parte di testo (80% a sinistra)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.6, // Copre solo la parte sinistra
                            child: IgnorePointer(
                              ignoring: false,
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // --- FINE: Lingua --
              const SizedBox(height: 26),
              // --- INIZIO: Tema ---
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.theme,
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      DropdownMenu<ThemeMode>(
                        initialSelection: widget.themeMode,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: ThemeMode.system, label: AppLocalizations.of(context)!.system),
                          DropdownMenuEntry(value: ThemeMode.light, label: AppLocalizations.of(context)!.light),
                          DropdownMenuEntry(value: ThemeMode.dark, label: AppLocalizations.of(context)!.dark),
                        ],
                        onSelected: (ThemeMode? value) {
                          if (value != null) widget.onThemeChanged(value);
                        },
                        width: 120,
                        enableFilter: false,
                        enableSearch: false,
                        inputDecorationTheme: InputDecorationTheme(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        trailingIcon: Icon(Icons.expand_more_rounded),
                        selectedTrailingIcon: Icon(Icons.expand_less_rounded),
                      ),
                      // Blocca solo la parte di testo (80% a sinistra)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.6, // Copre solo la parte sinistra
                            child: IgnorePointer(
                              ignoring: false,
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  
                ],
              ),
              // --- FINE: Tema ---
              const SizedBox(height: 26),
              // --- INIZIO: Personalizza turni ---
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    await showDialog(
                      context: context,
                      builder: (context) => _PersonalizzaTurniDialog(
                        oreDiLavoroPredefinite: oreDiLavoroPredefinite,
                        turniDisponibili: [],
                        onSelezionaTurno: (nome, dati) {
                          if (dati != null) {
                            final parts = dati.split('|');
                            setState(() {
                              _inizio =
                                  (parts.isNotEmpty && parts[0].isNotEmpty)
                                  ? _parseTimeOfDay(parts[0])
                                  : null;
                              _fine = (parts.length > 1 && parts[1].isNotEmpty)
                                  ? _parseTimeOfDay(parts[1])
                                  : null;
                              _luogoController.text = parts.length > 3
                                  ? parts[3]
                                  : '';
                              _luogoFinaleController.text = parts.length > 4
                                  ? parts[4]
                                  : '';
                            });
                          }
                        },
                      ),
                    );
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.customize_shifts,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // --- FINE: Personalizza turni ---
              const SizedBox(height: 32),
              // --- INIZIO: Ore del turno ---
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.shift_hours,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colors.black,
                    ),
                    onPressed: () async {
                      final now = TimeOfDay(
                        hour: oreDiLavoroPredefinite.inHours,
                        minute: oreDiLavoroPredefinite.inMinutes % 60,
                      );
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: now,
                        helpText: AppLocalizations.of(context)!.select_duration,
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(
                              context,
                            ).copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        final nuovaDurata = Duration(
                          hours: picked.hour,
                          minutes: picked.minute,
                        );
                        setState(() {
                          oreDiLavoroPredefinite = nuovaDurata;
                        });
                        await _saveOreDiLavoroPredefinite(nuovaDurata);
                      }
                    },
                    child: Text(
                      oreDiLavoroPredefinite.inMinutes % 60 == 0
                          ? '${oreDiLavoroPredefinite.inHours} h'
                          : '${oreDiLavoroPredefinite.inHours} h ${oreDiLavoroPredefinite.inMinutes % 60} min',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              // --- FINE: Ore del turno ---
              SizedBox(height: 38),
              // --- INIZIO: Conferma uscita ---
              if (Platform.isAndroid ||
                  Platform.isIOS ||
                  _debugMode == true) ...[
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.exit_confirmation,
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _exitDialogShown,
                      onChanged: (value) async {
                        setState(() {
                          _exitDialogShown = value;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('exitDialogShown', value);
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              // --- FINE: Conferma uscita ---
              const SizedBox(height: 32),
              ],
              // --- INIZIO: Backup ---
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => _BackupScreen(
                          onImportComplete: _loadElementVisibility,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.backup_and_restore,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // --- FINE: Backup ---
            ],
          ),
        );
      case DrawerSection.info:
        return Padding(
          padding: EdgeInsets.all(36),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.contacts,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.email, style: TextStyle(fontSize: 15)),
                  SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      text: 'supp.turnilavorativi@gmail.com',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'supp.turnilavorativi@gmail.com',
                          );
                          await launchUrl(emailLaunchUri);
                        },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Copyright (C) 2025  Stefano Lo Casto\nQuesto programma è un software libero: puoi ridistribuirlo e/o modificarlo secondo i termini della GNU General Public License pubblicata dalla Free Software Foundation, sia la versione 3 della licenza che una versione successiva. Questo programma è distribuito nella speranza che possa essere utile, ma SENZA ALCUNA GARANZIA; nemmeno la garanzia implicita di COMMERCIABILITÀ o IDONEITÀ PER UNO SCOPO PARTICOLARE. Per maggiori dettagli, consultare la GNU General Public License. È possibile trovare una copia della licenza all\'indirizzo <https://www.gnu.org/licenses/>.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              const SizedBox(height: 20),
              Text(
                'Copyright (C) 2025  Stefano Lo Casto\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You can find a copy of the license at <https://www.gnu.org/licenses/>. ',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              SizedBox(height: 120),
              Row(
                children: [
                  Text('Debug Mode'),
                  Spacer(),
                  Switch(
                    value: _debugMode,
                    onChanged: (value) {
                      setState(() {
                        _debugMode = value;
                      });
                    },
                  ),
              ],),
            ],
          ),),
        );
      case DrawerSection.summary:
        // AGGIUNTA: YearSwitcher sopra il contenuto della schermata Riepilogo
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 8,
                  right: 8,
                  bottom: 0,
                ),
                child: YearSwitcher(
                  focusedYear: _summaryFocusedYear,
                  onYearChanged: (delta) {
                    setState(() {
                      _summaryFocusedYear += delta;
                    });
                    _aggiornaRiposoCount(); // Aggiorna contatore quando cambia anno
                  },
                  onYearTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)!.select_year),
                          content: SizedBox(
                            width: 200,
                            height: 600,
                            child: YearPicker(
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2077),
                              selectedDate: DateTime(_summaryFocusedYear),
                              onChanged: (DateTime dateTime) {
                                Navigator.pop(context);
                                setState(() {
                                  _summaryFocusedYear = dateTime.year;
                                });
                                _aggiornaRiposoCount(); // Aggiorna contatore quando cambia anno
                              },                              
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context)!.close),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (_elementVisibility['Straordinari (Ore)'] ?? true) ...[
                const SizedBox(height: 16),
                // --- Straordinari (Ore) ---
                FutureBuilder<String>(
                  future: _calcolaSommaStraordinariAnno(_summaryFocusedYear),
                  builder: (context, snapshot) {
                    final somma = snapshot.data ?? '--:--';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.overtime_hours_label,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              somma,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              if (_elementVisibility['Ferie Disponibili'] ?? true) ...[
                const SizedBox(height: 16),
                FutureBuilder<int>(
                  future: _loadFerieDisponibiliAnno(_summaryFocusedYear),
                  builder: (context, snapshot) {
                    final ferieAnno = snapshot.data ?? 30;
                    return FutureBuilder<int>(
                      future: _calcolaFerieRimasteAnno(_summaryFocusedYear - 1),
                      builder: (context, snapshotPrec) {
                        final ferieRimastePrec = snapshotPrec.data ?? 0;
                        return FutureBuilder<int>(
                          future: _loadFerieUsufruiteAnno(_summaryFocusedYear - 1),
                          builder: (context, snapshotUsufruitePrec) {
                            final ferieUsufruitePrec = snapshotUsufruitePrec.data ?? 0;
                            final ferieDaMostrare = ferieUsufruitePrec > 0 ? ferieRimastePrec : 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Text(
                                    'FD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)!.holidays_available_plus_prev,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context).textTheme.bodyLarge?.color
                                            ),
                                          ),
                                          TextSpan(
                                            text: AppLocalizations.of(context)!.holidays_prev,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () async {
                                        final controller = TextEditingController(
                                          text: ferieAnno.toString(),
                                        );
                                        int tempValue = ferieAnno;
                                        int? nuovoValore = await showDialog<int>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(AppLocalizations.of(context)!.select_number),
                                              content: TextField(
                                                controller: controller,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: AppLocalizations.of(context)!.value,
                                                ),
                                                onChanged: (val) {
                                                  tempValue = int.tryParse(val) ?? tempValue;
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context), // Annulla
                                                  child: Text(AppLocalizations.of(context)!.cancel),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(
                                                    context,
                                                    tempValue,
                                                  ), // Conferma
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (nuovoValore != null) {
                                          await _saveFerieDisponibiliAnno(_summaryFocusedYear, nuovoValore);
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(38),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color:
                                                  Theme.of(context).brightness ==
                                                          Brightness.light
                                                      ? Colors.white
                                                      : Colors.black,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary, // Sfondo
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ), // Bordo arrotondato
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '$ferieAnno',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).brightness == Brightness.light
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' +$ferieDaMostrare',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).brightness == Brightness.light
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],

              
                // FERIE RIMASTE
                if (_elementVisibility['Ferie Rimaste'] ?? true) ...[
                  const SizedBox(height: 16),
                  FutureBuilder<int>(
                    future: _calcolaFerieRimasteAnno(_summaryFocusedYear),
                    builder: (context, snapshot) {
                      final ferieRimaste = snapshot.data ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Text(
                              'FR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.holidays_left_label,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Text(
                                '$ferieRimaste',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],

                // FERIE USUFRUITE
                if (_elementVisibility['Ferie'] ?? true) ...[
                  const SizedBox(height: 16),
                  FutureBuilder<int>(
                    future: _loadFerieUsufruiteAnno(_summaryFocusedYear),
                    builder: (context, snapshot) {
                      final ferieUsufruite = snapshot.data ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Text(
                              'FU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.holidays_taken_label,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Text(
                                '$ferieUsufruite',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              if (_elementVisibility['Riposo'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'RP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.rest_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '$_riposoCount', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Mancate prestazioni'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'MP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.missed_performance_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Mancate prestazioni'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Festività sopresse'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'FS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.suppressed_holidays_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Festività sopresse'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Sospensione lavorativa'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'SL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.work_suspension_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Sospensione lavorativa'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Tempi accessori'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'TA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.accessory_times_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Tempi accessori'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Permesso retribuito'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'PR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.paid_leave_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Permesso retribuito'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Festività infrasettimanali'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'FI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.midweek_holidays_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Festività infrasettimanali'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Malattia'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'MA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.illness_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Text(
                                '${_tagCounts['Malattia'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['104'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        '104',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.law_104_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Text(
                                '${_tagCounts['104'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              if (_elementVisibility['Congedo parentale'] ?? true) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Text(
                        'CH',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.parental_leave_label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _isCountingRiposo
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Sfondo
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Bordo arrotondato
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ), 
                              child: Text(
                                '${_tagCounts['Congedo parentale'] ?? 0}', // Sostituisci con il tuo testo/valore
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black, // Colore testo
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
              // MANCATE PRESTAZIONI DI ADEGUAMENTO
              if (_elementVisibility['Mancate Prestazioni di Adeguamento'] ?? true) ...[
                const SizedBox(height: 16),
                FutureBuilder<int>(
                  future: _loadMancPrestAdegAnno(_summaryFocusedYear),
                  builder: (context, snapshot) {
                    final mpaAnno = snapshot.data ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Text(
                            'MPA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.missed_performance_adequacy_label,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () async {
                                final controller = TextEditingController(
                                  text: mpaAnno.toString(),
                                );
                                int tempValue = mpaAnno;
                                int? nuovoValore = await showDialog<int>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.select_number),
                                      content: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context)!.value,
                                        ),
                                        onChanged: (val) {
                                          tempValue = int.tryParse(val) ?? tempValue;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context), // Annulla
                                          child: Text(AppLocalizations.of(context)!.cancel),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            context,
                                            tempValue,
                                          ), // Conferma
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (nuovoValore != null) {
                                  await _saveMancPrestAdegAnno(_summaryFocusedYear, nuovoValore);
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(38),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              '$mpaAnno',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              SizedBox(height: 120,)
            ],
          ),
        );
      case DrawerSection.calendar:
        // Sposto il MonthSwitcher qui, sotto la AppBar
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 8,
                right: 8,
                bottom: 0,
              ),
              child: MonthSwitcher(
                focusedMonth: _calendarFocusedMonth,
                onMonthChanged: _onCalendarMonthChanged,
                onMonthTap: () async {
                  int tempYear = _calendarFocusedMonth.year;
                  int tempMonth = _calendarFocusedMonth.month;
                
                  final result = await showDialog<DateTime>(
                    context: context,
                    builder: (dialogContext) {
                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.select_month_year),
                          content: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.chevron_left),
                                      onPressed: () {
                                        if (tempYear > 2000) setState(() => tempYear--);
                                      },
                                    ),
                                    Text(
                                      tempYear.toString(),
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.chevron_right),
                                      onPressed: () {
                                        if (tempYear < 2100) setState(() => tempYear++);
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: List.generate(12, (i) {
                                    final m = i + 1;
                                    return GestureDetector(
                                      onTap: () => setState(() => tempMonth = m),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: tempMonth == m
                                              ? Theme.of(context).colorScheme.primary.withAlpha((255 * 0.18).round())
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: tempMonth == m
                                                ? Theme.of(context).colorScheme.primary
                                                : Colors.grey.shade400,
                                            width: tempMonth == m ? 2 : 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateFormat.MMM(Localizations.localeOf(context).toString()).format(DateTime(2000, m)),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: tempMonth == m
                                                    ? Theme.of(context).colorScheme.primary
                                                    : Theme.of(context).textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, DateTime(tempYear, tempMonth));
                              },
                              child: Text(AppLocalizations.of(context)!.confirm),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                
                  if (result != null) {
                    setState(() {
                      _calendarFocusedMonth = result;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _CalendarScreen(
                  focusedMonth: _calendarFocusedMonth,
                  onModificaGiornata: (giorno, dati) async {
                    await _apriModificaGiornata(giorno, dati);
                  },
                ),
              ),
            ),
          ],
        );
      case DrawerSection.home:
        // Nuovo layout richiesto
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- INIZIO: Selezione turno ---
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.shift,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            textStyle: const TextStyle(fontSize: 17),
                          ),
                          onPressed: () async {
                            final result =
                                await showDialog<Map<String, String>?>(
                                  context: context,
                                  builder: (context) => SelezionaTurnoDialog(),
                                );
                            if (result != null && result['nome'] != null) {
                              final dati = result['dati'] ?? '';
                              final parts = dati.split('|');
                              setState(() {
                                _selectedTurnoName = result['nome'];
                                _inizio =
                                    (parts.isNotEmpty && parts[0].isNotEmpty)
                                    ? _parseTimeOfDay(parts[0])
                                    : null;
                                _fine =
                                    (parts.length > 1 && parts[1].isNotEmpty)
                                    ? _parseTimeOfDay(parts[1])
                                    : null;
                                // Durata
                                if (parts.length > 2 && parts[2].isNotEmpty) {
                                  final durataParts = parts[2].split(':');
                                  if (durataParts.length == 2) {
                                    final ore =
                                        int.tryParse(durataParts[0]) ?? 0;
                                    final min =
                                        int.tryParse(durataParts[1]) ?? 0;
                                    _durataTurnoSelezionato = Duration(
                                      hours: ore,
                                      minutes: min,
                                    );
                                  } else {
                                    _durataTurnoSelezionato = null;
                                  }
                                } else {
                                  _durataTurnoSelezionato = null;
                                }
                                _luogoController.text = parts.length > 3
                                    ? parts[3]
                                    : '';
                                _luogoFinaleController.text = parts.length > 4
                                    ? parts[4]
                                    : '';
                                // --- AGGIUNTA: estrai il tag dal campo 6 del turno predefinito ---
                                _selectedTag = parts.length > 5
                                    ? parts[5]
                                    : null;
                                _straordinarioEditValue = null;
                              });
                            }
                          },
                          child: Text(
                            _selectedTurnoName?.isNotEmpty == true
                                ? _selectedTurnoName!
                                : AppLocalizations.of(context)!.select,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.start, style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(AppLocalizations.of(context)!.end, style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerBox(
                          isStart: true,
                          initialTime: _inizio,
                            onTimeChanged: (t) => setState(() {
                            _inizio = t;
                            _straordinarioEditValue = null;
                          }),
                          textColor:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _TimePickerBox(
                          isStart: false,
                          initialTime: _fine,
                            onTimeChanged: (t) => setState(() {
                            _fine = t;
                            _straordinarioEditValue = null; // resetta la modifica manuale
                          }),
                          textColor:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Rimossa la label sopra
                  TextField(
                    controller: _luogoController,
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.initial_place,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 16),
                  // Rimossa la label sopra
                  TextField(
                    controller: _luogoFinaleController,
                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.final_place,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: (_) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.shift_duration_label, // Modificato da 'Media oraria'
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _mediaOrariaString,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit),
                        tooltip: AppLocalizations.of(context)!.edit_duration,
                        onPressed: () async {
                          final now = TimeOfDay(
                            hour: _durataTurnoSelezionato?.inHours ?? oreDiLavoroPredefinite.inHours,
                            minute: _durataTurnoSelezionato != null
                              ? _durataTurnoSelezionato!.inMinutes % 60 
                              : oreDiLavoroPredefinite.inMinutes % 60,
                          );
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: now,
                            helpText: AppLocalizations.of(context)!.select_duration,
                            builder: (context, child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _durataTurnoSelezionato = Duration(hours: picked.hour, minutes: picked.minute);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.overtime_2,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        // Mostra sempre il valore calcolato se non c'è una modifica manuale
                        (_straordinarioEditValue == null ||
                                _straordinarioEditValue!.isEmpty)
                            ? _straordinarioHHmm
                            : _straordinarioEditValue!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: AppLocalizations.of(context)!.edit_overtime,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showStraordinarioEditDialog();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // --- INIZIO: Pause non retribuite ---
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return _PauseDialog(
                            pauseList: _pauseNonRetribuite,
                            onUpdate: (newList) {
                              setState(() {
                                _pauseNonRetribuite = newList;
                              });
                            },
                            totalePause: calcolaTotalePause(),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.breaks,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          calcolaTotalePause(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  // --- FINE: Pause non retribuite ---
                  Stack(
                    children: [
                      TextField(
                        controller: _noteController,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.notes,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          tooltip: AppLocalizations.of(context)!.clear_notes,
                          onPressed: () {
                            _noteController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      // RIMOSSO: case DrawerSection.calendar
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
    _loadOreDiLavoroPredefinite();
    _aggiornaRiposoCount();
    _loadElementVisibility(); // Carica le preferenze di visibilità all'avvio
    _loadExitDialogPref();
  }

  Future<void> _loadOreDiLavoroPredefinite() async {
    final prefs = await SharedPreferences.getInstance();
    final minuti = prefs.getInt('oreDiLavoroPredefinite') ?? 420; // default 7h
    setState(() {
      oreDiLavoroPredefinite = Duration(minutes: minuti);
    });
  }

  Future<void> _saveOreDiLavoroPredefinite(Duration durata) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('oreDiLavoroPredefinite', durata.inMinutes);
    // RIMOSSO: _refreshCalendarScreen();
  }

  Future<int> _loadFerieDisponibiliAnno(int year) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('ferieDisponibili_$year') ?? 30;
  }
  
  Future<void> _saveFerieDisponibiliAnno(int year, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ferieDisponibili_$year', value);
  }

  Future<int> _loadFerieUsufruiteAnno(int year) async {
    // Conta i giorni con tag 'Ferie' per l'anno
    int count = 0;
    for (int m = 1; m <= 12; m++) {
      final lastDay = DateTime(year, m + 1, 0).day;
      for (int d = 1; d <= lastDay; d++) {
        final key = '${year.toString().padLeft(4, '0')}-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
        final raw = await DayDataStorage.loadDayData(key);
        if (raw != null && raw.isNotEmpty) {
          final parts = raw.split('|');
          if (parts.length > 9) {
            final tag = parts[9].trim();
            if (tag.toLowerCase() == 'ferie') count++;
          }
        }
      }
    }
    return count;
  }
  
  Future<int> _loadMancPrestAdegAnno(int year) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mancPrestAdeg_$year') ?? 0;
  }
  
  Future<void> _saveMancPrestAdegAnno(int year, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mancPrestAdeg_$year', value);
  }
  
  Future<int> _calcolaFerieRimasteAnno(int year) async {
    final ferieDisp = await _loadFerieDisponibiliAnno(year);
    final ferieUsufr = await _loadFerieUsufruiteAnno(year);
  
    int ferieRimastePrec = 0;
    if (year > 2000) {
      final ferieUsufruitePrec = await _loadFerieUsufruiteAnno(year - 1);
      if (ferieUsufruitePrec > 0) {
        ferieRimastePrec = await _calcolaFerieRimasteAnno(year - 1);
      }
    }
  
    return ferieDisp + ferieRimastePrec - ferieUsufr;
  }

  Future<void> _loadExitDialogPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _exitDialogShown = prefs.getBool('exitDialogShown') ?? true;
    });
  }

  // Salva i dati della giornata (chiave fissa per la Home)
  Future<void> _salvaDatiGiornata() async {
    // Imposta valori di default se vuoti
    final inizioStr = _inizio != null ? _inizio!.format(context) : '00:00';
    final fineStr = _fine != null ? _fine!.format(context) : '00:00';
    final dataKey =
        '${_selectedDate.year.toString().padLeft(4, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final turno = _selectedTurnoName ?? '';
    final durataStr = _durataTurnoSelezionato != null
      ? '${_durataTurnoSelezionato!.inHours.toString().padLeft(2, '0')}:${(_durataTurnoSelezionato!.inMinutes % 60).toString().padLeft(2, '0')}'
      : '${oreDiLavoroPredefinite.inHours.toString().padLeft(2, '0')}:${(oreDiLavoroPredefinite.inMinutes % 60).toString().padLeft(2, '0')}';
    final straordinarioRaw = (_straordinarioEditValue != null && _straordinarioEditValue!.isNotEmpty)
      ? _straordinarioEditValue!
      : _straordinarioHHmm;
    final straordinarioStr = (straordinarioRaw.isEmpty || straordinarioRaw == '--:--') ? '00:00' : straordinarioRaw;
    final pauseList = _pauseNonRetribuite.map((p) {
      final diff = p['inizio'] != null && p['fine'] != null
          ? _calcolaDiff(p['inizio'], p['fine'])
          : '--:--';
      return '${p['inizio'] ?? ''}-${p['fine'] ?? ''};$diff';
    }).toList();
    final pauseStr = 'Tause[${pauseList.join(';')}]';
    final sommaPause = calcolaTotalePause();
    final pauseField = '$pauseStr;$sommaPause';
    final luogoIniziale = _luogoController.text;
    final luogoFinale = _luogoFinaleController.text;
    final note = _noteController.text;
    final tag = _selectedTag ?? '';
    final data = [
      turno,
      inizioStr,
      fineStr,
      durataStr,
      straordinarioStr,
      pauseField,
      luogoIniziale,
      luogoFinale,
      note,
      tag, // campo tag
    ].join('|');
    await DayDataStorage.saveDayData(dataKey, data);
    setState(() {
      _selectedSection = DrawerSection.calendar;
    });
    // Mostra il messaggio nella schermata Calendario dopo il rebuild
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.data_saved)));
    });
  }

  // Nuova struttura per le pause non retribuite
  List<Map<String, String?>> _pauseNonRetribuite = [];

  // Calcola la differenza tra due orari (formato HH:mm)
  String _calcolaDiff(String? inizio, String? fine) {
    if (inizio == null || fine == null || inizio.isEmpty || fine.isEmpty) {
      return '--:--';
    }
    final inizioParts = inizio.split(':');
    final fineParts = fine.split(':');
    if (inizioParts.length != 2 || fineParts.length != 2) return '--:--';
    final h1 = int.tryParse(inizioParts[0]) ?? 0;
    final m1 = int.tryParse(inizioParts[1]) ?? 0;
    final h2 = int.tryParse(fineParts[0]) ?? 0;
    final m2 = int.tryParse(fineParts[1]) ?? 0;
    int diff = (h2 * 60 + m2) - (h1 * 60 + m1);
    if (diff < 0) diff += 24 * 60;
    final ore = diff ~/ 60;
    final min = diff % 60;
    return '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  final TextEditingController _luogoController = TextEditingController();
  final TextEditingController _luogoFinaleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _luogoController.dispose();
    _luogoFinaleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        View.of(context).platformDispatcher.platformBrightness ==
        Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ThemeData().colorScheme.primary,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (_selectedSection != DrawerSection.calendar) {
          setState(() {
            _selectedSection = DrawerSection.calendar;
          });
        } else {
          if (_exitDialogShown == true) {
          final shouldExit = await showDialog<bool>(
            
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.exit_confirmation),
              content: Text(AppLocalizations.of(context)!.do_you_want_to_exit),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(AppLocalizations.of(context)!.no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ],
            ),
          );
          if (shouldExit == true) {
            SystemNavigator.pop(); // Chiude l'app
          }} else if (_exitDialogShown == false) {
            SystemNavigator.pop(); // Chiude l'app
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.black,
          leading: _selectedSection == DrawerSection.home
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedSection = DrawerSection.calendar;
                    });
                  },
                )
              : Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
          centerTitle: true,
          title: _selectedSection == DrawerSection.calendar
              ? Text(
                  AppLocalizations.of(context)!.calendar,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : (_selectedSection == DrawerSection.home
                    ? Text(
                        // Mostra la data selezionata
                        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        _getAppBarTitle(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
          actions: _selectedSection == DrawerSection.summary
              ? [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: AppLocalizations.of(context)!.edit_summary,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            title: Text(
                              AppLocalizations.of(context)!.element_visibility,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  // Prima voce: Straordinari (Ore)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)!.overtime_hours,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Switch(
                                          value:
                                              _elementVisibility['Straordinari (Ore)'] ??
                                              true,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              _elementVisibility['Straordinari (Ore)'] =
                                                  value;
                                            });
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            await prefs.setBool(
                                              'visibility_Straordinari (Ore)',
                                              value,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ), // Padding
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)!.holidays_available,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Switch(
                                          value:
                                              _elementVisibility['Ferie Disponibili'] ??
                                              true,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              _elementVisibility['Ferie Disponibili'] =
                                                  value;
                                            });
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            await prefs.setBool(
                                              'visibility_Riposi Totali',
                                              value,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            AppLocalizations.of(context)!.holidays_left,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Switch(
                                          value:
                                              _elementVisibility['Ferie Rimaste'] ??
                                              true,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              _elementVisibility['Ferie Rimaste'] =
                                                  value;
                                            });
                                            final prefs =
                                                await SharedPreferences.getInstance();
                                            await prefs.setBool(
                                              'visibility_Riposi Disponibili',
                                              value,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  for (final tag in _tagList)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              getTagLabel(context, tag),
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Switch(
                                            value:
                                                _elementVisibility[tag] ?? true,
                                            onChanged: (bool value) async {
                                              setState(() {
                                                _elementVisibility[tag] = value;
                                              });
                                              final prefs =
                                                  await SharedPreferences.getInstance();
                                              await prefs.setBool(
                                                'visibility_$tag',
                                                value,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await resetVisibilitaRiepilogo(context);
                                      await _loadElementVisibility();
                                      if (!context.mounted) return;
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(AppLocalizations.of(context)!.restore),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(AppLocalizations.of(context)!.close),
                                  ),
                                ]
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ]
              : null,
        ),
        drawer: _selectedSection == DrawerSection.home
            ? null
            : Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // DrawerHeader -> Container per altezza personalizzata
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, bottom: 16),
                          child: Text(
                            AppLocalizations.of(context)!.menu,
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        AppLocalizations.of(context)!.calendar,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      selected: _selectedSection == DrawerSection.calendar,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectSection(DrawerSection.calendar);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: Text(
                        AppLocalizations.of(context)!.summary,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      selected: _selectedSection == DrawerSection.summary,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectSection(DrawerSection.summary);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(
                        AppLocalizations.of(context)!.settings,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      selected: _selectedSection == DrawerSection.settings,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectSection(DrawerSection.settings);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(
                        AppLocalizations.of(context)!.info,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      selected: _selectedSection == DrawerSection.info,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _selectSection(DrawerSection.info);
                      },
                    ),
                  ],
                ),
              ),
        body: _getBody(),
        floatingActionButton: _selectedSection == DrawerSection.home
            ? FloatingActionButton.extended(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _salvaDatiGiornata();
                },
                icon: const Icon(Icons.save),
                label: Text(AppLocalizations.of(context)!.save),
              )
            : null,
      ),
    );
  }

  // Funzione di utilità per parsing orario hh:mm
  TimeOfDay? _parseTimeOfDay(String s) {
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  // Calcola la somma delle durate delle pause non retribuite
  String calcolaTotalePause() {
    int totaleMinuti = 0;
    for (final p in _pauseNonRetribuite) {
      final diff = _calcolaDiff(p['inizio'], p['fine']);
      if (diff != '--:--') {
        final parts = diff.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          totaleMinuti += h * 60 + m;
        }
      }
    }
    final ore = totaleMinuti ~/ 60;
    final min = totaleMinuti % 60;
    if (totaleMinuti == 0) return '';
    return '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  // AGGIUNTA: metodo per aprire la giornata in modifica dalla Home
  Future<void> _apriModificaGiornata(
    DateTime giorno,
    Map<String, String> dati,
  ) async {
    setState(() {
      _selectedSection = DrawerSection.home;
      _selectedDate = giorno;
      _selectedTurnoName = dati['turno'] ?? '';
      _inizio = (dati['inizio'] != null && dati['inizio']!.isNotEmpty)
          ? _parseTimeOfDay(dati['inizio']!)
          : null;
      _fine = (dati['fine'] != null && dati['fine']!.isNotEmpty)
          ? _parseTimeOfDay(dati['fine']!)
          : null;
      if (dati['durata'] != null && dati['durata']!.isNotEmpty) {
        final durataParts = dati['durata']!.split(':');
        if (durataParts.length == 2) {
          final ore = int.tryParse(durataParts[0]) ?? 0;
          final min = int.tryParse(durataParts[1]) ?? 0;
          _durataTurnoSelezionato = Duration(hours: ore, minutes: min);
        }
      } else {
        _durataTurnoSelezionato = null;
      }
      _straordinarioEditValue = dati['straordinario'];
      _luogoController.text = dati['luogoIniziale'] ?? '';
      _luogoFinaleController.text = dati['luogoFinale'] ?? '';
      _noteController.text = dati['note'] ?? '';
      _pauseNonRetribuite = [];
      // Parsing delle pause non retribuite
      final pauseField = dati['pauseField'] ?? '';
      if (pauseField.startsWith('Tause[')) {
        final endIdx = pauseField.indexOf(']');
        if (endIdx != -1) {
          final inside = pauseField.substring(6, endIdx);
          if (inside.isNotEmpty) {
            final items = inside.split(';').where((e) => e.contains('-'));
            for (final item in items) {
              final parts = item.split('-');
              String inizio = parts.isNotEmpty ? parts[0] : '';
              String fine = parts.length > 1 ? parts[1] : '';
              // Calcola durata
              String durata = '--:--';
              if (inizio.isNotEmpty && fine.isNotEmpty) {
                final inizioParts = inizio.split(':');
                final fineParts = fine.split(':');
                if (inizioParts.length == 2 && fineParts.length == 2) {
                  final h1 = int.tryParse(inizioParts[0]) ?? 0;
                  final m1 = int.tryParse(inizioParts[1]) ?? 0;
                  final h2 = int.tryParse(fineParts[0]) ?? 0;
                  final m2 = int.tryParse(fineParts[1]) ?? 0;
                  int diff = (h2 * 60 + m2) - (h1 * 60 + m1);
                  if (diff < 0) diff += 24 * 60;
                  final ore = diff ~/ 60;
                  final min = diff % 60;
                  durata =
                      '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
                }
              }
              _pauseNonRetribuite.add({
                'inizio': inizio,
                'fine': fine,
                'durata': durata,
              });
            }
          }
        }
      } else {
        _pauseNonRetribuite = [];
      }
      // --- AGGIUNTA: carica il tag se presente (decimo campo) ---
      _selectedTag = dati.containsKey('tag') ? dati['tag'] : null;
    });
  }

  // Calcola la somma degli straordinari dell'anno selezionato
  Future<String> _calcolaSommaStraordinariAnno(int year) async {
    int totaleMinuti = 0;
    for (int m = 1; m <= 12; m++) {
      final lastDay = DateTime(year, m + 1, 0).day;
      for (int d = 1; d <= lastDay; d++) {
        final key =
            '${year.toString().padLeft(4, '0')}-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
        final raw = await DayDataStorage.loadDayData(key);
        if (raw != null && raw.isNotEmpty) {
          final parts = raw.split('|');
          if (parts.length > 4 && parts[4].isNotEmpty) {
            // Straordinario
            final s = parts[4].trim();
            final neg = s.startsWith('-');
            final time = s.replaceFirst('-', '');
            final tParts = time.split(':');
            int straordinarioMin = 0;
            if (tParts.length == 2) {
              final h = int.tryParse(tParts[0]) ?? 0;
              final m = int.tryParse(tParts[1]) ?? 0;
              straordinarioMin = h * 60 + m;
              if (neg) straordinarioMin = -straordinarioMin;
            }
            // Pause (campo 5: pauseField)
            int pauseMin = 0;
            if (parts.length > 5 && parts[5].isNotEmpty) {
              final pauseField = parts[5];
              if (pauseField.startsWith('Tause[')) {
                final idx = pauseField.indexOf(']');
                if (idx != -1 && pauseField.length > idx + 2) {
                  final afterBracket = pauseField.substring(idx + 1);
                  if (afterBracket.startsWith(';')) {
                    final sommaPause = afterBracket.substring(1).trim();
                    if (sommaPause.isNotEmpty && sommaPause != '--:--') {
                      final pauseParts = sommaPause.split(':');
                      if (pauseParts.length == 2) {
                        final h = int.tryParse(pauseParts[0]) ?? 0;
                        final m = int.tryParse(pauseParts[1]) ?? 0;
                        pauseMin = h * 60 + m;
                      }
                    }
                  }
                }
              }
            }
            // Netto
            totaleMinuti += (straordinarioMin - pauseMin);
          }
        }
      }
    }
    final sign = totaleMinuti < 0 ? '-' : '';
    final absMin = totaleMinuti.abs();
    final ore = absMin ~/ 60;
    final min = absMin % 60;
    return '$sign${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  Future<void> _aggiornaRiposoCount() async {
    setState(() {
      _isCountingRiposo = true;
    });
    int count = 0;
    // AGGIUNTA: inizializza i contatori dei tag
    Map<String, int> tagCounts = {for (var tag in _tagList) tag: 0};
    for (int m = 1; m <= 12; m++) {
      final lastDay = DateTime(_summaryFocusedYear, m + 1, 0).day;
      for (int d = 1; d <= lastDay; d++) {
        final key =
            '${_summaryFocusedYear.toString().padLeft(4, '0')}-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
        final raw = await DayDataStorage.loadDayData(key);
        if (raw != null && raw.isNotEmpty) {
          final parts = raw.split('|');
          if (parts.length > 9) {
            final tag = parts[9].trim();
            if (tag.toLowerCase() == 'riposo') count++;
            // Conta solo se il tag è nella lista e non è 'Nessuno'
            if (_tagList.contains(tag)) {
              tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
            }
          }
        }
      }
    }
    setState(() {
      _riposoCount = count;
      _tagCounts = tagCounts;
      _isCountingRiposo = false;
    });
  }

  // Carica le preferenze di visibilità
  Future<void> _loadElementVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    for (final tag in [
      'Straordinari (Ore)',
      'Ferie Disponibili',
      'Ferie Rimaste',
      ..._tagList,
    ]) {
      _elementVisibility[tag] = prefs.getBool('visibility_$tag') ?? true;
    }
    setState(() {}); // Aggiorna l'interfaccia con le preferenze caricate
  }
}

// Classe per gestire il salvataggio e recupero dati per ogni giornata
class DayDataStorage {
  static Future<void> saveDayData(String date, String data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.isEmpty) {
      await prefs.remove('daydata_$date');
    } else {
      await prefs.setString('daydata_$date', data);
    }
  }

  static Future<String?> loadDayData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('daydata_$date');
  }

  /// Carica i dati della giornata e li restituisce come mappa dei campi.
  /// Supporta sia il nuovo formato (8 campi) sia il vecchio (meno campi).
  /// Campi: turno, inizio, fine, durata, straordinario, luogoIniziale, luogoFinale, note
  static Future<Map<String, String>?> loadDayDataParsed(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('daydata_$date');
    if (raw == null) return null;
    final parts = raw.split('|');
    // Nuovo formato: 9 campi
    if (parts.length >= 9) {
      return {
        'turno': parts[0],
        'inizio': parts[1],
        'fine': parts[2],
        'durata': parts[3],
        'straordinario': parts[4],
        'pauseField': parts[5],
        'luogoIniziale': parts[6],
        'luogoFinale': parts[7],
        'note': parts[8],
        'tag': parts[9],
      };
    }
    // Vecchio formato: meno campi, riempi i mancanti con stringa vuota
    return {
      'turno': parts.isNotEmpty ? parts[0] : '',
      'inizio': parts.length > 1 ? parts[1] : '',
      'fine': parts.length > 2 ? parts[2] : '',
      'durata': parts.length > 3 ? parts[3] : '',
      'straordinario': parts.length > 4 ? parts[4] : '',
      'pauseField': parts.length > 5 ? parts[5] : '',
      'luogoIniziale': parts.length > 6 ? parts[6] : '',
      'luogoFinale': parts.length > 7 ? parts[7] : '',
      'note': parts.length > 8 ? parts[8] : '',
      'tag': parts.length > 9 ? parts[9] : '',
    };
  }
}

// Widget per la selezione orario
class _TimePickerBox extends StatefulWidget {
  final bool isStart;
  final ValueChanged<TimeOfDay?>? onTimeChanged;
  final TimeOfDay? initialTime;
  final Color textColor;
  const _TimePickerBox({
    required this.isStart,
    this.onTimeChanged,
    this.initialTime,
    required this.textColor,
  });

  @override
  State<_TimePickerBox> createState() => _TimePickerBoxState();
}

class _TimePickerBoxState extends State<_TimePickerBox> {
  TimeOfDay? _selectedTime;

  @override
  void didUpdateWidget(covariant _TimePickerBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      setState(() {
        _selectedTime = widget.initialTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? widget.initialTime ?? now,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      if (widget.onTimeChanged != null) {
        widget.onTimeChanged!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: widget.textColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: _pickTime,
      child: Text(
        _selectedTime != null ? _selectedTime!.format(context) : '--:--',
        style: TextStyle(
          color: widget.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Widget per la selezione mese nella AppBar
class MonthSwitcher extends StatelessWidget {
  final DateTime focusedMonth;
  final void Function(int delta) onMonthChanged;
  final VoidCallback? onMonthTap; //Callback per il tap sul mese
  const MonthSwitcher({
    required this.focusedMonth,
    required this.onMonthChanged,
    this.onMonthTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => onMonthChanged(-1),
        ),
        const SizedBox(width: 4),
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onMonthTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Text(
              DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(focusedMonth),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => onMonthChanged(1),
        ),
      ],
    );
  }
}

// Widget per la selezione anno nella schermata Riepilogo
class YearSwitcher extends StatelessWidget {
  final int focusedYear;
  final void Function(int delta) onYearChanged;
  final VoidCallback? onYearTap; //Callback per il tap sull'anno

  const YearSwitcher({
    super.key,
    required this.focusedYear,
    required this.onYearChanged,
    this.onYearTap, // Callback per il tap sull'anno
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => onYearChanged(-1),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onYearTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                focusedYear.toString(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: () => onYearChanged(1),
        ),
      ],
    );
  }
}

// --- INIZIO: Dialog Personalizza Turni ---
class _PersonalizzaTurniDialog extends StatefulWidget {
  final Duration oreDiLavoroPredefinite;
  final List<String> turniDisponibili;
  final void Function(String nomeTurno, String? dati)? onSelezionaTurno;
  const _PersonalizzaTurniDialog({
    required this.oreDiLavoroPredefinite,
    required this.turniDisponibili,
    this.onSelezionaTurno,
  });

  @override
  State<_PersonalizzaTurniDialog> createState() =>
      _PersonalizzaTurniDialogState();
}

class _PersonalizzaTurniDialogState extends State<_PersonalizzaTurniDialog> {
  Map<String, String?> _datiTurni = {};
  bool _loading = true;
  List<String> _nomiTurni = [];

  @override
  void initState() {
    super.initState();
    _caricaTurni();
  }

  Future<void> _caricaTurni() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final turniKeys = allKeys
        .where((k) => k.startsWith('turno_custom_'))
        .toList();
    final nomi = turniKeys
        .map((k) => k.replaceFirst('turno_custom_', ''))
        .toList();
    nomi.sort((a, b) {
      final reg = RegExp(r'^(\\d+)');
      final matchA = reg.firstMatch(a);
      final matchB = reg.firstMatch(b);
      if (matchA != null && matchB != null) {
        return int.parse(
          matchA.group(1)!,
        ).compareTo(int.parse(matchB.group(1)!));
      }
      if (matchA != null) return -1;
      if (matchB != null) return 1;
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    Map<String, String?> dati = {};
    for (final nome in nomi) {
      dati[nome] = prefs.getString('turno_custom_$nome');
    }
    setState(() {
      _datiTurni = dati;
      _nomiTurni = nomi;
      _loading = false;
    });
  }

  void apriModificaTurno({String? nome, String? dati}) async {
    final result = await showDialog(
      context: context,
      builder: (context) => _ModificaTurnoDialog(
        nomeTurno: nome,
        datiSalvati: dati,
        oreDiLavoroPredefinite: widget.oreDiLavoroPredefinite,
      ),
    );
    if (result == true) {
      _caricaTurni(); // Aggiorna lista solo se è stato salvato o eliminato
    }
  }

  @override
  Widget build(BuildContext context) {
    // Blocca il ridimensionamento della dialog quando si apre la tastiera
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: MediaQuery.removeViewInsets(
        removeBottom: true,
        context: context,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = MediaQuery.of(context).size.height * 0.7;
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400, maxHeight: maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.customize_shifts,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: AppLocalizations.of(context)!.add_shift,
                          onPressed: () => apriModificaTurno(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : _nomiTurni.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(AppLocalizations.of(context)!.no_custom_shifts_short),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _nomiTurni.length,
                            itemBuilder: (context, idx) {
                              final nome = _nomiTurni[idx];
                              return ListTile(
                                title: Text(nome),
                                trailing: const Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  apriModificaTurno(
                                    nome: nome,
                                    dati: _datiTurni[nome],
                                  );
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 8),
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.close),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
// --- FINE: Dialog Personalizza Turni ---

// --- INIZIO: Dialog Modifica/Aggiungi Turno Personalizzato ---
class _ModificaTurnoDialog extends StatefulWidget {
  final String? nomeTurno;
  final String? datiSalvati;
  final Duration oreDiLavoroPredefinite;
  const _ModificaTurnoDialog({
    this.nomeTurno,
    this.datiSalvati,
    required this.oreDiLavoroPredefinite,
  });

  @override
  State<_ModificaTurnoDialog> createState() => _ModificaTurnoDialogState();
}

class _ModificaTurnoDialogState extends State<_ModificaTurnoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  TimeOfDay? _inizio;
  TimeOfDay? _fine;
  late TextEditingController _durataController;
  late TextEditingController _luogoInizialeController;
  late TextEditingController _luogoFinaleController;
  String _selectedTag = 'Nessuno';
  static const List<String> _tagOptions = [
    'Nessuno',
    'Ferie',
    'Riposo',
    'Mancate prestazioni',
    'Festività sopresse',
    'Sospensione lavorativa',
    'Tempi accessori',
    'Permesso retribuito',
    'Festività infrasettimanali',
    'Malattia',
    '104',
    'Congedo parentale',
  ];

  String getTagLabel(BuildContext context, String tag) {
    switch (tag) {
      case 'Ferie':
        return AppLocalizations.of(context)!.tag_holidays;
      case 'Riposo':
        return AppLocalizations.of(context)!.tag_rest;
      case 'Mancate prestazioni':
        return AppLocalizations.of(context)!.tag_missed_performance;
      case 'Festività sopresse':
        return AppLocalizations.of(context)!.tag_suppressed_holidays;
      case 'Sospensione lavorativa':
        return AppLocalizations.of(context)!.tag_work_suspension;
      case 'Tempi accessori':
        return AppLocalizations.of(context)!.tag_accessory_times;
      case 'Permesso retribuito':
        return AppLocalizations.of(context)!.tag_paid_leave;
      case 'Festività infrasettimanali':
        return AppLocalizations.of(context)!.tag_midweek_holidays;
      case 'Malattia':
        return AppLocalizations.of(context)!.tag_illness;
      case '104':
        return AppLocalizations.of(context)!.tag_law_104;
      case 'Congedo parentale':
        return AppLocalizations.of(context)!.tag_parental_leave;
      case 'Mancate Prestazioni di Adeguamento':
        return AppLocalizations.of(context)!.tag_missed_performance_adequacy;
      default:
        return tag;
    }
  }

  @override
  void initState() {
    super.initState();
    final dati = widget.datiSalvati?.split('|') ?? [];
    _nomeController = TextEditingController(text: widget.nomeTurno ?? '');
    _inizio = (dati.isNotEmpty && dati[0].isNotEmpty)
        ? _parseTimeOfDay(dati[0])
        : null;
    _fine = (dati.length > 1 && dati[1].isNotEmpty)
        ? _parseTimeOfDay(dati[1])
        : null;
    _durataController = TextEditingController(
      text: (dati.length > 2 && dati[2].isNotEmpty)
          ? dati[2]
          : _durataStringFromDuration(widget.oreDiLavoroPredefinite),
    );
    _luogoInizialeController = TextEditingController(
      text: dati.length > 3 ? dati[3] : '',
    );
    _luogoFinaleController = TextEditingController(
      text: dati.length > 4 ? dati[4] : '',
    );
    // Carica il tag se presente (sesto campo), altrimenti 'Nessuno'
    _selectedTag = dati.length > 5 ? dati[5] : 'Nessuno';
  }

  TimeOfDay? _parseTimeOfDay(String s) {
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _durataStringFromDuration(Duration d) {
    final ore = d.inHours;
    final minuti = d.inMinutes % 60;
    if (minuti == 0) return '${ore.toString().padLeft(2, '0')}:00';
    return '${ore.toString().padLeft(2, '0')}:${minuti.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime(bool isStart) async {
    final now = isStart
        ? (_inizio ?? TimeOfDay.now())
        : (_fine ?? TimeOfDay.now());
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _inizio = picked;
        } else {
          _fine = picked;
        }
      });
    }
  }

  Future<void> _salva() async {
    if (!_formKey.currentState!.validate()) return;
    final nome = _nomeController.text.trim();
    // Imposta valori di default se vuoti
    final inizio = _inizio != null ? _inizio!.format(context) : ' ';
    final fine = _fine != null ? _fine!.format(context) : ' ';
    final durata = _durataController.text.trim().isNotEmpty
        ? _durataController.text.trim()
        : _durataStringFromDuration(widget.oreDiLavoroPredefinite);
    String durataNorm = durata;
    final durataRegExp = RegExp(r'^(\d+)\s*ore$');
    final match = durataRegExp.firstMatch(durata);
    if (match != null) {
      final ore = int.tryParse(match.group(1) ?? '0') ?? 0;
      durataNorm = '${ore.toString().padLeft(2, '0')}:00';
    }
    final luogoIniziale = _luogoInizialeController.text.trim();
    final luogoFinale = _luogoFinaleController.text.trim();
    final tag = _selectedTag;
    final data = [
      inizio,
      fine,
      durataNorm,
      luogoIniziale,
      luogoFinale,
      tag,
    ].join('|');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('turno_custom_$nome', data);
    if (!mounted) return;
    Navigator.pop(
      context,
      true,
    ); // Restituisci true per segnalare il salvataggio
  }

  Future<void> _eliminaTurno() async {
    if (widget.nomeTurno == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('turno_custom_${widget.nomeTurno}');
    if (!mounted) return;
    Navigator.pop(context, true); // chiudi e segnala che serve refresh
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _durataController.dispose();
    _luogoInizialeController.dispose();
    _luogoFinaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
        child: SizedBox(
          height: 510, // aumentato di 5px rispetto a 400
          child: Stack(
            children: [
              // Contenuto scrollabile
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.edit_shift,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (widget.nomeTurno != null)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: AppLocalizations.of(context)!.delete_shift,
                              onPressed: () async {
                                final conferma = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.delete_confirm),
                                    content: Text(
                                      AppLocalizations.of(context)!.delete_shift_confirm(widget.nomeTurno!),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(AppLocalizations.of(context)!.delete),
                                      ),
                                    ],
                                  ),
                                );
                                if (conferma == true) {
                                  await _eliminaTurno();
                                }
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.shift_name,
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? AppLocalizations.of(context)!.shift_name_required
                            : null,
                        enabled: widget.nomeTurno == null,
                        showCursor: true,
                        readOnly: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickTime(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _inizio != null
                                      ? _inizio!.format(context)
                                      : '--:--',
                                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickTime(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _fine != null
                                      ? _fine!.format(context)
                                      : '--:--',
                                  style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.duration,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                                fontSize: 15, 
                                fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () async {
                                final now = TimeOfDay(
                                  hour: _durataController.text.isNotEmpty
                                      ? int.tryParse(_durataController.text.split(':')[0]) ?? 0
                                      : 0,
                                  minute: _durataController.text.isNotEmpty
                                      ? int.tryParse(_durataController.text.split(':')[1]) ?? 0
                                      : 0,
                                );
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: now,
                                  helpText: AppLocalizations.of(context)!.select_duration,
                                  builder: (context, child) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  _durataController.text =
                                      '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                  setState(() {});
                                }
                              },
                              child: Text(
                                _durataController.text.isNotEmpty
                                    ? _durataController.text
                                    : '--:--',
                                style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                                fontSize: 18, 
                                fontWeight: FontWeight.bold),
                              
                              ),
                            ),
                          )
                        ],
                      ),),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _luogoInizialeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.initial_place,
                          border: OutlineInputBorder(),
                        ),
                        showCursor: true,
                        readOnly: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _luogoFinaleController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.final_place,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.shift_tag,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setStateDropdown) =>
                            DropdownButtonFormField<String>(
                              initialValue: _selectedTag,
                              items: _tagOptions
                                  .map(
                                    (tag) => DropdownMenuItem(
                                      value: tag,
                                      child: Text(
                                        tag == 'Nessuno'
                                          ? AppLocalizations.of(context)!.none
                                          : getTagLabel(context, tag),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedTag = val ?? 'Nessuno';
                                });
                                setStateDropdown(() {});
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? TextButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFCCCCCC),
                                        width: 1.5,
                                      ),
                                    )
                                  : null,
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _salva,
                              style:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFCCCCCC),
                                        width: 1.5,
                                      ),
                                    )
                                  : null,
                              child: Text(AppLocalizations.of(context)!.save),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),),
      ),
    );
  }
}

// --- FINE: Dialog Modifica/Aggiungi Turno Personalizzato ---
// --- DIALOG MODIFICA PAUSA ---
class _ModificaPausaDialog extends StatefulWidget {
  const _ModificaPausaDialog();

  @override
  State<_ModificaPausaDialog> createState() => _ModificaPausaDialogState();
}

class _ModificaPausaDialogState extends State<_ModificaPausaDialog> {
  String? _inizio;
  String? _fine;

  String _calcolaDiff() {
    if (_inizio == null ||
        _fine == null ||
        _inizio!.isEmpty ||
        _fine!.isEmpty) {
      return '--:--';
    }
    final inizioParts = _inizio!.split(':');
    final fineParts = _fine!.split(':');
    if (inizioParts.length != 2 || fineParts.length != 2) return '--:--';
    final h1 = int.tryParse(inizioParts[0]) ?? 0;
    final m1 = int.tryParse(inizioParts[1]) ?? 0;
    final h2 = int.tryParse(fineParts[0]) ?? 0;
    final m2 = int.tryParse(fineParts[1]) ?? 0;
    int diff = (h2 * 60 + m2) - (h1 * 60 + m1);
    if (diff < 0) diff += 24 * 60;
    final ore = diff ~/ 60;
    final min = diff % 60;
    return '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime(bool isStart) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked != null) {
      setState(() {
        final formatted =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        if (isStart) {
          _inizio = formatted;
        } else {
          _fine = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 550,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.breaks_edit,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: AppLocalizations.of(context)!.delete_break,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(true),
                    child: Text(_inizio ?? 'Inizio'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(false),
                    child: Text(_fine ?? 'Fine'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.duration2(_calcolaDiff()),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: Theme.of(context).brightness == Brightness.dark
                      ? TextButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_inizio != null &&
                        _fine != null &&
                        _inizio!.isNotEmpty &&
                        _fine!.isNotEmpty) {
                      Navigator.pop(context, {
                        'inizio': _inizio,
                        'fine': _fine,
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: Theme.of(context).brightness == Brightness.dark
                      ? ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ),
          ],
        ),
      ),),
    );
  }
}

// --- DIALOG PAUSE NON RETRIBUITE ---
class _PauseDialog extends StatefulWidget {
  final List<Map<String, String?>> pauseList;
  final void Function(List<Map<String, String?>>) onUpdate;
  final String totalePause;
  const _PauseDialog({
    required this.pauseList,
    required this.onUpdate,
    required this.totalePause,
  });

  @override
  State<_PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends State<_PauseDialog> {
  late List<Map<String, String?>> _pauseList;

  @override
  void initState() {
    super.initState();
    _pauseList = List<Map<String, String?>>.from(widget.pauseList);
  }

  void _addPausa(Map<String, String?> pausa) {
    final inizio = pausa['inizio'];
    final fine = pausa['fine'];
    String durata = '--:--';
    if (inizio != null && fine != null && inizio.isNotEmpty && fine.isNotEmpty) {
      durata = _PauseDialogState._calcolaDiffStatic(inizio, fine);
    }
    setState(() {
      _pauseList.add({
        'inizio': inizio,
        'fine': fine,
        'durata': durata,
      });
    });
    widget.onUpdate(_pauseList);
  }
  
  void _updatePausa(int idx, Map<String, String?> pausa) {
    final inizio = pausa['inizio'];
    final fine = pausa['fine'];
    String durata = '--:--';
    if (inizio != null && fine != null && inizio.isNotEmpty && fine.isNotEmpty) {
      durata = _PauseDialogState._calcolaDiffStatic(inizio, fine);
    }
    setState(() {
      _pauseList[idx] = {
        'inizio': inizio,
        'fine': fine,
        'durata': durata,
      };
    });
    widget.onUpdate(_pauseList);
  }

  void _removePausa(int idx) {
    setState(() {
      _pauseList.removeAt(idx);
    });
    widget.onUpdate(_pauseList);
  }

  String get _totalePause => _calcolaTotalePause(_pauseList);

  static String _calcolaTotalePause(List<Map<String, String?>> pauseList) {
    int totaleMinuti = 0;
    for (final p in pauseList) {
      final diff = _calcolaDiffStatic(p['inizio'], p['fine']);
      if (diff != '--:--') {
        final parts = diff.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          totaleMinuti += h * 60 + m;
        }
      }
    }
    final ore = totaleMinuti ~/ 60;
    final min = totaleMinuti % 60;
    if (totaleMinuti == 0) return '';
    return '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  static String _calcolaDiffStatic(String? inizio, String? fine) {
    if (inizio == null || fine == null || inizio.isEmpty || fine.isEmpty) {
      return '--:--';
    }
    final inizioParts = inizio.split(':');
    final fineParts = fine.split(':');
    if (inizioParts.length != 2 || fineParts.length != 2) return '--:--';
    final h1 = int.tryParse(inizioParts[0]) ?? 0;
    final m1 = int.tryParse(inizioParts[1]) ?? 0;
    final h2 = int.tryParse(fineParts[0]) ?? 0;
    final m2 = int.tryParse(fineParts[1]) ?? 0;
    int diff = (h2 * 60 + m2) - (h1 * 60 + m1);
    if (diff < 0) diff += 24 * 60;
    final ore = diff ~/ 60;
    final min = diff % 60;
    return '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 550, // Limite larghezza come le altre finestre
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.breaks_label,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                if (_totalePause.isNotEmpty)
                  Text(_totalePause, style: TextStyle(color: Colors.red)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: AppLocalizations.of(context)!.add_shift,
                  onPressed: () async {
                    final result = await showDialog<Map<String, String?>>(
                      context: context,
                      builder: (context) => _ModificaPausaDialog(),
                    );
                    if (result != null) {
                      _addPausa({
                        'inizio': result['inizio'],
                        'fine': result['fine'],
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_pauseList.isEmpty)
              Center(child: Text(AppLocalizations.of(context)!.no_breaks_entered))
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _pauseList.length,
                  itemBuilder: (context, idx) {
                    final p = _pauseList[idx];
                    return ListTile(
                      title: Text('${p['inizio']} - ${p['fine']}'),
                      subtitle: Text('Durata: ${p['durata']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result =
                                  await showDialog<Map<String, String?>>(
                                    context: context,
                                    builder: (context) =>
                                        _ModificaPausaDialog(),
                                  );
                              if (result != null) {
                                _updatePausa(idx, {
                                  'inizio': result['inizio'],
                                  'fine': result['fine'],
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removePausa(idx),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ),
          ],
        ),
      ),)
    );
  }
}

// --- INIZIO: Schermata Calendario ---
class _CalendarScreen extends StatefulWidget {
  final DateTime focusedMonth;
  final void Function(DateTime, Map<String, String>)? onModificaGiornata;
  const _CalendarScreen({required this.focusedMonth, this.onModificaGiornata});

  @override
  State<_CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<_CalendarScreen> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = widget.focusedMonth;
  }

  @override
  void didUpdateWidget(covariant _CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusedMonth != oldWidget.focusedMonth) {
      setState(() {
        _focusedMonth = widget.focusedMonth;
      });
    }
  }

  List<DateTime> _getDaysForMonth(DateTime? month) {
    if (month == null) {
      final now = DateTime.now();
      month = DateTime(now.year, now.month, 1);
    }
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    // Calcola il primo lunedì da mostrare
    int startWeekday = firstDayOfMonth.weekday;
    final firstToShow =
        firstDayOfMonth.subtract(Duration(days: startWeekday - 1));

    // Calcola l'ultimo giorno da mostrare (domenica dell'ultima settimana)
    int endWeekday = lastDayOfMonth.weekday;
    final lastToShow = endWeekday == DateTime.sunday
        ? lastDayOfMonth
        : lastDayOfMonth.add(Duration(days: DateTime.sunday - endWeekday));

    // Calcola il numero totale di giorni da mostrare in modo sicuro rispetto al DST
    final totalDays = DateTime.utc(lastToShow.year, lastToShow.month, lastToShow.day)
            .difference(DateTime.utc(firstToShow.year, firstToShow.month, firstToShow.day))
            .inDays +
        1;
        
    // Genera la lista dei giorni incrementando il giorno, non aggiungendo una durata
    return List.generate(totalDays, (i) => DateTime(firstToShow.year, firstToShow.month, firstToShow.day + i));
  }

  // Carica i dati dei turni per tutte le giornate del mese visualizzato
  Future<Map<String, String>> _loadTurniPerMese(DateTime month) async {
    final Map<String, String> result = {};
    final lastDay = DateTime(month.year, month.month + 1, 0);
    for (int d = 1; d <= lastDay.day; d++) {
      final key =
          '${month.year}-${month.month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
      final raw = await DayDataStorage.loadDayData(key);
      if (raw != null && raw.isNotEmpty) {
        final parts = raw.split('|');
        if (parts.isNotEmpty && parts[0].isNotEmpty) {
          result[key] = parts[0]; // Nome turno
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysForMonth(_focusedMonth);
    final today = DateTime.now();
    return FutureBuilder<Map<String, String>>(
      future: _loadTurniPerMese(_focusedMonth),
      builder: (context, snapshot) {
        final List<String> giorniSettimana = [
          AppLocalizations.of(context)!.monday,
          AppLocalizations.of(context)!.tuesday,
          AppLocalizations.of(context)!.wednesday,
          AppLocalizations.of(context)!.thursday,
          AppLocalizations.of(context)!.friday,
          AppLocalizations.of(context)!.saturday,
          AppLocalizations.of(context)!.sunday,
        ];
        final turniPerGiorno = snapshot.data ?? {};
        return Column(
          children: [
            const SizedBox(height: 17),

            // Giorni della settimana
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: giorniSettimana
                    .map(
                      (g) => Expanded(
                        child: Center(
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            // Griglia giorni (contenuta in un Container per limitarne l'altezza)
            Container(
              constraints: const BoxConstraints(
                maxHeight: 420,
              ), // Limita altezza calendario
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(6, (row) {
                  return TableRow(
                    children: List.generate(7, (col) {
                      final idx = row * 7 + col;
                      if (idx >= days.length ||
                          days[idx].month != _focusedMonth.month) {
                        // Cella "vuota" ma con area cliccabile trasparente
                        return SizedBox(height: 70, width: double.infinity);
                      }
                      final day = days[idx];
                      final isToday =
                          day.day == today.day &&
                          day.month == today.month &&
                          day.year == today.year;
                      final key =
                          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                      final turno = turniPerGiorno[key];
                      return SizedBox(
                        height: 70,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: isToday
                                ? BorderRadius.circular(14)
                                : null,
                            onTap: () async {
                              final dayData =
                                  await DayDataStorage.loadDayDataParsed(key);
                              if (dayData != null &&
                                  (dayData['turno']?.isNotEmpty ?? false)) {
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) => _AnteprimaGiornataDialog(
                                    data: dayData,
                                    dataKey: key,
                                    giorno: day,
                                    onModifica: () async {
                                      Navigator.of(context).pop();
                                      if (widget.onModificaGiornata != null) {
                                        widget.onModificaGiornata!(
                                          day,
                                          dayData,
                                        );
                                      }
                                    },
                                    onElimina: () async {
                                      final conferma = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            AppLocalizations.of(context)!.delete_day_confirm('${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}/${day.year}'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text(AppLocalizations.of(context)!.cancel),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                'Elimina',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                    230,
                                                    211,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (conferma == true) {
                                        await DayDataStorage.saveDayData(
                                          key,
                                          '',
                                        );
                                        if (!context.mounted) return;
                                        Navigator.pop(
                                          context,
                                        ); // chiudi anteprima
                                        setState(() {}); // refresh calendario
                                      }
                                    },
                                  ),
                                );
                              } else {
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _AnteprimaGiornataVuotaDialog(
                                        giorno: day,
                                        onAggiungi: () {
                                          Navigator.of(context).pop();
                                          if (widget.onModificaGiornata !=
                                              null) {
                                            widget.onModificaGiornata!(day, {
                                              'turno': '',
                                              'inizio': '',
                                              'fine': '',
                                              'durata': '',
                                              'straordinario': '',
                                              'pauseField': '',
                                              'luogoIniziale': '',
                                              'luogoFinale': '',
                                              'note': '',
                                            });
                                          }
                                        },
                                      ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              margin: EdgeInsets.zero,
                              decoration: isToday
                                  ? BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2.2,
                                      ),
                                    )
                                  : null,
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 2,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: isToday
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context).brightness ==
                                                Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  if (turno != null && turno.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        turno,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? const Color(0xFFCCCCCC)
                                              : Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
            // Somma straordinari del mese
            FutureBuilder<String>(
              future: _calcolaSommaStraordinariMese(_focusedMonth),
              builder: (context, snapshot) {
                final somma = snapshot.data ?? '--:--';
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 35,
                    bottom: 8,
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.overtime_calendar_hours,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        somma,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Calcola la somma degli straordinari del mese selezionato
  Future<String> _calcolaSommaStraordinariMese(DateTime month) async {
    int totaleMinuti = 0;
    final lastDay = DateTime(month.year, month.month + 1, 0);
    for (int d = 1; d <= lastDay.day; d++) {
      final key =
          '${month.year}-${month.month.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
      final raw = await DayDataStorage.loadDayData(key);
      if (raw != null && raw.isNotEmpty) {
        final parts = raw.split('|');
        if (parts.length > 4 && parts[4].isNotEmpty) {
          // Straordinario
          final s = parts[4].trim();
          final neg = s.startsWith('-');
          final time = s.replaceFirst('-', '');
          final tParts = time.split(':');
          int straordinarioMin = 0;
          if (tParts.length == 2) {
            final h = int.tryParse(tParts[0]) ?? 0;
            final m = int.tryParse(tParts[1]) ?? 0;
            straordinarioMin = h * 60 + m;
            if (neg) straordinarioMin = -straordinarioMin;
          }
          // Pause (campo 5: pauseField)
          int pauseMin = 0;
          if (parts.length > 5 && parts[5].isNotEmpty) {
            final pauseField = parts[5];
            if (pauseField.startsWith('Tause[')) {
              final idx = pauseField.indexOf(']');
              if (idx != -1 && pauseField.length > idx + 2) {
                final afterBracket = pauseField.substring(idx + 1);
                if (afterBracket.startsWith(';')) {
                  final sommaPause = afterBracket.substring(1).trim();
                  if (sommaPause.isNotEmpty && sommaPause != '--:--') {
                    final pauseParts = sommaPause.split(':');
                    if (pauseParts.length == 2) {
                      final h = int.tryParse(pauseParts[0]) ?? 0;
                      final m = int.tryParse(pauseParts[1]) ?? 0;
                      pauseMin = h * 60 + m;
                    }
                  }
                }
              }
            }
          }
          // Netto
          totaleMinuti += (straordinarioMin - pauseMin);
        }
      }
    }
    final sign = totaleMinuti < 0 ? '-' : '';
    final absMin = totaleMinuti.abs();
    final ore = absMin ~/ 60;
    final min = absMin % 60;
    return '$sign${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }
}

// --- FINE: Schermata Calendario ---
// --- DIALOG SELEZIONE TURNO ---
class SelezionaTurnoDialog extends StatefulWidget {
  const SelezionaTurnoDialog({super.key});

  @override
  State<SelezionaTurnoDialog> createState() => _SelezionaTurnoDialogState();
}

class _SelezionaTurnoDialogState extends State<SelezionaTurnoDialog> {
  Map<String, String?> _datiTurni = {};
  bool _loading = true;
  List<String> _nomiTurni = [];

  @override
  void initState() {
    super.initState();
    _caricaTurni();
  }

  Future<void> _caricaTurni() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final turniKeys = allKeys
        .where((k) => k.startsWith('turno_custom_'))
        .toList();
    final nomi = turniKeys
        .map((k) => k.replaceFirst('turno_custom_', ''))
        .toList();
    nomi.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    Map<String, String?> dati = {};
    for (final nome in nomi) {
      dati[nome] = prefs.getString('turno_custom_$nome');
    }
    setState(() {
      _datiTurni = dati;
      _nomiTurni = nomi;
      _loading = false;
    });
  }

Future<void> apriModificaTurno({String? nome, String? dati}) async {
  final result = await showDialog(
    context: context,
    builder: (context) => _ModificaTurnoDialog(
      nomeTurno: nome,
      datiSalvati: dati,
      oreDiLavoroPredefinite: const Duration(hours: 7),
    ),
  );
  if (result == true) {
    _caricaTurni(); // Aggiorna la lista dei turni dopo modifica/aggiunta
  }
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.select_shift,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: AppLocalizations.of(context)!.add_shift,
                    onPressed: () => apriModificaTurno(),
                  ),
                ]
              ),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_nomiTurni.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    AppLocalizations.of(context)!.no_custom_shifts,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _nomiTurni.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final nome = _nomiTurni[idx];
                      final dati = _datiTurni[nome] ?? '';
                      String orario = '';
                      if (dati.isNotEmpty) {
                        final parts = dati.split('|');
                        if (parts.length >= 2) {
                          final inizio = parts[0];
                          final fine = parts[1];
                          if (inizio.isNotEmpty && fine.isNotEmpty) {
                            orario = '$inizio - $fine';
                          } else if (inizio.isNotEmpty) {
                            orario = inizio;
                          } else if (fine.isNotEmpty) {
                            orario = fine;
                          }
                        }
                      }
                      return ListTile(
                        onTap: () => Navigator.of(
                          context,
                        ).pop({'nome': nome, 'dati': dati}),
                        title: Text(
                          nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: orario.isNotEmpty
                            ? Text(
                                orario,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 8),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- FINE: Dialog Seleziona Turno ---
// --- INIZIO: Dialog Anteprima Giornata ---
class _AnteprimaGiornataDialog extends StatelessWidget {
  final Map<String, String> data;
  final String dataKey;
  final DateTime giorno;
  final VoidCallback onModifica;
  final Future<void> Function() onElimina;

  const _AnteprimaGiornataDialog({
    required this.data,
    required this.dataKey,
    required this.giorno,
    required this.onModifica,
    required this.onElimina,
  });

  String get _dataString =>
      '${giorno.day.toString().padLeft(2, '0')}/${giorno.month.toString().padLeft(2, '0')}/${giorno.year}';

  @override
  Widget build(BuildContext context) {
    final turno = data['turno'] ?? '';
    final inizio = data['inizio'] ?? '';
    final fine = data['fine'] ?? '';
    final durata = data['durata'] ?? '';
    final straordinario = data['straordinario'] ?? '';
    final note = data['note'] ?? '';
    final luogoIniziale = data['luogoIniziale'] ?? '';
    final luogoFinale = data['luogoFinale'] ?? '';
    final pauseField = data['pauseField'] ?? '';

    // Parsing pausa: estrai somma totale dopo il punto e virgola fuori dalle parentesi quadre
    String sommaPause = '-';
    if (pauseField.startsWith('Tause[')) {
      final idx = pauseField.indexOf(']');
      if (idx != -1 && pauseField.length > idx + 2) {
        final afterBracket = pauseField.substring(idx + 1);
        if (afterBracket.startsWith(';')) {
          sommaPause = afterBracket.substring(1).trim();
        }
      }
    }
    if (sommaPause.isEmpty || sommaPause == '-' || sommaPause == '--:--') {
      sommaPause = '00:00';
    }

    // Funzione per sommare/ sottrarre due orari (hh:mm)
    String sommaOrari(String straordinario, String pause) {
      if (straordinario.isEmpty || straordinario == '--:--') return '--:--';
      if (pause.isEmpty || pause == '--:--') pause = '00:00';
      if (sommaPause.isEmpty || sommaPause == '-') sommaPause = '00:00';
      final neg = straordinario.startsWith('-');
      final straord = straordinario.replaceFirst('-', '');
      final sParts = straord.split(':');
      final pParts = pause.split(':');
      if (sParts.length != 2 || pParts.length != 2) return '--:--';
      int sMin = (int.tryParse(sParts[0]) ?? 0) * 60 + (int.tryParse(sParts[1]) ?? 0);
      if (neg) sMin = -sMin;
      int pMin = (int.tryParse(pParts[0]) ?? 0) * 60 + (int.tryParse(pParts[1]) ?? 0);
      int totale = sMin - pMin;
      final sign = totale < 0 ? '-' : '';
      final absMin = totale.abs();
      final ore = absMin ~/ 60;
      final min = absMin % 60;
      return '$sign${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    }

    String calcolaTotaleTurno(String durata, String straordinario, String pause) {
    // Parsing durata
    int durataMin = 0;
    final durataParts = durata.split(':');
    if (durataParts.length == 2) {
      durataMin = (int.tryParse(durataParts[0]) ?? 0) * 60 + (int.tryParse(durataParts[1]) ?? 0);
    }
    // Parsing straordinario
    int extraMin = 0;
    bool neg = straordinario.startsWith('-');
    final straord = straordinario.replaceFirst('-', '');
    final extraParts = straord.split(':');
    if (extraParts.length == 2) {
      extraMin = (int.tryParse(extraParts[0]) ?? 0) * 60 + (int.tryParse(extraParts[1]) ?? 0);
      if (neg) extraMin = -extraMin;
    }
    // Parsing pause
    int pauseMin = 0;
    final pauseParts = pause.split(':');
    if (pauseParts.length == 2) {
      pauseMin = (int.tryParse(pauseParts[0]) ?? 0) * 60 + (int.tryParse(pauseParts[1]) ?? 0);
    }
    // Calcolo totale
    int totaleMin = durataMin + extraMin - pauseMin;
    final sign = totaleMin < 0 ? '-' : '';
    final absMin = totaleMin.abs();
    final ore = absMin ~/ 60;
    final min = absMin % 60;
    return '$sign${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }
  final totaleTurno = calcolaTotaleTurno(durata, straordinario, sommaPause);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: AppLocalizations.of(context)!.delete_day_data,
                  onPressed: () async {
                    await onElimina();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            _buildField(AppLocalizations.of(context)!.shift, turno, bold: false),
            const SizedBox(height: 15),
            _buildField(AppLocalizations.of(context)!.effective_shift, totaleTurno, bold: true),
            const SizedBox(height: 10),
            _buildField(
              AppLocalizations.of(context)!.schedule,
              inizio.isNotEmpty && fine.isNotEmpty ? '$inizio - $fine' : '--',
              bold: false,
            ),
            const SizedBox(height: 15),
            _buildField(
              AppLocalizations.of(context)!.place,
              (luogoIniziale.isEmpty && luogoFinale.isEmpty)
                  ? '-'
                  : (luogoIniziale.isNotEmpty && luogoFinale.isNotEmpty
                        ? '$luogoIniziale - $luogoFinale'
                        : (luogoIniziale + luogoFinale)),
              bold: false,
            ),
            const SizedBox(height: 15),
            SizedBox(height: 40, 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.overtime_breaks,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Expanded(
                  child: Text(
                    sommaOrari(straordinario, sommaPause),
                    style: const TextStyle(fontSize: 17),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 22),
                  tooltip: AppLocalizations.of(context)!.overtime_breaks_info,
                  onPressed: () {
                    // Parsing delle singole pause
                    List<Map<String, String>> pauseList = [];
                    if (pauseField.startsWith('Tause[')) {
                      final endIdx = pauseField.indexOf(']');
                      if (endIdx != -1) {
                        final inside = pauseField.substring(6, endIdx);
                        if (inside.isNotEmpty) {
                          final items = inside
                              .split(';')
                              .where((e) => e.contains('-'));
                          for (final item in items) {
                            final parts = item.split('-');
                            String inizio = parts.isNotEmpty ? parts[0] : '';
                            String fine = parts.length > 1 ? parts[1] : '';
                            // Calcola durata
                            String durata = '--:--';
                            if (inizio.isNotEmpty && fine.isNotEmpty) {
                              final inizioParts = inizio.split(':');
                              final fineParts = fine.split(':');
                              if (inizioParts.length == 2 &&
                                  fineParts.length == 2) {
                                final h1 = int.tryParse(inizioParts[0]) ?? 0;
                                final m1 = int.tryParse(inizioParts[1]) ?? 0;
                                final h2 = int.tryParse(fineParts[0]) ?? 0;
                                final m2 = int.tryParse(fineParts[1]) ?? 0;
                                int diff = (h2 * 60 + m2) - (h1 * 60 + m1);
                                if (diff < 0) diff += 24 * 60;
                                final ore = diff ~/ 60;
                                final min = diff % 60;
                                durata =
                                    '${ore.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
                              }
                            }
                            pauseList.add({
                              'inizio': inizio,
                              'fine': fine,
                              'durata': durata,
                            });
                          }
                        }
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        title: Text(AppLocalizations.of(context)!.overtime_breaks2, style: TextStyle(fontSize: 24),),
                              content: SizedBox(
                                width: 400, 
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 19),
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.overtime_2,
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                      ),
                                      Expanded(
                                        child: Text(
                                          sommaOrari(straordinario, sommaPause),
                                          style: const TextStyle(fontSize: 17),
                                          maxLines: 2, // o più se vuoi
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  pauseList.isEmpty
                                    ? Text(AppLocalizations.of(context)!.no_breaks, style: TextStyle(fontSize: 17))
                                    : Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.breaks_total_label,
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            sommaPause,
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 450,
                                        height: 370,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: pauseList.length,
                                          separatorBuilder: (_, _) =>
                                              const Divider(height: 1),
                                          itemBuilder: (context, idx) {
                                            final p = pauseList[idx];
                                            return ListTile(
                                              title: Text(
                                                '${p['inizio']} - ${p['fine']}',
                                              ),
                                              subtitle: Text('Durata: ${p['durata']}'),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  ],
                                ),
                              ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(AppLocalizations.of(context)!.close),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),),
            SizedBox(height: 3),
            _buildField(AppLocalizations.of(context)!.notes_short, note.isNotEmpty ? note : '-', bold: false),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: Theme.of(context).brightness == Brightness.dark
                      ? TextButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.close),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onModifica,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.edit,),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildField(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: 17,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- INIZIO: Dialog Anteprima Giornata Vuota ---
class _AnteprimaGiornataVuotaDialog extends StatelessWidget {
  final DateTime giorno;
  final VoidCallback onAggiungi;
  const _AnteprimaGiornataVuotaDialog({
    required this.giorno,
    required this.onAggiungi,
  });

  String get _dataString =>
      '${giorno.day.toString().padLeft(2, '0')}/${giorno.month.toString().padLeft(2, '0')}/${giorno.year}';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 550, // Limite larghezza come le altre finestre
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dataString,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.no_day_data,
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: Theme.of(context).brightness == Brightness.dark
                      ? TextButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.close),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onAggiungi,
                  style: Theme.of(context).brightness == Brightness.dark
                      ? ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1.5,
                          ),
                        )
                      : null,
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
          ],
        ),
      ),)
    );
  }
}

class _BackupScreen extends StatelessWidget {
  final Future<void> Function() onImportComplete;

  const _BackupScreen({required this.onImportComplete});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle resetButtonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 18),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.backup_and_restore)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Sezione Backup ---
            Text(
              AppLocalizations.of(context)!.backup,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => esportaBackup(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.backup, size: 54),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.backup,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () => importaBackup(context, onImportComplete),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restore, size: 54),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.restore,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // --- Sezione Ripristino ---
            Text(
              AppLocalizations.of(context)!.restore_2,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: resetButtonStyle,
                      onPressed: () async {
                        await resetTurniPerGiornata(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, size: 40),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.reset_calendar,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: resetButtonStyle,
                      onPressed: () async {
                        await resetRiepilogo(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list_alt, size: 40),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.reset_summary,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: resetButtonStyle,
                      onPressed: () async {
                        await resetPersonalizzaTurni(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 40),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.reset_custom_shifts,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: ElevatedButton(
                      style: resetButtonStyle,
                      onPressed: () async {
                        await resetTotale(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever, size: 40),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7),
                            child: Text(
                              AppLocalizations.of(context)!.reset_app,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- INIZIO: Funzioni di backup/ripristino con prefissi corretti ---
Future<void> esportaBackup(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final anniSet = <int>{};
    // 1. Salva la preferenza exitDialogShown come primo valore
    final exitDialogPref = prefs.getBool('exitDialogShown') ?? true;

    // Trova anni dai dati giornata
    for (final k in allKeys.where((k) => k.startsWith('daydata_'))) {
      final year = int.tryParse(k.substring(8, 12));
      if (year != null) anniSet.add(year);
    }
    // Trova anni dai valori annuali già presenti
    for (final k in allKeys) {
      if (k.startsWith('ferieDisponibili_') || k.startsWith('mancPrestAdeg_')) {
        final year = int.tryParse(k.split('_').last);
        if (year != null) anniSet.add(year);
      }
    }

    final variabiliAnnuali = <String, Map<String, int>>{
      'ferieDisponibili': {},
      'mancPrestAdeg': {},
    };
    for (final year in anniSet) {
      variabiliAnnuali['ferieDisponibili']!['$year'] =
          prefs.getInt('ferieDisponibili_$year') ?? 30;
      variabiliAnnuali['mancPrestAdeg']!['$year'] =
          prefs.getInt('mancPrestAdeg_$year') ?? 0;
    }

    // Impostazioni di visibilità
    final allVisibilityTags = [
      'Straordinari (Ore)',
      'Ferie Disponibili',
      'Ferie Rimaste',
      ...MyHomePage.tagList,
      'Mancate Prestazioni di Adeguamento',
    ];
    final visMap = <String, bool>{};
    for (var tag in allVisibilityTags) {
      final key = 'visibility_$tag';
      visMap[key] = prefs.getBool(key) ?? true;
    }

    // Turni Personalizzati
    final turniPersKeys = prefs.getKeys().where((k) => k.startsWith('turno_custom_')).toList();
    final turniPersMap = <String, String>{};
    for (var k in turniPersKeys) {
      turniPersMap[k.replaceFirst('turno_custom_', '')] = prefs.getString(k) ?? '';
    }

    // Turni Giornata
    final turniGiornKeys = allKeys.where((k) => k.startsWith('daydata_')).toList();
    final turniGiornMap = <String, String>{};
    for (var k in turniGiornKeys) {
      turniGiornMap[k.replaceFirst('daydata_', '')] = prefs.getString(k) ?? '';
    }

    // Costruisci la struttura JSON
    final backupJson = {
      '§ExitDialogShown§': exitDialogPref,
      '§VariabiliAnnuali§': variabiliAnnuali,
      '§ImpostazioniDiVisualizzazione§': visMap,
      '§TurniPers§': turniPersMap,
      '§TurniGiorn§': turniGiornMap,
    };

    // Scegli destinazione file
    String? savePath;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (!context.mounted) return;
      final result = await FilePicker.platform.saveFile(
        dialogTitle: AppLocalizations.of(context)!.where_to_save_backup,
        fileName: 'backup_turni_lav.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.export_cancelled)),
        );
        return;
      }
      savePath = result;
    } else if (Platform.isAndroid) {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      savePath = '$selectedDirectory/backup_turni_lav.json';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      savePath = '${dir.path}/backup_turni_lav.json';
    }
    final file = File(savePath);
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(backupJson));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.backup_exported(savePath))),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.backup_export_error('$e'))),
    );
  }
}

Future<void> importaBackup(
  BuildContext context,
  Future<void> Function() onImportCompleteCallback,
) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = File(result.files.single.path!);
    final content = await file.readAsString();
    final prefs = await SharedPreferences.getInstance();

    await resetTurniPerBackup();
    if (!context.mounted) return;
    await resetPersonalizzaTurni(context);

    bool isJson = false;
    Map<String, dynamic> backupData = {};
    try {
      backupData = jsonDecode(content);
      isJson = backupData.containsKey('§VariabiliAnnuali§') || backupData.containsKey('§Variabili§');
    } catch (_) {
      isJson = false;
    }

    if (isJson) {
      // --- NUOVO FORMATO JSON ---
      // Preferenza exitDialogShown
      if (backupData.containsKey('§ExitDialogShown§')) {
        await prefs.setBool('exitDialogShown', backupData['§ExitDialogShown§'] == true);
      }
      // Variabili annuali
      final variabiliAnnuali = backupData['§VariabiliAnnuali§'] as Map<String, dynamic>? ?? {};
      if (variabiliAnnuali.isNotEmpty) {
        final ferieMap = variabiliAnnuali['ferieDisponibili'] as Map<String, dynamic>? ?? {};
        final mpaMap = variabiliAnnuali['mancPrestAdeg'] as Map<String, dynamic>? ?? {};
        for (final entry in ferieMap.entries) {
          await prefs.setInt('ferieDisponibili_${entry.key}', entry.value as int);
        }
        for (final entry in mpaMap.entries) {
          await prefs.setInt('mancPrestAdeg_${entry.key}', entry.value as int);
        }
      }
      // Impostazioni di visibilità
      final visMap = backupData['§ImpostazioniDiVisualizzazione§'] as Map<String, dynamic>? ?? {};
      for (final entry in visMap.entries) {
        await prefs.setBool(entry.key, entry.value == true);
      }
      // Turni Personalizzati
      final turniPers = backupData['§TurniPers§'] as Map<String, dynamic>? ?? {};
      for (final entry in turniPers.entries) {
        await prefs.setString('turno_custom_${entry.key}', entry.value as String);
      }
      // Turni Giornata
      final turniGiorn = backupData['§TurniGiorn§'] as Map<String, dynamic>? ?? {};
      for (final entry in turniGiorn.entries) {
        await prefs.setString('daydata_${entry.key}', entry.value as String);
      }
    } else {
      // --- VECCHIO FORMATO TESTUALE ---
      final lines = content.split('\n');
      String? settore;
      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        if (line.startsWith('§') && line.endsWith('§')) {
          settore = line;
          continue;
        }
        if (settore == '§ImpostazioniDiVisualizzazione§') {
          final parts = line.split('=');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1].trim().toLowerCase();
            if (value == 'true' || value == 'false') {
              await prefs.setBool(key, value == 'true');
            }
          }
        } else if (settore == '§TurniPers§') {
          final idx = line.indexOf('|');
          if (idx > 0) {
            await prefs.setString(
              'turno_custom_${line.substring(0, idx)}',
              line.substring(idx + 1),
            );
          }
        } else if (settore == '§TurniGiorn§') {
          final idx = line.indexOf('|');
          if (idx > 0) {
            await prefs.setString(
              'daydata_${line.substring(0, idx)}',
              line.substring(idx + 1),
            );
          }
        }
      }
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.backup_imported)),
    );
    await onImportCompleteCallback();
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.backup_import_error('$e'))),
    );
  }
}

// --- FINE: Funzioni di backup/ripristino con prefissi corretti ---

// --- Funzioni di Reset dell'applicazione ---

Future<void> resetVisibilitaRiepilogo(BuildContext context) async {
  final confermato = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.visibility_reset_confirm),
      content: Text(
        AppLocalizations.of(context)!.reset_visibility_confirm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child:  Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    ),
  );
  if (confermato == true) {
    final prefs = await SharedPreferences.getInstance();
    final allVisibilityTags = [
      'Straordinari (Ore)',
      'Ferie Disponibili',
      'Ferie Rimaste',
      ...MyHomePage.tagList,
      'Mancate Prestazioni di Adeguamento',
    ];
    for (final tag in allVisibilityTags) {
      await prefs.setBool('visibility_$tag', true);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.reset_visibility_done),
        ),
      );
    }
  }
}

Future<void> resetTurniPerGiornata(BuildContext context) async {
  final confermato = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirm_reset),
      content: Text(
        AppLocalizations.of(context)!.reset_calendar_confirm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child:  Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    ),
  );
  if (confermato == true) {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final turniGiornKeys = allKeys
        .where((k) => k.startsWith('daydata_'))
        .toList();
    for (var k in turniGiornKeys) {
      await prefs.remove(k);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.reset_calendar_done,
          ),
        ),
      );
    }
  }
}

// Reset turni per giornata senza richiesta di conferma (per importazione backup)
Future<void> resetTurniPerBackup() async {
  final prefs = await SharedPreferences.getInstance();
  final allKeys = prefs.getKeys();
  final turniGiornKeys = allKeys
      .where((k) => k.startsWith('daydata_'))
      .toList();
  for (var k in turniGiornKeys) {
    await prefs.remove(k);
  }
}

Future<void> resetRiepilogo(BuildContext context) async {
  final confermato = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirm_reset),
      content: Text(
        AppLocalizations.of(context)!.reset_visibility_confirm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child:  Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    ),
  );
  if (confermato == true) {
    final prefs = await SharedPreferences.getInstance();
    // Reset visibilità
    final allVisibilityTags = [
      'Straordinari (Ore)',
      'Ferie Disponibili',
      'Ferie Rimaste',
      ...MyHomePage.tagList,
      'Mancate Prestazioni di Adeguamento',
    ];
    for (final tag in allVisibilityTags) {
      await prefs.setBool('visibility_$tag', true);
    }
    // Reset ferie disponibili e mpa per tutti gli anni
    final allKeys = prefs.getKeys();
    for (final k in allKeys) {
      if (k.startsWith('ferieDisponibili_') || k.startsWith('mancPrestAdeg_')) {
        await prefs.remove(k);
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.reset_visibility_done),
        ),
      );
    }
  }
}

Future<void> resetPersonalizzaTurni(BuildContext context) async {
  final confermato = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirm_reset),
      content: Text(
        AppLocalizations.of(context)!.reset_custom_shifts_confirm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child:  Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    ),
  );
  if (confermato == true) {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final turniPersKeys = allKeys
        .where((k) => k.startsWith('turno_custom_'))
        .toList();
    for (var k in turniPersKeys) {
      await prefs.remove(k);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.reset_custom_shifts_done,
          ),
        ),
      );
    }
  }
}

Future<void> resetTotale(BuildContext context) async {
  final confermato = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.confirm_reset),
      content: Text(
        AppLocalizations.of(context)!.reset_app_confirm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    ),
  );
  if (confermato == true) {
    // SECONDO DIALOG DI CONFERMA
    if (!context.mounted) return;
    final doppiaConferma = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.attention),
        content: Text(
          AppLocalizations.of(context)!.reset_app_confirm2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.proceed),
          ),
        ],
      ),
    );
    if (doppiaConferma == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.reset_app_done,
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        SystemNavigator.pop();
      }
    }
  }
}
