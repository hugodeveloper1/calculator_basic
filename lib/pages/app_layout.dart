import 'package:flutter/material.dart';

import 'display_widget.dart';
import 'keyboard_widget.dart';
import 'operation_utils.dart';

/// Layout principal de la calculadora.
/// Divide la pantalla en dos:
/// - parte superior para mostrar la operación y el resultado
/// - parte inferior para el teclado
class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  /// Texto que representa la operación actual ingresada por el usuario
  String expression = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: 5,
          children: [
            /// Área de display (operación y resultado)
            Expanded(
              flex: 3,
              child: DisplayWidget(
                operation: expression,
                result: OperationUtils(expression).evaluateExpression,
              ),
            ),

            /// Separador
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),

            /// Área del teclado
            Expanded(
              flex: 5,
              child: KeyboardWidget(
                /// Números y decimales
                onNumber: (value) {
                  if (expression != '0') {
                    expression += value;
                  } else {
                    expression = value;
                  }
                  setState(() {});
                },

                /// Operadores matemáticos (+, −, ×, ÷, %, =)
                onOperator: (value) {
                  const operatorSet = ['+', '-', '−', '×', '÷', '%'];

                  // Quitamos espacios al final para trabajar con el último char real
                  var tempExp = expression.replaceAll(RegExp(r'\s+$'), '');

                  if (tempExp.isEmpty) {
                    // No permitir operadores al inicio, salvo '-'
                    if (value == '-' || value == '−') {
                      tempExp = value;
                    }
                    expression = tempExp;
                    setState(() {});
                    return;
                  }

                  final endsWithOperator = RegExp(r'[+\-−×÷%]$');

                  if (operatorSet.contains(value)) {
                    if (endsWithOperator.hasMatch(tempExp)) {
                      // Reemplaza el último operador
                      tempExp = tempExp.replaceFirst(endsWithOperator, value);
                    } else {
                      // Agrega el operador al final
                      tempExp = '$tempExp $value';
                    }
                    tempExp =
                        '$tempExp '; // deja espacio para seguir escribiendo
                  } else if (value == '=') {
                    // Aquí podrías mostrar solo el resultado si lo deseas
                    // tempExp = OperationUtils(tempExp).evaluarExpresion;
                  }

                  expression = tempExp;
                  setState(() {});
                },

                /// Acciones especiales (delete, clear)
                onAction: (value) {
                  if (value == CalcButton.delete) {
                    if (expression.isNotEmpty) {
                      // Lista de operadores con espacios incluidos
                      final operators = [' + ', ' - ', ' × ', ' ÷ '];

                      bool removed = false;
                      for (final op in operators) {
                        if (expression.endsWith(op)) {
                          expression = expression.substring(
                            0,
                            expression.length - op.length,
                          );
                          removed = true;
                          break;
                        }
                      }

                      // Si no coincide con operador, borra un carácter
                      if (!removed) {
                        expression = expression.substring(
                          0,
                          expression.length - 1,
                        );
                      }

                      if (expression.isEmpty) {
                        expression = '0';
                      }
                    }
                  } else if (value == CalcButton.clear) {
                    expression = '0';
                  }

                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
