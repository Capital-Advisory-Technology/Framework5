#include <Critiq/backend/Model.mqh>
#include<Critiq/main/Risk.mqh>
#include<Critiq/main/Limits.mqh>
#include <Critiq/main/ProfitSystem.mqh>
#include <Critiq/main/PositionManager.mqh>
#include <Critiq/common/Structures.mqh>
#include <Critiq/common/OrderFailSafe.mqh>


class ModelBackend {
    protected:
        Risk *risk;
        Model *model;
        Limits *limits;
        ProfitSystem *profitSystem;

        datetime prevBarTime;
        bool isNewBar();

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

ModelBackend::ModelBackend(void) {}
ModelBackend::~ModelBackend(void) {
    delete risk;
    delete model;
    delete limits;
    delete profitSystem;
    delete positionManager;
    delete orderFailSafe;
}

void ModelBackend::OnTick() {
    if (isNewBar()) {
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
            bool moveStops = profitSystem.MoveStops();
            bool takePartials = profitSystem.TakePartials();
        }
    }
    // Check for failed order opens
    int failedOrders = orderFailSafe.getFailedOpenSize();
    if (failedOrders > 0) {
        for (int i = 0; i < failedOrders; i++) {
            ENUM_ORDER_TYPE orderType = orderFailSafe.getFailedOpen(i);
            
            profitSystem.ClearFlags();
            PositionParams tradeParams = risk.CalcTradeParams(orderType);
            positionManager.OrderOpen(tradeParams);
        }
    }

    // Check for failed order modifies
    int failedModifies = orderFailSafe.getFailedModifySize();
    if (failedModifies > 0) {
        for (int i = 0; i < failedModifies; i++) {
            PositionModifyParams params = orderFailSafe.getFailedModify(i);
            positionManager.OrderModify(params.slPrice, params.tpPrice);
        }
    }

    // Check for failed order size outs
    int failedSizeOuts = orderFailSafe.getFailedSizeOutSize();
    if (failedSizeOuts > 0) {
        for (int i = 0; i < failedSizeOuts; i++) {
            double volume = orderFailSafe.getFailedSizeOut(i);
            positionManager.OrderPartialClose(volume);
        }
    }
}


void ModelBackend::OnTrade() {
    profitSystem.ClearFlags();
}

bool ModelBackend::isNewBar() {
    datetime barTime = iTime(_Symbol, _Period, 0);
    if (barTime != prevBarTime) {
        prevBarTime = barTime;
        return true;
    }
    return false;
}