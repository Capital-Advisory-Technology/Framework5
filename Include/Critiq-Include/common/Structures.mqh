struct Deal
{
    int ticket;
    int order;
    int type;
    int entry;
    int magic;
    int reason;
    int position_id;

    double volume;
    double price;
    double commission;
    double swap;
    double profit;
    double fee;
    double slLevel;
    double tpLevel;

    string symbol;
    string comment;

    int balance;
};

struct RiskParams {
    double riskPerTrade;
    double posRatio;
    int ATRPeriod;
    int slippage;
    int breakEven;
};

struct RiskSettings
{
    // Main inputs
    double riskPerTrade;
    double posRatio;

    // Risk Models
    bool sl_atr_model;              // ATR model on/off
    int atr_period;
    int atr_multiplier;

    bool sl_fixed_points_model;     // Fixed points model on/off
    int fixed_points;

    bool sl_scaling_model;       // Break even model on/off
    double scaling_ratio;

    // bool sl_adr_model;              //  ADR model on/off
    // int adr_period;
    // int adr_multiplier;
};