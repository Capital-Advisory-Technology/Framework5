#include <Critiq-Include/common/Structures.mqh>

class HistoryManager {
    protected:
        int lastNHours;
        // Deal deals[];

    public:
        HistoryManager(void);
        ~HistoryManager(void);

        void GetLastNHours(Deal& deals[], int hours);

};

extern HistoryManager *historyManager;

HistoryManager::HistoryManager(void) : lastNHours(0)
{
}

HistoryManager::~HistoryManager(void)
{
}

void HistoryManager::GetLastNHours(Deal& deals[], int hours) {
    lastNHours = hours;
    // Get all deals from last N hours
    // Store them in deals[]
    int dateTo = (int)TimeCurrent();
    int dateFrom = dateTo - (lastNHours * 60 * 60);
    HistorySelect(dateFrom, dateTo);
    
    int total = HistoryDealsTotal();
    Print("Total deals: ", total);
    ulong    ticket=0;
    // ArrayResize(deals, total);
    
    for (int i = total - 1; i >= 0; i--) {
        if((ticket = HistoryDealGetTicket(i)) > 0) {
            Deal deal;
            deal.ticket = ticket;
            deal.order = (int)HistoryDealGetInteger(ticket, DEAL_ORDER);
            deal.symbol = HistoryDealGetString(ticket, DEAL_SYMBOL);
            deal.type = HistoryDealGetInteger(ticket, DEAL_TYPE);
            deal.entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
            deal.price = HistoryDealGetDouble(ticket, DEAL_PRICE);
            deal.volume = HistoryDealGetDouble(ticket, DEAL_VOLUME);
            deal.commission = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
            deal.swap = HistoryDealGetDouble(ticket, DEAL_SWAP);
            deal.profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            deal.fee = HistoryDealGetDouble(ticket, DEAL_FEE);
            deal.slLevel = HistoryDealGetDouble(ticket, DEAL_SL);
            deal.tpLevel = HistoryDealGetDouble(ticket, DEAL_TP);
            deal.magic = (int)HistoryDealGetInteger(ticket, DEAL_MAGIC);
            deal.reason = (int)HistoryDealGetInteger(ticket, DEAL_REASON);
            deal.position_id = (int)HistoryDealGetInteger(ticket, DEAL_POSITION_ID);
            deal.comment = HistoryDealGetString(ticket, DEAL_COMMENT);
            
            ArrayResize(deals, ArraySize(deals) + 1);
            deals[ArraySize(deals) - 1] = deal;
        }

    }
}