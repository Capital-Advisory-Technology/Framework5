#include <Critiq-Include/common/Logger.mqh>
#include <Critiq-Include/main/Calculations.mqh>

#include <Critiq-Include/Models/AdaptiveATR.mqh>

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

        void init_atr_model(int period, double multiplier);
        void get_atr_model(ENUM_ORDER_TYPE orderType);

        double get_volume() { return volume; }
        double get_slPrice() { return slPrice; }
        double get_tpPrice() { return tpPrice; }
};

extern Risk *risk = new Risk;
AdaptiveATR *adaptiveATR = new AdaptiveATR;

Risk::Risk(void) : riskPerTrade(1.0), posRatio(10),
                   sl_atr_model(true), atr_period(14),
                   atr_multiplier(1.5), sl_fixed_points_model(false),
                   fixed_points(NULL), sl_scaling_model(false),
                   scaling_ratio(NULL) {}

void Risk::~Risk(void) {} // decon.

void Risk::initRisk(double riskPerTrade, double posRatio) {
    this.riskPerTrade = riskPerTrade;
    this.posRatio = posRatio;
}

void Risk::init_atr_model(int period, double multiplier) {
    adaptiveATR.init(period);
    Print("HERE");
    this.sl_atr_model = true;
    this.atr_period = period;
    this.atr_multiplier = multiplier;
}

void Risk::get_atr_model(ENUM_ORDER_TYPE orderType) {
    Print("GetFirst: ", adaptiveATR.GetLast());
    Print("GetLast: ", NormalizeDouble(adaptiveATR.GetLast(), _Digits));
    double atr_val = NormalizeDouble(adaptiveATR.GetLast() * atr_multiplier, _Digits);
    Print("ATR val: ", atr_val);
    // int atr_points = atr_val / _Point;
    // Print("ATR points: ", atr_points);
    // Print("Pips: ", _Point);
    volume = NormalizeDouble(CalculateLotSize(riskPerTrade, atr_val), 2);
    slPrice = NormalizeDouble(GetSLprice(atr_val, orderType), _Digits);
    tpPrice = NormalizeDouble(GetTPprice(atr_val, orderType, posRatio), _Digits);
    Print("Volume: ", volume);
    Print("SL Price: ", slPrice);
    Print("TP Price: ", tpPrice);
    Print("=================================");
}

