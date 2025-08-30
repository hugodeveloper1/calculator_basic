class OperationUtils {
  final String input;

  OperationUtils(this.input);

  /// Retorna el resultado como String:
  /// - un entero si el resultado es exacto (ej: "200")
  /// - un double formateado si tiene decimales (ej: "2.5")
  /// - "0" si hay error
  String get evaluateExpression {
    try {
      // Normalizar símbolos y espacios
      String expr = _normalizeSymbols(input);
      if (expr.isEmpty) return '0';

      // Expandir porcentajes antes de tokenizar
      expr = _expandPercentages(expr);

      // Quitar operadores inválidos al final
      expr = _trimTrailingOperators(expr);
      if (expr.isEmpty) return '0';

      // Tokenizar, convertir a postfijo y evaluar
      final tokens = _tokenize(expr);
      if (tokens.isEmpty) return '0';
      final rpn = _toPostfix(tokens);
      final double result = _evaluatePostfix(rpn);

      if (!result.isFinite) return '0';

      // Si es entero dentro de un epsilon, devolver int
      if ((result - result.round()).abs() < 1e-10) {
        return result.round().toString();
      }

      // Sino devolver double formateado sin ceros innecesarios
      return _formatDouble(result);
    } catch (_) {
      return '0';
    }
  }

  // ------------------ Helpers ---------------------

  /// Normaliza símbolos visuales a operadores estándar (+, -, *, /) y limpia espacios
  String _normalizeSymbols(String s) {
    return s
        .replaceAll('×', '*')
        .replaceAll('x', '*')
        .replaceAll('X', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('\u2013', '-') // en-dash
        .replaceAll(RegExp(r'\u00A0'), ' ') // no-break space
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Expande porcentajes:
  /// - "a + b%" -> "a + (a * b / 100)"
  /// - "a - b%" -> "a - (a * b / 100)"
  /// - "%n" o "n%" -> "(n / 100)"
  String _expandPercentages(String s) {
    var out = s;

    // 1) a + b% / a - b%
    final infixPercent = RegExp(r'(\d*\.?\d+)\s*([+\-])\s*(\d*\.?\d+)%');
    while (infixPercent.hasMatch(out)) {
      out = out.replaceAllMapped(infixPercent, (m) {
        final a = m[1]!;
        final op = m[2]!;
        final b = m[3]!;
        return '$a $op ($a * $b / 100)';
      });
    }

    // 2) %n
    final prefixPercent = RegExp(r'%\s*(\d*\.?\d+)');
    out = out.replaceAllMapped(prefixPercent, (m) => '(${m[1]} / 100)');

    // 3) n%
    final postfixPercent = RegExp(r'(\d*\.?\d+)%');
    out = out.replaceAllMapped(postfixPercent, (m) => '(${m[1]} / 100)');

    return out.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Elimina operadores inválidos al final de la expresión
  String _trimTrailingOperators(String s) {
    var out = s.trimRight();
    final opRegex = RegExp(r'[+\-*/]$');
    while (out.isNotEmpty && opRegex.hasMatch(out)) {
      out = out.substring(0, out.length - 1).trimRight();
    }
    return out;
  }

  /// Convierte la expresión a tokens (números, operadores y paréntesis)
  /// además maneja el signo negativo unario (ej: "-5")
  List<String> _tokenize(String exp) {
    final regex = RegExp(r'(\d*\.?\d+|[+\-*/()])');
    final raw = regex.allMatches(exp).map((m) => m.group(0)!).toList();

    List<String> tokens = [];
    int i = 0;
    while (i < raw.length) {
      final t = raw[i];

      if (t == '-' &&
          (tokens.isEmpty ||
              tokens.last == '(' ||
              '+-*/'.contains(tokens.last))) {
        if (i + 1 < raw.length && double.tryParse(raw[i + 1]) != null) {
          tokens.add('-' + raw[i + 1]);
          i += 2;
          continue;
        } else {
          tokens.add(t);
          i++;
          continue;
        }
      }

      tokens.add(t);
      i++;
    }

    return tokens;
  }

  /// Prioridad de operadores
  int _priority(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  /// Convierte la expresión en notación postfija (Shunting Yard)
  List<String> _toPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> operators = [];

    for (var token in tokens) {
      if (double.tryParse(token) != null) {
        output.add(token);
      } else if ('+-*/'.contains(token)) {
        while (operators.isNotEmpty &&
            operators.last != '(' &&
            _priority(operators.last) >= _priority(token)) {
          output.add(operators.removeLast());
        }
        operators.add(token);
      } else if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isNotEmpty && operators.last == '(') {
          operators.removeLast();
        } else {
          throw Exception('Paréntesis desbalanceados');
        }
      } else {
        throw Exception('Token desconocido: $token');
      }
    }

    while (operators.isNotEmpty) {
      final op = operators.removeLast();
      if (op == '(' || op == ')') {
        throw Exception('Paréntesis desbalanceados');
      }
      output.add(op);
    }

    return output;
  }

  /// Evalúa la expresión en notación postfija
  double _evaluatePostfix(List<String> rpn) {
    List<double> stack = [];

    for (var token in rpn) {
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else {
        if (stack.length < 2) throw Exception('Expresión inválida');
        double b = stack.removeLast();
        double a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            if (b == 0) throw Exception('División por cero');
            stack.add(a / b);
            break;
          default:
            throw Exception('Operador no soportado: $token');
        }
      }
    }

    if (stack.isEmpty) throw Exception('Expresión inválida');
    return stack.single;
  }

  /// Formatea double eliminando ceros innecesarios
  String _formatDouble(double d) {
    String s = d.toStringAsFixed(10);
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
