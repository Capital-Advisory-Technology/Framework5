#include <Critiq/backend/Model.mqh>

class Dewa : public Model {
    protected:
        int dema_handle;
        // double _dema_signal[];

        int inpPeriod;
        double inpVolume;
        ENUM_APPLIED_PRICE inpPrice;

        ENUM_ORDER_TYPE SimpleSignal();
        ENUM_ORDER_TYPE CrossoverSignal();
    
    public:
        Dewa(void);
        ~Dewa(void);

        void Init(int period, double volume, ENUM_APPLIED_PRICE price);
        virtual ENUM_ORDER_TYPE GetSignal();
        
};

extern Dewa *dewa = new Dewa;

void Dewa::Dewa(void) : inpPeriod(14),
                        inpVolume(0.7),
                        inpPrice(PRICE_CLOSE) {}
void Dewa::~Dewa(void) {
    IndicatorRelease(dema_handle);
}

void Dewa::Init(int cPeriod, double cVolume, ENUM_APPLIED_PRICE ePrice) {
    path = "Critiq-Indicators\\GeneralizedDoubleDEMA";
    dema_handle = iCustom(NULL, 0, path, cPeriod, cVolume, ePrice);
}

ENUM_ORDER_TYPE Dewa::GetSignal() {
    double _dema_signal[];

    ResetLastError();
    ArraySetAsSeries(_dema_signal, true);
    CopyBuffer(dema_handle,1,0,5,_dema_signal);

    Print("Current: ", _dema_signal[1], " Previous: ", _dema_signal[2]);

    if(_dema_signal[1] == 1.0 && _dema_signal[2] == 2.0) {
        return ORDER_TYPE_BUY;
    } else if(_dema_signal[1] == 2.0 && _dema_signal[2] == 1.0) {
        return ORDER_TYPE_SELL;
    } 
    
    return ORDER_TYPE_CLOSE_BY;    
}

// ENUM_ORDER_TYPE Dewa::SimpleSignal() {
//     CopyBuffer(dema_handle,1,0,5,_dema_signal);

//     if(_dema_signal[0] == 1) {
//         return ORDER_TYPE_BUY;
//     } else if(_dema_signal[0] == 2) 
//         return ORDER_TYPE_SELL;
    
//     return NULL;
// }

// ENUM_ORDER_TYPE Dewa::CrossoverSignal() {
//     CopyBuffer(dema_handle,1,0,5,_dema_signal);

//     Print("Current: ", _dema_signal[0], " Previous: ", _dema_signal[1]);
//     if(BuySignalCrossover(_dema_signal[0], _dema_signal[1])) {
//         Print("DEWA BUY SIGNAL");
//         return ORDER_TYPE_BUY;
//     } else if(SellSignalCrossover(_dema_signal[0], _dema_signal[1])) {
//         Print("DEWA SELL SIGNAL");
//         return ORDER_TYPE_SELL;
//     }

//     return NULL;
// }