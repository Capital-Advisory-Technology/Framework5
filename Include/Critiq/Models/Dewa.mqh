#include <Critiq/backend/Model.mqh>

class DewaInputs : public ModelInputs {
    protected:
        int inpPeriod;
        double inpVolume;
        ENUM_APPLIED_PRICE inpPrice;

    public:
        virtual void Init() {
            modelName = "Dewa";
            inpPeriod = 14;
            inpVolume = 0.7;
            inpPrice = PRICE_CLOSE;
        }
        int getPeriod() {
            return inpPeriod;
        }
        double getVolume() {
            return inpVolume;
        }
        ENUM_APPLIED_PRICE getPrice() {
            return inpPrice;
        }
};

class Dewa : public Model {
    protected:
        int dema_handle;
        int waddah_handle;
       
        double _dema_price[];
        double _dema_signal[];

    public:
        // Dewa(void){};
        // ~Dewa(void){};

        virtual bool Init(DewaInputs &modelInputs) {
            string path = "Critiq-Indicators\\GeneralizedDoubleDEMA";

            SetIndexBuffer(1, _dema_signal, INDICATOR_COLOR_INDEX);
            ResetLastError();
            ArraySetAsSeries(_dema_signal, true);
            dema_handle = iCustom(NULL, 0, path,
             modelInputs.getPeriod(), modelInputs.getVolume(), modelInputs.getPrice()
             );
            Print("Dewa Init");
            return true;
        };
        virtual ENUM_ORDER_TYPE GetSignal() {
            CopyBuffer(dema_handle,1,0,5,_dema_signal);
            if(_dema_signal[0] == 1) {
                return ORDER_TYPE_BUY;
            } else if(_dema_signal[0] == 2) 
                return ORDER_TYPE_SELL;
            return false;
        };

};
// extern Dewa *dewa;
// void Dewa::Init(int cPeriod, double cVolume, ENUM_APPLIED_PRICE ePrice) {
//     path = "Critiq-Indicators\\GeneralizedDoubleDEMA";

//     SetIndexBuffer(1, _dema_signal, INDICATOR_COLOR_INDEX);
//     ResetLastError();
//     ArraySetAsSeries(_dema_signal, true);
//     dema_handle = iCustom(NULL, 0, path, cPeriod, cVolume, ePrice);
// }

// ENUM_ORDER_TYPE Dewa::GetSignal() {
//     CopyBuffer(dema_handle,1,0,5,_dema_signal);

//     if(_dema_signal[0] == 1) {
//         return ORDER_TYPE_BUY;
//     } else if(_dema_signal[0] == 2) 
//         return ORDER_TYPE_SELL;

//     return false;
// }