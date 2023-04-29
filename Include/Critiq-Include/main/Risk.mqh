#include <Critiq-Include/common/Logger.mqh>
#include <Critiq-Include/main/Calculations.mqh>

#include <Critiq-Include/Models/AdaptiveATR.mqh>
#include <Critiq-Include/Models/ATR.mqh>

class Risk {
    protected:
        // Inputs
        double riskPerTrade;
        double posRatio;
        
        // Risk Models
        bool sl_atr_model;              // ATR model on/off
        int atr_period;
        double atr_multiplier;

        bool sl_fixed_points_model;     // Fixed points model on/off
        int fixed_points;

        bool sl_scaling_model;       // Break even model on/off
        double scaling_ratio;

        // Return values
        double volume;
        double slPrice;
        double tpPrice;

    public:
        Risk(void);
        ~Risk(void);

        void initRisk(double riskPerTrade, double posRatio);

        void init_sl_atr(int period, double multiplier);
        void get_sl_atr(ENUM_ORDER_TYPE orderType);

        void init_atr_model(int period, double multiplier);
        void get_atr_model(ENUM_ORDER_TYPE orderType);

        double get_volume() { return volume; }
        double get_slPrice() { return slPrice; }
        double get_tpPrice() { return tpPrice; }
};

extern Risk *risk = new Risk;
AdaptiveATR *adaptiveATR = new AdaptiveATR;
ATR *slATR = new ATR;

Risk::Risk(void) : riskPerTrade(1.0), posRatio(10),
                   sl_atr_model(true), atr_period(14),
                   atr_multiplier(1.5), sl_fixed_points_model(false),
                   fixed_points(NULL), sl_scaling_model(false),
                   scaling_ratio(NULL) {}

void Risk::~Risk(void) {} // decon.

void Risk::initRisk(double riskPerTrade, double posRatio) {
    riskPerTrade = riskPerTrade;
    posRatio = posRatio;
}

void Risk::init_sl_atr(int period, double multiplier) {
    sl_atr_model = true;
    atr_period = period;
    atr_multiplier = multiplier;

    slATR.init(period);
}

void Risk::get_sl_atr(ENUM_ORDER_TYPE orderType) {
    double atr_val = NormalizeDouble(slATR.GetLast(), _Digits);
    Print("ATR val: ", atr_val);
    
    volume = NormalizeDouble(CalculateLotSize(riskPerTrade, atr_val), 2);
    Print("Lot size: ", CalculateLotSize(riskPerTrade, atr_val));

    slPrice = NormalizeDouble(GetSLprice(atr_val, orderType), _Digits+1);
    Print("SL Price: ", GetSLprice(atr_val, orderType));
    
    tpPrice = NormalizeDouble(GetTPprice(atr_val, orderType, posRatio), _Digits+1);
    Print("TP Price: ", GetTPprice(atr_val, orderType, posRatio));
    
    Print("Volume: ", volume);
    Print("SL Price: ", slPrice);
    Print("TP Price: ", tpPrice);
    Print("=================================");
}

void Risk::init_atr_model(int period, double multiplier) {
    adaptiveATR.init(period);
    Print("HERE");
    this.sl_atr_model = true;
    this.atr_period = period;
    this.atr_multiplier = multiplier;
}

void Risk::get_atr_model(ENUM_ORDER_TYPE orderType) {
    Print("=================================");
    Print("OG ATR: ", adaptiveATR.GetLast());
    Print("NORM ATR: ", NormalizeDouble(adaptiveATR.GetLast(), _Digits));

    double atr_val = NormalizeDouble(adaptiveATR.GetLast() * atr_multiplier, _Digits);
    Print("ATR val: ", atr_val);
    
    volume = NormalizeDouble(CalculateLotSize(riskPerTrade, atr_val), 2);
    Print("Lot size: ", CalculateLotSize(riskPerTrade, atr_val));

    slPrice = NormalizeDouble(GetSLprice(atr_val, orderType), _Digits);
    Print("SL Price: ", GetSLprice(atr_val, orderType));
    
    tpPrice = NormalizeDouble(GetTPprice(atr_val, orderType, posRatio), _Digits);
    Print("TP Price: ", GetTPprice(atr_val, orderType, posRatio));
    
    Print("Volume: ", volume);
    Print("SL Price: ", slPrice);
    Print("TP Price: ", tpPrice);
    Print("=================================");
}

