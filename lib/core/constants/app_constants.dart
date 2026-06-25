class AppConstants {
  // اسم التطبيق
  static const String appName = 'نظام المحاسبة';

  // مجموعات Firestore
  static const String usersCollection    = 'users';
  static const String clientsCollection  = 'clients';
  static const String servicesCollection = 'services';
  static const String invoicesCollection = 'invoices';
  static const String expensesCollection = 'expenses';

  // حالات الفاتورة
  static const String invoicePaid    = 'مدفوعة';
  static const String invoicePending = 'معلقة';
  static const String invoiceOverdue = 'متأخرة';

  // فئات المصروفات
  static const List<String> expenseCategories = [
    'رواتب',
    'إيجار',
    'مواصلات',
    'معدات',
    'تسويق',
    'اتصالات',
    'كهرباء وماء',
    'أخرى',
  ];

  // فئات الخدمات
  static const List<String> serviceCategories = [
    'استشارات',
    'تصميم',
    'برمجة',
    'صيانة',
    'تدريب',
    'أخرى',
  ];

  // العملة
  static const String currency = 'ر.س';


  
  static const String transactionsCollection = 'transactions';
  static const String remindersCollection = 'reminders';

  static const List<String> currencies = ['محلي', 'دولار', 'سعودي'];
}