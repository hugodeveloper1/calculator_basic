import 'package:flutter/material.dart';
import 'package:mobile_app/pages/custom_grid.dart';
import 'package:mobile_app/pages/item_button.dart';

/// Colores principales de la calculadora
Color primaryBlue = const Color(0xFF4B5EFC);
Color secondaryGray = const Color(0xFF4E505F);

/// Enum que representa cada botón de la calculadora
enum CalcButton {
  clear('C'),
  toggle('+/-'),
  percent('%'),
  divide('÷'),
  nine('9'),
  eight('8'),
  seven('7'),
  multiply('×'),
  six('6'),
  five('5'),
  four('4'),
  minus('−'),
  three('3'),
  two('2'),
  one('1'),
  plus('+'),
  dot('.'),
  zero('0'),
  delete('⌫'),
  equals('=');

  final String symbol;
  const CalcButton(this.symbol);

  /// Determina si el botón es un número o punto decimal
  bool get isNumber => int.tryParse(symbol) != null || symbol == '.';

  /// Determina si el botón es una operación matemática
  bool get isOperator => ['+', '−', '×', '÷', '='].contains(symbol);
}

/// Teclado principal de la calculadora
class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({
    super.key,
    required this.onNumber,
    required this.onOperator,
    required this.onAction,
  });

  /// Callback para números y decimales
  final ValueChanged<String> onNumber;

  /// Callback para operaciones (+, −, ×, ÷, =)
  final ValueChanged<String> onOperator;

  /// Callback para acciones especiales (clear, delete)
  final ValueChanged<CalcButton> onAction;

  /// Maneja la pulsación de un botón dependiendo de su tipo
  void _handleTap(CalcButton button) {
    if (button.isNumber) {
      onNumber(button.symbol);
    } else if (button.isOperator) {
      onOperator(button.symbol);
    } else {
      onNumber(button.symbol);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return CustomGrid(
          columns: 4,
          width: width,
          height: height,
          spacing: width > height ? height * 0.03 : width * 0.03,
          children: [
            // Primera fila
            ItemButton(
              value: CalcButton.clear.symbol,
              color: secondaryGray,
              onTap: () => onAction(CalcButton.clear),
            ),
            ItemButton(
              value: CalcButton.toggle.symbol,
              color: secondaryGray,
              onTap: () => _handleTap(CalcButton.toggle),
            ),
            ItemButton(
              value: CalcButton.percent.symbol,
              color: secondaryGray,
              onTap: () => _handleTap(CalcButton.percent),
            ),
            ItemButton(
              value: CalcButton.divide.symbol,
              color: primaryBlue,
              onTap: () => _handleTap(CalcButton.divide),
            ),

            // Segunda fila
            ItemButton(
              value: CalcButton.nine.symbol,
              onTap: () => _handleTap(CalcButton.nine),
            ),
            ItemButton(
              value: CalcButton.eight.symbol,
              onTap: () => _handleTap(CalcButton.eight),
            ),
            ItemButton(
              value: CalcButton.seven.symbol,
              onTap: () => _handleTap(CalcButton.seven),
            ),
            ItemButton(
              value: CalcButton.multiply.symbol,
              color: primaryBlue,
              onTap: () => _handleTap(CalcButton.multiply),
            ),

            // Tercera fila
            ItemButton(
              value: CalcButton.six.symbol,
              onTap: () => _handleTap(CalcButton.six),
            ),
            ItemButton(
              value: CalcButton.five.symbol,
              onTap: () => _handleTap(CalcButton.five),
            ),
            ItemButton(
              value: CalcButton.four.symbol,
              onTap: () => _handleTap(CalcButton.four),
            ),
            ItemButton(
              value: CalcButton.minus.symbol,
              color: primaryBlue,
              onTap: () => _handleTap(CalcButton.minus),
            ),

            // Cuarta fila
            ItemButton(
              value: CalcButton.three.symbol,
              onTap: () => _handleTap(CalcButton.three),
            ),
            ItemButton(
              value: CalcButton.two.symbol,
              onTap: () => _handleTap(CalcButton.two),
            ),
            ItemButton(
              value: CalcButton.one.symbol,
              onTap: () => _handleTap(CalcButton.one),
            ),
            ItemButton(
              value: CalcButton.plus.symbol,
              color: primaryBlue,
              onTap: () => _handleTap(CalcButton.plus),
            ),

            // Quinta fila
            ItemButton(
              value: CalcButton.dot.symbol,
              onTap: () => _handleTap(CalcButton.dot),
            ),
            ItemButton(
              value: CalcButton.zero.symbol,
              onTap: () => _handleTap(CalcButton.zero),
            ),
            ItemButton(
              value: CalcButton.delete.symbol,
              onTap: () => onAction(CalcButton.delete),
            ),
            ItemButton(
              value: CalcButton.equals.symbol,
              color: primaryBlue,
              onTap: () => _handleTap(CalcButton.equals),
            ),
          ],
        );
      },
    );
  }
}
