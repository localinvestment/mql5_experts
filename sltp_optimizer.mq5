#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

input string dbName = "";   //имя файла бд
input double sl;            //стоп лосс
input double tp;            //тейк профит

int db;

int OnInit()
{
   db = DatabaseOpen( dbName, DATABASE_OPEN_READWRITE | DATABASE_OPEN_CREATE |DATABASE_OPEN_COMMON );
   
   if( db == INVALID_HANDLE )
   {
      Print( "DB: ", dbName, " open failed with code ", GetLastError() );
   }

   return( INIT_SUCCEEDED );
}
  
void OnDeinit( const int reason )
{
   DatabaseClose( db );
}

void OnTick()
{

}
