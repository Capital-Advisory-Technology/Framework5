#include <Critiq/backend/Model.mqh>

#include <Critiq/main/ReturnSignal.mqh>

class Dewa : public Model {
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

        void Init(int period, double volume, ENUM_APPLIED_PRICE price);
        ENUM_ORDER_TYPE GetSignal();

};

extern Dewa *dewa = new Dewa;

void Dewa::Dewa(void) : inpPeriod(14),
                        inpVolume(0.7),
                        inpPrice(PRICE_CLOSE) {}
void Dewa::~Dewa(void) {}

void Dewa::Init(int cPeriod, double cVolume, ENUM_APPLIED_PRICE ePrice) {
    path = "Critiq-Indicators\\GeneralizedDoubleDEMA";

    SetIndexBuffer(1, _dema_signal, INDICATOR_COLOR_INDEX);
    ResetLastError();
    ArraySetAsSeries(_dema_signal, true);
    dema_handle = iCustom(NULL, 0, path, cPeriod, cVolume, ePrice);
}

ENUM_ORDER_TYPE Dewa::GetSignal() {
    CopyBuffer(dema_handle,1,0,5,_dema_signal);

    if(_dema_signal[0] == 1) {
        return ORDER_TYPE_BUY;
    } else if(_dema_signal[0] == 2) 
        return ORDER_TYPE_SELL;

    return false;
}