class OrderFailSafe {
    protected:
        bool failedOpen;
        bool failedModify;
        bool failedPartialClose;

        ENUM_ORDER_TYPE failedOpenType;
        double failedModifySL;
        double failedModifyTP;
        double failedPartialCloseVolume;


    public:
        OrderFailSafe(void);
        ~OrderFailSafe(void);

        bool isFailedOpen() { return failedOpen; }
        bool isFailedModify() { return failedModify; }
        bool isFailedPartialClose() { return failedPartialClose; }
        
        void setFailedOpenType(ENUM_ORDER_TYPE type);
        void setFailedModifySLTP(double sl, double tp);
        void setFailedPartialCloseVolume(double volume);

        ENUM_ORDER_TYPE getFailedOpenType();
        double getFailedModifySL();
        double getFailedModifyTP();
        double getFailedPartialCloseVolume();
};

OrderFailSafe *orderFailSafe = new OrderFailSafe;

OrderFailSafe::OrderFailSafe(void) {
    failedOpen = false;
    failedModify = false;
    failedPartialClose = false;

    failedOpenType = ORDER_TYPE_BUY;
    failedModifySL = 0.0;
    failedModifyTP = 0.0;
    failedPartialCloseVolume = 0.0;
}

OrderFailSafe::~OrderFailSafe(void) {}

void OrderFailSafe::setFailedOpenType(ENUM_ORDER_TYPE type) {
    failedOpenType = type;
    failedOpen = true;
}

void OrderFailSafe::setFailedModifySLTP(double sl, double tp) {
    failedModifySL = sl;
    failedModifyTP = tp;
    failedModify = true;
}

void OrderFailSafe::setFailedPartialCloseVolume(double volume) {
    failedPartialCloseVolume = volume;
    failedPartialClose = true;
}

ENUM_ORDER_TYPE OrderFailSafe::getFailedOpenType() {
    failedOpen = false;
    return failedOpenType;
}

double OrderFailSafe::getFailedModifySL() {
    failedModify = false;
    return failedModifySL;
}

double OrderFailSafe::getFailedModifyTP() {
    failedModify = false;
    return failedModifyTP;
}

double OrderFailSafe::getFailedPartialCloseVolume() {
    failedPartialClose = false;
    return failedPartialCloseVolume;
}