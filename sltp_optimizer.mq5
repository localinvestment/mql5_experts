#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh> CTrade Trade;

input string dbName = "trades.db"; //имя файла бд

input double osl; //стоп лосс
input double otp; //тейк профит

struct NextTrade
{
   datetime time;
   string type;
};

NextTrade trade;
int db;

bool GetNextTrade()
{
   int request = DatabasePrepare( db, StringFormat( "SELECT * FROM TRADEHISTORY WHERE TIME > %d ORDER BY TIME;", TimeCurrent() ) );

   if( DatabaseRead( request ) )
   {
      int timeI;
      string type;
      
      if( DatabaseColumnInteger( request, 0, timeI ) && DatabaseColumnText( request, 1, type ) )
      {
         trade.time = timeI;
         trade.type = type;
     
         return true;
      }
   } 
   
   return false;
}

int OnInit()
{
   db = DatabaseOpen( dbName, DATABASE_OPEN_READWRITE | DATABASE_OPEN_CREATE |DATABASE_OPEN_COMMON );
 
   if( ! GetNextTrade() )
   {
      printf( "Не найдено ни одной сделки." );
      ExpertRemove();
   }

   return( INIT_SUCCEEDED );
}
  
void OnDeinit( const int reason )
{
   DatabaseClose( db );
}

void OnTick()
{
   if( TimeCurrent() >= trade.time )
   {
      double bid = SymbolInfoDouble( _Symbol, SYMBOL_BID );
      double ask = SymbolInfoDouble( _Symbol, SYMBOL_ASK );
      
      if( trade.type == "buy" )
      {
         Trade.Buy( 0.01, NULL, 0.0, bid - osl, bid + otp );
      }
      
      if( trade.type == "sell" )
      {
         Trade.Sell( 0.01, NULL, 0.0, ask + osl, ask - otp );
      }
      
      GetNextTrade();
   }
}
