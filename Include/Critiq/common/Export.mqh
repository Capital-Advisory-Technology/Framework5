#include <Critiq/common/Json.mqh>

class DataExport {
    protected:
        int db;
        string strategyName;
        int strategyId;
        double stat_values[3];

        void InitDatabase();

        void SelectStrategy();
        void InsertStrategy();

    public:
        DataExport();
        ~DataExport();

        void OnTesterInit(string strategyName);
        void OnTester();
        void OnTesterDeinit();
};

extern DataExport *dataExport = new DataExport;

DataExport::DataExport() {}
DataExport::~DataExport() {}

void DataExport::OnTesterInit(string cStrategyName) {
    strategyName = cStrategyName;
    InitDatabase();
    InsertStrategy();
}

void DataExport::OnTester() {
    double deposit = NormalizeDouble((STAT_INITIAL_DEPOSIT), 2);
    double TotalNetProfit = NormalizeDouble(TesterStatistics(STAT_PROFIT), 2);
    double MaximalDrawdown = NormalizeDouble(MathMax(TesterStatistics(STAT_EQUITY_DD),TesterStatistics(STAT_BALANCE_DD)), 4);
    stat_values[0]=deposit;
    stat_values[1]=TotalNetProfit;
    stat_values[2]=MaximalDrawdown;

    FrameAdd("Statistics", 1, 0, stat_values);
}

void DataExport::OnTesterDeinit() {
    string name ="";  // Public name/frame label
    ulong  pass =0;   // Number of the optimization pass at which the frame is added
    long   id   =0;   // Public id of the frame
    double val  =0.0; // Single numerical value of the frame
    string parameter[];
    uint   parameter_count;

    bool failed = false;
    DatabaseTransactionBegin(db);
    while(FrameNext(pass,name,id,val,stat_values)) {
        if (FrameInputs(pass, parameter, parameter_count)) {
            CJAVal json_inputs;
            string sep = "=";
            ushort uSep;
            uSep = StringGetCharacter(sep, 0);
            
            for (uint i=0; i < parameter_count; i++) {
                string result[];
                StringSplit(parameter[i], uSep, result);
                json_inputs[result[0]] = result[1];
            }

            string query = StringFormat("INSERT INTO backtests (strategy_id, symbol, inputs) VALUES (%d, '%s', '%s')", strategyId, _Symbol, json_inputs.Serialize());
            if(!DatabaseExecute(db, query)) {
                Print("DB: ", " insert backtest failed with code ", GetLastError());
                failed = true;
                break;
            }

            // TODO: get backtest id and insert stats
        }
    }

    if(failed) {
        DatabaseTransactionRollback(db);
        PrintFormat("%s: DatabaseExecute() failed with code %d", __FUNCTION__, GetLastError());
        DatabaseClose(db);
        return;
    }
    
    DatabaseTransactionCommit(db);
    Print("DB: success inserted optimization results!");
    DatabaseClose(db);
}


void DataExport::InitDatabase() {
    db = DatabaseOpen("critiq", DATABASE_OPEN_CREATE | DATABASE_OPEN_READWRITE );
    if (db == INVALID_HANDLE) Print(__FUNCTION__, ": Cannot open database");

    if(!DatabaseTableExists(db, "strategies")) {
        string query = "CREATE TABLE IF NOT EXISTS strategies("
                        "id INTEGER PRIMARY KEY, "
                        "name TEXT NOT NULL, "
                        "UNIQUE(name))";

        if(!DatabaseExecute(db, query)) {
            Print("DB: ", " create table failed with code ", GetLastError());
            DatabaseClose(db);
        }
    }

    if(!DatabaseTableExists(db, "backtests")) {
        string query = "CREATE TABLE backtests("
                        "id INTEGER PRIMARY KEY, "
                        "strategy_id INTEGER NOT NULL, "
                        "symbol TEXT NOT NULL, "
                        "inputs TEXT NOT NULL, "
                        "FOREIGN KEY(strategy_id) REFERENCES strategies(id), "
                        "UNIQUE(inputs, symbol))";
        
        if(!DatabaseExecute(db, query)) {
            Print("DB: ", " create table failed with code ", GetLastError());
            DatabaseClose(db);
        }
    }

    if(!DatabaseTableExists(db, "backtests_stats")) {
        string query = "CREATE TABLE backtests_stats("
                        "id INTEGER PRIMARY KEY, "
                        "backtest_id INTEGER NOT NULL, "
                        "deposit REAL NOT NULL, "
                        "profit REAL NOT NULL, "
                        "max_dd REAL NOT NULL, "
                        "FOREIGN KEY(backtest_id) REFERENCES backtests(id))";
        
        if(!DatabaseExecute(db, query)) {
            Print("DB: ", " create table failed with code ", GetLastError());
            DatabaseClose(db);
        }
    }
}

void DataExport::SelectStrategy() {
    string selectQuery = StringFormat("SELECT id FROM strategies WHERE name = '%s'", strategyName);
    int request=DatabasePrepare(db, selectQuery);
    
    // Obtain the result of the request
    if(request!=INVALID_HANDLE) {
        for(int i=0; DatabaseRead(request); i++) {
            if(!DatabaseColumnInteger(request, 0, strategyId)){
                Print("DB: ", " read strategy id failed with code ", GetLastError());
                DatabaseClose(db);
                return;
            }
        }
    // Handle failed request
    } else {
        Print("DB: ", " request failed with code ", GetLastError());
        DatabaseClose(db);
        return;
    }
}

void DataExport::InsertStrategy() {
    SelectStrategy();
    if(strategyId == 0) {
        string insertQuery = StringFormat("INSERT INTO strategies (name) VALUES ('%s')", strategyName);
        if(!DatabaseExecute(db, insertQuery)) {
            Print("DB: ", " insert strategy failed with code ", GetLastError());
            DatabaseClose(db);
            return;
        }
    }
    SelectStrategy();

    Print("Strategy ID: ", strategyId, " Name: ", strategyName);
}