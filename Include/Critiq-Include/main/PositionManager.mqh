class PositionManager {

    private: 
        // main 
        double riskPerTrade;
        double SLRatio;
        double TPRatio;
        
        // calculations
        int ATRPeriod;
        int slippage;

        // settings
        double breakEven;
        bool fixedSLTP;

        // misc. 
        datetime lastBarTime;

        // bool NewBar() {
        //     if (lastBarTime < Time[0]) {
        //         lastBarTime = Time[0];
        //         return true; 
        // } else { return false;
        // }
        // }
    public:
    //     this.riskPerTrade = cRiskPerTrade;
    //     this.SLRatio = cSLRatio;
    //     this.TPRatio = cTPRatio;
    //     this.ATRPeriod = cATRPeriod;
    //     this.slippage = cSlippage;
    //     this.lastBarTime = Time[0];
    //     this.openPosition = NULL;
    //     this.breakEven = cBreakEven;
    //     this.fixedSLTP = cfixedSLTP;
    //     this.customSession = cCustomSession;
    //     backtestInfo.setCustomSessionObject(cCustomSession);
    //   }

        ~ PositionManager() {}

};