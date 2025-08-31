/// Extensões para formatação de datas
mixin DateFormatterMixin {
  /// Formata uma data no padrão brasileiro (dd/MM/yyyy)
  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

/// Extensão para DateTime que adiciona métodos de formatação
extension DateTimeExtensions on DateTime {
  /// Formata a data no padrão brasileiro (dd/MM/yyyy)
  String formatarDataBrasileira() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }
  
  /// Formata a data no padrão brasileiro com hora (dd/MM/yyyy HH:mm)
  String formatarDataHoraBrasileira() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}