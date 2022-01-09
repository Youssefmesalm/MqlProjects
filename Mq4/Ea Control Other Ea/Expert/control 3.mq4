//+------------------------------------------------------------------+
//|                                                    control 3.mq4 |
//|                                     Copyright 2021,Yousuf Mesalm |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Yousuf Mesalm"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


input long MAGIC1=2020;
input long MAGIC2=2021;
input long MAGIC3=2022;
input ENUM_TIMEFRAMES TimeFrame=PERIOD_CURRENT;
long ChartId1,ChartId2,ChartId3;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   ChartId1=ChartOpen(Symbol(),TimeFrame);
   ChartId2=ChartOpen(Symbol(),TimeFrame);
   ChartId3=ChartOpen(Symbol(),TimeFrame);
   ChartApplyTemplate(ChartId1,"EA1.tpl");
   ChartApplyTemplate(ChartId2,"EA2.tpl");
   ChartApplyTemplate(ChartId3,"EA3.tpl");

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   ChartClose(ChartId1);
   ChartClose(ChartId2);
   ChartClose(ChartId3);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(Ea1Pos()>0||Ea2Pos()>0)
     {
      ChartApplyTemplate(ChartId3,"default.tpl");
     }
   if(Ea3Pos()>0)
     {
      ChartApplyTemplate(ChartId1,"default.tpl");
      ChartApplyTemplate(ChartId2,"default.tpl");
     }
   if(OrdersTotal()==0)
     {
      ChartApplyTemplate(ChartId1,"EA1.tpl");
      ChartApplyTemplate(ChartId2,"EA2.tpl");
      ChartApplyTemplate(ChartId3,"EA3.tpl");
     }

  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
int Ea1Pos()
  {
   double p = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC1)
        {

         p ++;


        }
     }
   return (p);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Ea2Pos()
  {
   double p = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC2)
        {

         p ++;


        }
     }
   return (p);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Ea3Pos()
  {
   double p = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGIC3)
        {

         p ++;


        }
     }
   return (p);
  }
//+------------------------------------------------------------------+
