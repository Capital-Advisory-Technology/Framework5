#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include<Critiq/main/Limits.mqh>
#include <Critiq/main/ProfitSystem.mqh>
#include <Critiq/main/PositionManager.mqh>
#include <Critiq/common/Structures.mqh>


class ModelBackend {
    protected:
        Risk *risk;
        Model *model;
        Limits *limits;
        ProfitSystem *profitSystem;

    public:

        ModelBackend(void);
        ~ModelBackend(void);

        void OnTick();
        void OnTrade();
        void setRisk(Risk *cRisk) { risk = cRisk; }
        void setModel(Model *cModel) { model = cModel; }
        void setLimits(Limits *cLimits) { limits = cLimits; }
        void setProfitSystem(double cT1, double cT2, double cS1, double cS2, double cBE) {
            profitSystem = new ProfitSystem(cT1, cT2, cS1, cS2, cBE);
        }
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
            ENUM_ORDER_TYPE signal = model.GetSignal();
            if (signal == ORDER_TYPE_BUY || signal == ORDER_TYPE_SELL) { 
                profitSystem.ClearFlags();   
                PositionParams tradeParams = risk.CalcTradeParams(signal);
                positionManager.OrderOpen(tradeParams);
            }
        }

    // Position management     
    } else {
        bool breakEven = profitSystem.BreakEven();
        if(breakEven) {
            Print("ERROR CHECKING");
        }
   
        bool moveStops = profitSystem.MoveStops();
        if(moveStops) {
            Print("ModelBackend | OnTick | Move stops triggered");
        }
        
        bool takePartials = profitSystem.TakePartials();
        if (takePartials) {
            Print("ModelBackend | OnTick | Take partials triggered");
        }
    }

}


void ModelBackend::OnTrade() {
    profitSystem.ClearFlags();
}