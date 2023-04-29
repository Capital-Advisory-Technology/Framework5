#include <Critiq-Include/backend/PositionManager.mqh>
#include <Critiq-Include/main/Risk.mqh>
#include <Critiq-Include/main/Calculations.mqh>

class FooModel {
    protected:
        int foo_handle; // handle for the indicator
        int inpPeriod; // input period
        double inpVolume; // input volume
        ENUM_APPLIED_PRICE inpPrice; // input price
        Risk *risk;
        PositionManager *positionManager;

        double _foo_signal[];

    public:
        FooModel(void);
        ~FooModel(void);

        void init(int period, double volume, ENUM_APPLIED_PRICE price);
        bool OnTick();

        void initRisk(double rpp, int posRatio);
};

extern FooModel *fooModel;

void FooModel::FooModel(void) : inpPeriod(14),
                                inpVolume(0.7),
                                inpPrice(PRICE_CLOSE),
                                risk(new Risk),
                                positionManager(new PositionManager) {}

void FooModel::~FooModel(void) {}

void FooModel::init(int period, double volume, ENUM_APPLIED_PRICE price) {
    SetIndexBuffer(0, _foo_signal, INDICATOR_COLOR_INDEX);
    ResetLastError();
    ArraySetAsSeries(_foo_signal, true);

    foo_handle = iCustom(NULL, 0, 
    "Critiq-Indicators\\GeneralizedDoubleDEMA", period, volume, price);
}

void FooModel::initRisk(double rpp, int posRatio) {
    risk.init(rpp, posRatio);
    risk.init_atr_model(14, 1.5);
}

bool FooModel::OnTick() {

    Print("HERE5");
    CopyBuffer(foo_handle,1,0,5,_foo_signal);
    Print("DEMA val: ", _foo_signal[0]);

    if(_foo_signal[0] == 1) {
        if(!positionManager.isOrderOpen()) {
            dpuble risk.get_atr_model();
            double volume = risk.get_volume();
            double stoploss = risk.get_slPrice();
            double takeprofit = risk.get_tpPrice();
            positionManager.OrderOpen(ORDER_TYPE_BUY, volume, stoploss, takeprofit);
        }
        
    }

    // if(_foo_signal[0] == 2) {
    //     if(!isOrderOpen()) OrderOpen(ORDER_TYPE_SELL);
    // }

    return true;
}



void OnDeinit() {
    delete positionManager;
    delete risk;
}

