struct OpenTradeParams {
    ENUM_ORDER_TYPE type;
    double volume;
    double openPrice;
    double slPrice;
    double tpPrice;
};

class RiskModel {
    protected:
        double rpp;
        double posRatio;

        double CalcRPP() {
            return rpp;
        }

    public:
        RiskModel(void);
        ~RiskModel(void);

        void InitRisk(double cRpp, double cPosRatio) {
            rpp = cRpp;
            posRatio = cPosRatio;
        };

        virtual OpenTradeParams CalcTradeParams(ENUM_ORDER_TYPE orderType)=0;

};

RiskModel::RiskModel(void) : rpp(1.0),
                             posRatio(10) {}

RiskModel::~RiskModel(void) {}