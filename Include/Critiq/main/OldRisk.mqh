#include <Critiq/common/Logger.mqh>
#include <Critiq/main/Calculations.mqh>

#include <Critiq/Models/AdaptiveATR.mqh>
#include <Critiq/Models/ATR.mqh>

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
aATR *adaptiveATR = new aATR;
ATR *slATR = new ATR;

Risk::Risk(void) : riskPerTrade(1.0), posRatio(10),
                   sl_atr_model(true), atr_period(14),
                   atr_multiplier(1.5), sl_fixed_points_model(false),
                   fixed_points(NULL), sl_scaling_model(false),
                   scaling_ratio(NULL) {}

void Risk::~Risk(void) {} 

void Risk::initRisk(double cRiskPerTrade, double cPosRatio) {
    riskPerTrade = cRiskPerTrade;
    posRatio = cPosRatio;
}

void Risk::init_sl_atr(int period, double multiplier) {
    sl_atr_model = true;
    atr_period = period;
    atr_multiplier = multiplier;

    slATR.init(period);
}

void Risk::get_sl_atr(ENUM_ORDER_TYPE orderType) {
    double atr_val = NormalizeDouble(slATR.GetLast(), _Digits);
    
    volume = NormalizeDouble(CalculateLotSize(riskPerTrade, atr_val), 2);
    slPrice = NormalizeDouble(GetSLprice(atr_val, orderType), _Digits+1);
    tpPrice = NormalizeDouble(GetTPprice(atr_val, orderType, posRatio), _Digits+1);
}

void Risk::init_atr_model(int period, double multiplier) {
    adaptiveATR.Init(period);
    this.sl_atr_model = true;
    this.atr_period = period;
    this.atr_multiplier = multiplier;
}

void Risk::get_atr_model(ENUM_ORDER_TYPE orderType) {
    double atr_val = NormalizeDouble(adaptiveATR.GetValue() * atr_multiplier, _Digits);    
    volume = NormalizeDouble(CalculateLotSize(riskPerTrade, atr_val), 2);
    slPrice = NormalizeDouble(GetSLprice(atr_val, orderType), _Digits);
    tpPrice = NormalizeDouble(GetTPprice(atr_val, orderType, posRatio), _Digits);
}

