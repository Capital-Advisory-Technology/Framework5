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
    AdaptiveATR *adaptiveATR = new AdaptiveATR;
    
    adaptiveATR.init(period);
    Print("HERE");
    this.sl_atr_model = true;
    this.atr_period = period;
    this.atr_multiplier = multiplier;
}

void Risk::get_atr_model(ENUM_ORDER_TYPE orderType) {
    int atr_val = adaptiveATR.GetLast() * atr_multiplier;;
    volume = CalculateLotSize(riskPerTrade, atr_val);
    slPrice = GetSLprice(atr_val, orderType);
    tpPrice = GetTPprice(atr_val, orderType, posRatio);
}

