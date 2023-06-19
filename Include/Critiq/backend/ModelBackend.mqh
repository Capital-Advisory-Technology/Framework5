#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include<Critiq/main/Limits.mqh>
#include <Critiq/main/PositionManager.mqh>

#include <Critiq/main/RiskFunctions.mqh>

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
    // Open position if intraday allowed and no order open
    if (!positionManager.isOrderOpen()) {
        if (limits.intraDayAllowed()) {
            // Print("ModelBackend | OnTick | No order open and intraday allowed ");
            ENUM_ORDER_TYPE signal = model.GetSignal();
            // Print("ModelBackend | OnTick | Signal: ", signal);
            if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) {    
                PositionParams tradeParams = risk.CalcTradeParams(signal);
                positionManager.OrderOpen(tradeParams);
            }
        }

    // Position management     
    } else {
        // Print("ModelBackend | OnTick | Order open ");
        // check for break even, moving stop loss
        bool breakEven = CheckForBreakEven(0.5);
        if(breakEven) {
            Print("ModelBackend | OnTick | CheckForBreakEven | Break even triggered");
        }
        // risk.checkBreakEven();
        // positionManager.checkBreakEven();
        // check for profit zones, partial close
    }

}
