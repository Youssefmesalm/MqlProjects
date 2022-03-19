//+------------------------------------------------------------------+
//|                                   Copyright 2022, Yousuf Mesalm. |
//|                                    https://www.Yousuf-mesalm.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Yousuf Mesalm."
#property link      "https://www.Yousuf-mesalm.com"
#property link      "https://www.mql5.com/en/users/20163440"
#property description      "Developed by Yousuf Mesalm"
#property description      "https://www.Yousuf-mesalm.com"
#property description      "https://www.mql5.com/en/users/20163440"
#property version   "1.00"
#property strict
#property indicator_chart_window

// Variables
int csv_io_hnd;
MqlTick tick_struct;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   // Create CSV file handle in WRITE mode.
   csv_io_hnd = FileOpen(Symbol() + ".csv", FILE_CSV|FILE_READ|FILE_WRITE|FILE_REWRITE, ',');
   
   // If creation successful, write CSV header, else throw error
   if(csv_io_hnd > 0)
   {
      if(FileSize(csv_io_hnd) <= 5)
         FileWrite(csv_io_hnd,"M1","M5","M15","M30","H1","H4","D1","w1","Mn","bid", "ask", "spread");
         
      // Move to end of file (if it's being written to again)
      FileSeek(csv_io_hnd, 0, SEEK_END);
   }
   else
      Alert("ERROR: Opening/Creating CSV file!");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
   // If CSV file handle is open, write time, bid, ask and spread to it.
   if(csv_io_hnd > 0)
   {
      if(SymbolInfoTick(Symbol(), tick_struct))
      {
         Comment("\n[Darwinex Labs] Tick Data | Bid: " + DoubleToString(tick_struct.bid, Digits) 
         + " | Ask: " + DoubleToString(tick_struct.ask, Digits) 
         + " | Spread: " + StringFormat("%.05f", NormalizeDouble(MathAbs(tick_struct.bid - tick_struct.ask), Digits))
         + "\n\n* Writing tick data to \\MQL4\\Files\\" + Symbol() + ".csv ..."
         + "\n(please remove the indicator from this chart to access CSV under \\MQL4\\Files.)"
         );
         FileWrite(csv_io_hnd,iTime(Symbol(),PERIOD_M1,0),iTime(Symbol(),PERIOD_M5,0),iTime(Symbol(),PERIOD_M15,0),
         iTime(Symbol(),PERIOD_M30,0),iTime(Symbol(),PERIOD_H1,0),iTime(Symbol(),PERIOD_H4,0),iTime(Symbol(),PERIOD_D1,0),
         iTime(Symbol(),PERIOD_W1,0),iTime(Symbol(),PERIOD_MN1,0),DoubleToString(tick_struct.bid,Digits),
                       DoubleToString(tick_struct.ask,Digits), StringFormat("%.05f", NormalizeDouble(MathAbs(tick_struct.bid - tick_struct.ask), Digits)));
      } 
      else
         Print("ERROR: SymbolInfoTick() failed to validate tick."); 
   }
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{  
   // Close CSV file handle if currently open, before exiting.
   if(csv_io_hnd > 0)
      FileClose(csv_io_hnd);
      
   // Clear chart comments
   Comment("");
}