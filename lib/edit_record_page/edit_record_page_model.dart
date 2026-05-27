import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'edit_record_page_widget.dart' show EditRecordPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditRecordPageModel extends FlutterFlowModel<EditRecordPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  // State field(s) for mi widget.
  FocusNode? miFocusNode;
  TextEditingController? miTextController;
  String? Function(BuildContext, String?)? miTextControllerValidator;
  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;
  // State field(s) for year widget.
  FocusNode? yearFocusNode;
  TextEditingController? yearTextController;
  String? Function(BuildContext, String?)? yearTextControllerValidator;
  // State field(s) for course widget.
  FocusNode? courseFocusNode;
  TextEditingController? courseTextController;
  String? Function(BuildContext, String?)? courseTextControllerValidator;
  // State field(s) for photo widget.
  FocusNode? photoFocusNode;
  TextEditingController? photoTextController;
  String? Function(BuildContext, String?)? photoTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    miFocusNode?.dispose();
    miTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();

    yearFocusNode?.dispose();
    yearTextController?.dispose();

    courseFocusNode?.dispose();
    courseTextController?.dispose();

    photoFocusNode?.dispose();
    photoTextController?.dispose();
  }
}
