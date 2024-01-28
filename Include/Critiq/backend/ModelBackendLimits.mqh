#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include<Critiq/main/Limits.mqh>
#include <Critiq/main/ProfitSystem.mqh>
#include <Critiq/main/PositionManager.mqh>
#include <Critiq/main/OrderFailSafe.mqh>
#include <Critiq/common/Structures.mqh>

// New: Replaced PositionOpen with OrderOpen
// Result: Positions are set rather than executed at market 

class ModelBackendLimit {
    protected:
        Risk *risk;
        Model *model;
        Limits *limits;
        ProfitSystem *profitSystem;
        
        datetime prevBarTime;
        bool isNewBar();

    public:
        ModelBackendLimit(void);
        ~ModelBackendLimit(void);

        void OnTick();
        void setRisk(Risk *cRisk) { risk = cRisk; }
        void setModel(Model *cModel) { model = cModel; }
        void setLimits(Limits *cLimits) { limits = cLimits; }
        void setProfitSystem(double cT1, double cT2, double cS1, double cS2, double cBE) {
            profitSystem = new ProfitSystem(cT1, cT2, cS1, cS2, cBE);
        }
};

extern ModelBackendLimit *ModelBackendLimit;

void ModelBackendLimit::ModelBackendLimit(void) {}
void ModelBackendLimit::~ModelBackendLimit(void) {
    delete risk;
    delete model;
    delete limits;
    delete profitSystem;
    delete positionManager;
    delete orderFailSafe;
}

void ModelBackendLimit::OnTick() {
    if (isNewBar()) {
        // Open position if intraday allowed and no order open
        if (!positionManager.isPositionOpen()) {
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
            bool moveStops = profitSystem.MoveStops();
            bool takePartials = profitSystem.TakePartials();
        }
    }

    // Failed order management
    // Failed open
    if (orderFailSafe.isFailedOpen()) {
        ENUM_ORDER_TYPE signal = orderFailSafe.getFailedOpenType();
        profitSystem.ClearFlags();
        PositionParams tradeParams = risk.CalcTradeParams(signal);
        positionManager.OrderOpen(tradeParams);
    }
    // Failed modify
    if (orderFailSafe.isFailedModify()) {
        double sl = orderFailSafe.getFailedModifySL();
        double tp = orderFailSafe.getFailedModifyTP();
        positionManager.OrderModify(sl, tp);
    }
    // Failed partial close
    if (orderFailSafe.isFailedPartialClose()) {
        double volume = orderFailSafe.getFailedPartialCloseVolume();
        positionManager.OrderPartialClose(volume);
    }
}

bool ModelBackendLimit::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);
    if (barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }
    return false;
}