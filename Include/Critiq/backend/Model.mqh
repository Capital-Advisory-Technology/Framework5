class ModelInputs {
    protected:
        string modelName;
    
    public:
        virtual void Init() = 0;
};


class Model {
    public:
        virtual bool Init(ModelInputs &modelInputs) = 0;
        virtual ENUM_ORDER_TYPE GetSignal() = 0;
};