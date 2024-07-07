enum ENUM_SIGNAL_TYPE {
    SIGNAL_LONG = ORDER_TYPE_BUY,
    SIGNAL_SHORT = ORDER_TYPE_SELL,
    SIGNAL_IGNORE = 70
};

enum ENUM_PRICE_DERIVATIVE {
   Open,       // Open
   High,       // High
   Low,        // Low
   Close,      // Close
   Median,     // Median, (h+l)/2
   Mid,        // Mid, (o+c)/2
   Typical,    // Typical, (h+l+c)/3
   Weighted,   // Weighted, (h+l+c+c)/4
   Average     // Average, (o+h+l+c)/4
};