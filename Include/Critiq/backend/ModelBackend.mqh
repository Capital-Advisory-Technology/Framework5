#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include<Critiq/main/Limits.mqh>
#include <Critiq/main/PositionManager.mqh>

class ModelBackend {
    protected:
        Risk *risk;
        Model *model;
        Limits *limits;
        
    public:

        ModelBackend(void);
        ~ModelBackend(void);

        void OnTick();
        void setRisk(Risk *cRisk) { risk = cRisk; }
        void setModel(Model *cModel) { model = cModel; }
        void setLimits(Limits *cLimits) { limits = cLimits; }
};

extern ModelBackend *modelBackend;

void ModelBackend::ModelBackend(void) {}
void ModelBackend::~ModelBackend(void) {
    delete risk;
    delete model;
    delete limits;
}

void ModelBackend::OnTick() {
    if (limits.intraDayAllowed()) {
        Print("ModelBackend | OnTick | Intraday allowed ");
        if (!positionManager.isOrderOpen()) {
            Print("ModelBackend | OnTick | No order open ");
            ENUM_ORDER_TYPE signal = model.GetSignal();
            Print("ModelBackend | OnTick | Signal: ", signal);
            if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) {    
                OpenTradeParams tradeParams = risk.CalcTradeParams(signal);
                positionManager.OrderOpen(tradeParams);
            }
        }
    }
}
