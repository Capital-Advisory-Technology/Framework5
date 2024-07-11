enum SIGNAL_TYPE {
    SIGNAL_NULL = 0,
    SIGNAL_BUY = 100,
    SIGNAL_SELL = 101,
    SIGNAL_IGNORE = 102
};

// return codes for execution
enum EXECUTION_CODE {
    VOID = 0,
    BUY_TRUE = 200,
    BUY_FALSE = 300,
    SELL_TRUE = 201,
    SELL_FALSE = 301,
    BUY_LIMIT_TRUE = 400,
    BUY_LIMIT_FALSE = 500,
    SELL_LIMIT_TRUE = 401,
    SELL_LIMIT_FALSE = 501
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