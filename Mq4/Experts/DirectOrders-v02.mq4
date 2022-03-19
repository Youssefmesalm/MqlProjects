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

extern string   General_Settings   = "------< General_Settings >------";
input double Lots =0.1;
input bool UseTP = True;
input int TakeProfit=300;
input bool UseSL = true;
input int StopLoss=200;
input int MagicNumber =121221;
input int Maximum_Order = 10;
input int Order_Step = 30;
extern string   Modify_Settings   = "------< Modify_Settings >------";
input bool HiddenBroker =true;

extern string   Time_SetUP   = "------< Time_SetUP >------";
input bool UseTimeFilter=true;
input string EndTime="23:00";

extern string   Trailing_SetUP   = "------< Trailing_SetUP >------";
extern bool     Use_Trailing     = false;
extern int      TrailingStop     = 100;
extern int      TrailingStep     = 20;

extern string   Close_SetUP   = "------< Close_SetUP >------";
input bool     Use_Close_Profit     = true;
input double Close_USD_profit     = 100.0;
input bool     Use_Close_Loss     = true;
input double Close_USD_Loss     = 100.0;
input bool     Use_Pip_Profit     = false;
input double Close_Pip_profit     = 100.0;
input bool     Use_Pip_Loss     = false;
input double Close_Pip_Loss     = 100.0;

double sl, tp,price,price1;
datetime lasttradetime =0;
int i=0;
double TrailingProfit =0;
double pt = 1;
int pipsmultiplier;
int z,zz;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   if(countOrder() == 0 && StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+EndTime)!=Time[0])
     {


      OrderSend(Symbol(),OP_BUY,Lots,Ask,30,0,0,"",MagicNumber,0,clrBlue);
      OrderSend(Symbol(),OP_SELL,Lots,Bid,30,0,0,"",MagicNumber,0,clrRed);


      for(int i = 0; i<Maximum_Order/2; i++)
        {

         price = Ask+Order_Step*Point;


         OrderSend(Symbol(),OP_BUYSTOP, Lots, price+Order_Step*Point*i,30,0,0,"",MagicNumber,0,clrBlue);

         price = Bid-Order_Step*Point;



         OrderSend(Symbol(),OP_SELLSTOP, Lots, price-Order_Step*Point*i,30,0,0,"",MagicNumber,0,clrRed);

        }
      Modify();
     }
   if(UseTimeFilter && StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+EndTime)==Time[0])
     {
      CloseAllOrders();
     }



   if(Use_Trailing)
     {
      TrailingStopp(Symbol());
     }



   if((Use_Close_Profit &&Close_USD_profit <= winProfitTotal())||(Use_Close_Loss && Close_USD_Loss <= loseProfitTotal()*-1) ||(Use_Pip_Profit && Close_Pip_profit <= winpipprofit())|| (Use_Pip_Loss && Close_Pip_Loss <= losspipprofit()*-1))
     {
      CloseAllOrders();

     }


  }
//+------------------------------------------------------------------+
int countOrder()
  {
   int count =0;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol()&& OrderMagicNumber()== MagicNumber)
        {
         count++;

        }
     }
   return(count);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Time Filter                                                                 |
//+------------------------------------------------------------------+
bool TimeFilter(string ET)
  {

   datetime End   =StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" "+ET);

   if(!(Time[0]>=End) && (Time[0]<=End))
     {
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Close All Orders                                                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllOrders()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),30,White);
           }
         else
            if(OrderType() == OP_SELL)
              {
               OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),30,White);
              }
            else
              {
               OrderDelete(OrderTicket(),White);
              }
        }
     }
  }
//+------------------------------------------------------------------+
void TrailingStopp(string sym)
  {
   for(int i=OrdersTotal()-1; i >= 0; i--)
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderSymbol() == sym && OrderMagicNumber() == MagicNumber)
           {
            double takeprofit = OrderTakeProfit();

            if(OrderType() == OP_BUY && iClose(sym,0,0) - OrderOpenPrice() > TrailingStop*pt*MarketInfo(sym,MODE_POINT))
              {
               if((OrderStopLoss() < iClose(sym,0,0)-(TrailingStop+TrailingStep)*pt*MarketInfo(sym,MODE_POINT)) || (OrderStopLoss()==0))
                 {
                  if(TrailingProfit != 0)
                     takeprofit = iClose(sym,0,0)+(TrailingProfit + TrailingStop)*pt*MarketInfo(sym,MODE_POINT);
                  bool ret1 = OrderModify(OrderTicket(), OrderOpenPrice(), iClose(sym,0,0)-TrailingStop*pt*MarketInfo(sym,MODE_POINT), takeprofit,0, White);
                  if(ret1 == false)
                     Print(" OrderModify() error - , ErrorDescription: ",(GetLastError()));
                 }
              }
            if(OrderType() == OP_SELL && OrderOpenPrice() - iClose(sym,0,0) > TrailingStop*pt*MarketInfo(sym,MODE_POINT))
              {
               if((OrderStopLoss() > iClose(sym,0,0)+(TrailingStop+TrailingStep)*pt*MarketInfo(sym,MODE_POINT)) || (OrderStopLoss()==0))
                 {
                  if(TrailingProfit != 0)
                     takeprofit = iClose(sym,0,0)-(TrailingProfit + TrailingStop)*pt*MarketInfo(sym,MODE_POINT);
                  bool ret2 = OrderModify(OrderTicket(), OrderOpenPrice(),iClose(sym,0,0)+TrailingStop*pt*MarketInfo(sym,MODE_POINT), takeprofit, 0, White);
                  if(ret2 == false)
                     Print("OrderModify() error - , ErrorDescription: ",(GetLastError()));
                 }
              }
           }
        }
      else
         Print("OrderSelect() error - , ErrorDescription: ",(GetLastError()));
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double winProfitTotal()
  {
   double p = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {

         if((OrderProfit()+OrderCommission()+OrderSwap()) > 0)
           {

            p +=OrderProfit()+OrderCommission()+OrderSwap();

           }
        }
     }
   return (p);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double loseProfitTotal()
  {
   double p = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if((OrderProfit()+OrderCommission()+OrderSwap()) < 0)
           {
            p +=OrderProfit()+OrderCommission()+OrderSwap();
           }
        }
     }
   return (p);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Modify()
  {
   if(HiddenBroker == True)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol())
           {
            if((OrderType()==OP_BUY || OrderType()==OP_BUYSTOP)  && OrderMagicNumber()== MagicNumber)
              {
               if(UseSL==True)
                 {
                  sl = OrderOpenPrice()-StopLoss*Point;
                 }
               else
                  if(UseSL==false || StopLoss == 0)
                    {
                     sl=0;
                    }
               if(UseTP==True)
                 {
                  tp = OrderOpenPrice()+TakeProfit*Point;
                 }
               else
                  if(UseTP==false || TakeProfit == 0)
                    {
                     tp=0;
                    }

               OrderModify(OrderTicket(), OrderOpenPrice(), sl,tp, 0, Green);

              }
            if((OrderType()==OP_SELL || OrderType()==OP_SELLSTOP)&& OrderMagicNumber()== MagicNumber)
              {
               if(UseSL==True)
                 {
                  sl = OrderOpenPrice()+StopLoss*Point;
                 }
               else
                  if(UseSL==false || StopLoss == 0)
                    {
                     sl=0;
                    }
               if(UseTP==True)
                 {
                  tp = OrderOpenPrice()-TakeProfit*Point;
                 }
               else
                  if(UseTP==false || TakeProfit == 0)
                    {
                     tp=0;
                    }
               OrderModify(OrderTicket(), OrderOpenPrice(), sl,tp, 0, Green);

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
double losspipprofit()
  {
   double profits;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
            if((OrderProfit()+OrderCommission()+OrderSwap()) < 0)
              {
               profits += OrderProfit()+OrderSwap()+OrderCommission()/GetPPP(OrderSymbol());;
              }
        }
     }

   return(profits);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double winpipprofit()
  {
   double profits;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
            if((OrderProfit()+OrderCommission()+OrderSwap()) > 0)
              {
               profits += OrderProfit()+OrderSwap()+OrderCommission()/GetPPP(OrderSymbol());;
              }
        }
     }

   return(profits);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetPPP(string A)
  {
   double B = (((MarketInfo(A,MODE_TICKSIZE)/MarketInfo(A,MODE_BID))* MarketInfo(A,MODE_LOTSIZE)) * MarketInfo(A,MODE_BID))/10; //For 5 Digit

   return(B);
  }
//+------------------------------------------------------------------+
