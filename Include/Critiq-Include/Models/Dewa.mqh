#include <Critiq-Include/Models/ReturnSignal.mqh>

class Dewa {
    protected:
        int dema_handle;
        int waddah_handle;

        int inpPeriod;
        double inpVolume;
        ENUM_APPLIED_PRICE inpPrice;
        
        double _dema_price[];
        double _dema_signal[];

    public:
        Dewa(void);
        ~Dewa(void);

        void init(int period, double volume, ENUM_APPLIED_PRICE price);
        bool OnTick();
        int getSignal();

};

extern Dewa *dewaModel = new Dewa;

void Dewa::Dewa(void) : inpPeriod(14),
                        inpVolume(0.7),
                        inpPrice(PRICE_CLOSE) {}
void Dewa::~Dewa(void) {}

void Dewa::init(int cPeriod, double cVolume, ENUM_APPLIED_PRICE ePrice) {
    // SetIndexBuffer(0, _dema_price, INDICATOR_DATA);
    SetIndexBuffer(1, _dema_signal, INDICATOR_COLOR_INDEX);
    ResetLastError();
    // ArraySetAsSeries(_dema_price, true);
    ArraySetAsSeries(_dema_signal, true);

    dema_handle = iCustom(NULL, 0, 
    "Critiq-Indicators\\GeneralizedDoubleDEMA", cPeriod, cVolume, ePrice);
}

bool Dewa::OnTick() {
    // CopyBuffer(dema_handle,0,0,5,_dema_price);
    CopyBuffer(dema_handle,1,0,5,_dema_signal);

    // Print("DEMA PRICE: ", _dema_price[0]);
    Print("DEMA CLR: ", _dema_signal[0]);
    
    // if(_dema_signal[0] == 1) {
    //     if(!isOrderOpen()) OrderOpen(ORDER_TYPE_BUY);
    // }

    return true;
}

int Dewa::getSignal() {
    CopyBuffer(dema_handle,1,0,5,_dema_signal);

    if(_dema_signal[0] == 1) {
        return ORDER_TYPE_BUY;
    } else if(_dema_signal[0] == 2) 
        return ORDER_TYPE_SELL;

    return 0;
}