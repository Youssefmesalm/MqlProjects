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
enum CloseOrNo
  {
   CLOSE,
   NO_CLOSE
  };
enum Enum_GridSide
  {
   GridSide_Buy,   //Buy only
   GridSide_Sell,  //Sell only
   GridSide_Both,   //Both alternately
   GridSide_Both_InSame,  //Both in same time
  };

enum Enum_Side
  {
   Side_Buy,
   Side_Sell,
   Side_None
  };
enum TimeAllowed
  {
   AllowedTime,
   NotAllowedTime
  };
enum TradeAllowed
  {
   StopAutoTrading,
   StopEA,
  };

input int Magic1 = 666;                     //Magic
input int Magic2 = 555;                     //Magic
input Enum_GridSide GridSide = GridSide_Buy; //Trade type
input TradeAllowed DisAllowingPattern=StopEA;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int Max_A_ordersCount = 1;             //Max number of orders A type (0 to disable)
input double A_Lots_Size = 0.01;             //A lots size
input double A_Lots_Multiplyer = 1.0;        //A lots multiplyer
input int Average_A_StepPoints = 100;        //Average A step points

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int Max_B_ordersCount = 1;             //Max number of orders B type (0 to disable)
input double B_Lots_Size = 0.01;             //B lots size
input double B_Lots_Multiplyer = 3.0;        //B lots multiplyer
input int Average_B_StepPoints = 200;        //Average B step points

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int Max_C_ordersCount = 10;             //Max number of orders C type (0 to disable)
input double C_Lots_Size = 0.01;             //C lots size
input double C_Lots_Multiplyer = 5.0;        //C lots multiplyer
input int Average_C_StepPoints = 100;        //Average C step points

input int TargetPoints = 5000;                //Target points
input int SlippagePips = 500;                //Slippage
input string Comment = "Finovics EA";        //Comment

input string TimePeriodToLetEaWork = "14:59:45-23:59:59";
input bool BoolToLetEaClosePositions = false;
input string TimeToLetEaClosePositions = "00:00:00";

input double ProfitTargert=8;// P/L Value
input double LossTargert=10000;// S/L Value

int CO_Orders;
double COPL;
datetime CO_Time,XYtime;
int Select,cnt;
int OpenOrders,PendOrders;
double ProfitALL;
bool trade=true;
long StartHour,StartMin,StartSec,StopHour,StopMin,StopSec;
string GM1    = "--------------< Use TestingBuy/ TestingSell for Backtesting>-------------------";//:- For Quick Checking -:
bool TestingBuy=false;
bool TestingSell=false;

#include <WinUser32.mqh>
#import "user32.dll"  // Uncomment This

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetAncestor(int, int);
#define MT4_WMCMD_EXPERTS  33020

#import


long CloseHours, CloseMin, CloseSec;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer

   EventSetTimer(1);
   if(!GlobalVariableCheck("activated"))
     {
      GlobalVariableSet("activated",1);
     }
   SetValuesOfTime();
   SetValuesOfTimeClose();
   EventSetMillisecondTimer(500);


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   CleanUp();

//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(GlobalVariableGet("activated")==0)
      return;
   TimeAllowed timeAllowed = CheckTime();

   if(timeAllowed == AllowedTime)
     {

      if(GridSide!=GridSide_Both_InSame)
        {
         static Enum_Side lastGridSide = Side_None;
         SelectOpenOrders(Magic1).CheckDeleteNonExecutedPending(Magic1);
         SelectOpenOrders(Magic1).ModifyAllSls(lastGridSide,Magic1);

         if(SelectOpenOrders(Magic1).Cum(Magic1) == 0)
           {
            ENUM_ORDER_TYPE newLoopSide;
            if(GridSide==GridSide_Buy)
              {
               newLoopSide=ORDER_TYPE_BUY;
              }
            else
               if(GridSide==GridSide_Sell)
                 {
                  newLoopSide=ORDER_TYPE_BUY;
                 }
               else

                  if(GridSide==GridSide_Both)
                    {
                     if(lastGridSide==Side_Buy)
                       {
                        newLoopSide=ORDER_TYPE_SELL;

                       }
                     else
                        if(lastGridSide==Side_Sell)
                          {
                           newLoopSide=ORDER_TYPE_BUY;
                          }

                    }
            SendInitialMarketOrder(newLoopSide,Magic1);
            lastGridSide = newLoopSide == ORDER_TYPE_BUY ? Side_Buy : Side_Sell;
           }
         SelectOpenOrders(Magic1).CheckSendNextLimit(Magic1);
         if(BoolToLetEaClosePositions)
           {
            if(CheckTimeClose()==CLOSE)
              {
               SelectOpenOrders(Magic1).CheckDeleteNonExecutedPending(Magic1);
               CloseAnyOpenOrder(Magic1);
              }
           }
        }
      else
         if(GridSide==GridSide_Both_InSame)
           {

            SelectOpenOrders(Magic1).CheckDeleteNonExecutedPending(Magic1);
            SelectOpenOrders(Magic1).ModifyAllSls(Side_Buy,Magic1);

            if(SelectOpenOrders(Magic1).Cum(Magic1) == 0)
              {

               SendInitialMarketOrder(ORDER_TYPE_BUY,Magic1);

              }
            SelectOpenOrders(Magic1).CheckSendNextLimit(Magic1);
            if(BoolToLetEaClosePositions)
              {
               if(CheckTimeClose()==CLOSE)
                 {
                  SelectOpenOrders(Magic1).CheckDeleteNonExecutedPending(Magic1);
                  CloseAnyOpenOrder(Magic1);
                 }
              }

            // Sell

            SelectOpenOrders(Magic2).CheckDeleteNonExecutedPending(Magic2);
            SelectOpenOrders(Magic2).ModifyAllSls(Side_Sell,Magic2);

            if(SelectOpenOrders(Magic2).Cum(Magic2) == 0)
              {

               SendInitialMarketOrder(ORDER_TYPE_SELL,Magic2);

              }
            SelectOpenOrders(Magic2).CheckSendNextLimit(Magic2);
            if(BoolToLetEaClosePositions)
              {
               if(CheckTimeClose()==CLOSE)
                 {
                  SelectOpenOrders(Magic2).CheckDeleteNonExecutedPending(Magic2);
                  CloseAnyOpenOrder(Magic2);
                 }
              }

           }





     }



  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
//Print("he");

   int is_allowed=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

   if(is_allowed==1)
     {
      //is_allowed=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

      GlobalVariableSet("activated",1);

      //so user just activated the system, so can go back to normal

     }
   else
     {
      GlobalVariableSet("activated",0);
     }


//------------------------------------------------------------------------------------||

   CO_Orders=0;
   COPL=0;
   CO_Time=0;
   for(cnt=0; cnt<OrdersHistoryTotal(); cnt++)
     {
      Select=OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY);
      if(OrderSymbol()==Symbol() && OrderType()<2)
        {
         CO_Orders++;
         COPL+=(OrderProfit()+OrderSwap()+OrderCommission()) ;
         CO_Time=OrderCloseTime();
        }
     }
//------------------------------------------------------------------------------------------------||


   OpenOrders    = 0;
   PendOrders=0;
   XYtime=0;
   ProfitALL=0;
   for(cnt=0; cnt<OrdersTotal(); cnt++)
     {
      Select=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
        {
         if( //OrderSymbol()==Symbol()&&
            OrderType()<2)
           {
            OpenOrders++;
            ProfitALL+=(OrderProfit() +OrderCommission()+OrderSwap());
           }
        }
     }
//------------------------------------------------------------------------------------------------||
   int ord_send;
   if(OpenOrders==0 && TestingBuy==true)

     {
      ord_send=OrderSend(Symbol(),0,0.1,Ask,100,0,0,"",0,0,clrBlue);

     }

   if(OpenOrders==0 && TestingSell==true)

     {
      ord_send=OrderSend(Symbol(),0,0.1,Ask,100,0,0,"",0,0,clrBlue);

     }


   if(OpenOrders>0&& ProfitALL>=ProfitTargert &&   ProfitTargert)
     {
      GlobalVariableSet("activated",0);
      CloseALL();

      if(DisAllowingPattern==StopAutoTrading)
        {
         if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
           {
            stop_autotrading();
           }

        }
     }

   if(OpenOrders>0&& ProfitALL<=-LossTargert && LossTargert)
     {
      GlobalVariableSet("activated",0);
      CloseALL();

      if(DisAllowingPattern==StopAutoTrading)
        {
         if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
           {
            stop_autotrading();
           }
        }

     }

   if(AccountEquity()>=AccountBalance())
      clr_eq= clrLime;
   else
      clr_eq= clrRed;

   string_window("Balance", 5, 20, 0);  //
   ObjectSetText("Balance","Balance   : " + DoubleToStr(AccountBalance(),2), text_size, "Cambria", color_text);
   ObjectSet("Balance", OBJPROP_CORNER,text_corner);

   string_window("Equity", 5, 40, 0);  //
   ObjectSetText("Equity","Equity     : " + DoubleToStr(AccountEquity(),2), text_size, "Cambria", color_text);
   ObjectSet("Equity", OBJPROP_CORNER, text_corner);

   string_window("Profit", 5, 60, 0);
   ObjectSetText("Profit", "Profit/Loss    : " +DoubleToStr(ProfitALL,2), text_size, "Impact", clr_eq);
   ObjectSet("Profit", OBJPROP_CORNER, text_corner);

   string_window("P/L", 5, 80, 0);
   ObjectSetText("P/L", "Input P/L Value    : " +DoubleToStr(ProfitTargert,2), text_size, "Impact", clrLime);
   ObjectSet("P/L", OBJPROP_CORNER, text_corner);

   string_window("S/L", 5, 100, 0);
   ObjectSetText("S/L", "Input S/L Value    : " +DoubleToStr(LossTargert,2), text_size, "Impact", clrRed);
   ObjectSet("S/L", OBJPROP_CORNER, text_corner);


   return;

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
struct OrderData
  {
public:
   int               Ticket;
   int               Type;
   double            Volume;
   double            OpenPrice;
   int               Magic;
   double            Sl;
   string            Comment;

   void              ModifySl(double newSl)
     {
      if(NormalizeDouble(this.Sl, 8) == NormalizeDouble(newSl, 8))
         return;

      bool sent = OrderModify(this.Ticket, this.OpenPrice, newSl, 0, 0);
     }
   void              DeletePending()
     {
      RefreshRates();

      bool deleted = OrderDelete(this.Ticket);
     }

  };
struct Snapshot
  {
public:
   OrderData         Orders[];

   int               Cum(long magic)
     {

      int cum = 0;
      for(int i = 0; i < ArraySize(Orders); i++)
        {
         if(Orders[i].Magic==magic)
            cum++;
        }
      return cum;

     }
   int               Cum(ENUM_ORDER_TYPE type,long magic)
     {
      int cum = 0;
      for(int i = 0; i < ArraySize(Orders); i++)
        {
         if(Orders[i].Type == type&&Orders[i].Magic==magic)
            cum++;
        }
      return cum;
     }
   double            GetVolumeWeightedAveragePrice(ENUM_ORDER_TYPE marketType,long magic)
     {
      double cum = 0;
      double cumVolume = 0.0;
      for(int i = 0; i < Cum(magic); i++)
        {
         if(Orders[i].Type != marketType)
            continue;

         cum += Orders[i].Volume * Orders[i].OpenPrice;

         cumVolume += Orders[i].Volume;
        }
      return cumVolume == 0 ? 0 : cum / cumVolume;
     }

   void              CheckDeleteNonExecutedPending(long magic)
     {
      if((Cum(ORDER_TYPE_BUY,magic) == 0 && Cum(ORDER_TYPE_BUY_STOP,magic) > 0) || (Cum(ORDER_TYPE_SELL,magic) == 0 && Cum(ORDER_TYPE_SELL_STOP,magic) > 0))
        {
         Orders[0].DeletePending();
        }
     }

   void              CheckSendNextLimit(long magic)
     {
      int step = Cum(magic);

      if(step >= Max_A_ordersCount + Max_B_ordersCount + Max_C_ordersCount)
         return;

      double volume = SelectVolume(step + 1);

      string comment = ToComment(step + 1);

      RefreshRates();

      if(Cum(ORDER_TYPE_BUY,magic) > 0 && Cum(ORDER_TYPE_BUY_STOP,magic) == 0)
        {
         double nextPrice = Orders[ArraySize(Orders) - 1].OpenPrice + SelectDistance(step) * _Point;

         nextPrice = ToNearestTick(MathMax(nextPrice, Ask + _Point));

         int sent = OrderSend(_Symbol, ORDER_TYPE_BUY_STOP, volume, nextPrice, INT_MAX, 0, 0, comment, magic, 0, clrGreen);
        }
      else
         if(Cum(ORDER_TYPE_SELL,magic) > 0 && Cum(ORDER_TYPE_SELL_STOP,magic) == 0)
           {
            double nextPrice = Orders[ArraySize(Orders) - 1].OpenPrice - SelectDistance(step) * _Point;

            nextPrice = ToNearestTick(MathMin(nextPrice, Bid - _Point));

            int sent = OrderSend(_Symbol, ORDER_TYPE_SELL_STOP, volume, nextPrice, INT_MAX, 0, 0, comment, magic, 0, clrRed);
           }
     }
   void              ModifyAllSls(Enum_Side side,long magic)
     {
      double avg = GetVolumeWeightedAveragePrice(side == Side_Buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL,magic);

      double sl = side == Side_Buy ? avg - TargetPoints * _Point : avg + TargetPoints * _Point;

      for(int i = 0; i < Cum(magic); i++)
        {
         Orders[i].ModifySl(ToNearestTick(sl));
        }
     }
  };

//+------------------------------------------------------------------+
TimeAllowed CheckTime()
  {
   datetime CurrentTime = TimeCurrent();
   MqlDateTime currentTimeStr;
   TimeToStruct(CurrentTime,currentTimeStr);


   int CurrentHour = currentTimeStr.hour;
   int CurrentMin = currentTimeStr.min;
   int CurrentSec = currentTimeStr.sec;

   if(CurrentHour>StartHour && CurrentHour < StopHour)
      return AllowedTime;
   if(CurrentHour==StartHour && ((CurrentMin > StartMin && CurrentMin < StopMin) || (CurrentMin == StartMin && CurrentSec > StartSec)))
      return AllowedTime;
   if(CurrentHour==StopHour && (CurrentMin < StopMin || (CurrentMin == StopMin && CurrentSec < StopSec)))
      return AllowedTime;


   return NotAllowedTime;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAnyOpenOrder(long magic)
  {
   for(int i = OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS)&&OrderMagicNumber()==magic&&OrderSymbol()==Symbol())
        {
         if(OrderType()==0)
           {
            if(OrderClose(OrderTicket(),OrderLots(),Bid,5)) {;}
           }
         if(OrderType()==1)
           {
            if(OrderClose(OrderTicket(),OrderLots(),Ask,5)) {;}
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_allowed()
  {
   if(GlobalVariableGet("activated")==0)
      return false;

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CloseOrNo CheckTimeClose()
  {
   datetime CurrentTime = TimeCurrent();
   MqlDateTime currentTimeStr;
   TimeToStruct(CurrentTime,currentTimeStr);


   int CurrentHour = currentTimeStr.hour;
   int CurrentMin = currentTimeStr.min;
   int CurrentSec = currentTimeStr.sec;

   /*if(CurrentHour>=CloseHours)
   {
      if(CurrentHour>CloseHours) return CLOSE;
      if(CurrentHour==CloseHours)
      {
         if(CurrentMin>StopMin) return CLOSE;
         if(CurrentMin==StopMin && CurrentSec > StopSec) return CLOSE;

      }
   }*/
   if(CurrentHour == CloseHours && CurrentMin == CloseMin)
      return CLOSE;
   return NO_CLOSE;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetValuesOfTimeClose()
  {
   string Hours_Mins_Secs_Close[];
   ushort u_charS;
   u_charS = StringGetCharacter(":",0);
   StringSplit(TimeToLetEaClosePositions,u_charS,Hours_Mins_Secs_Close);



   CloseHours = StringToInteger(Hours_Mins_Secs_Close[0]);
   CloseMin = StringToInteger(Hours_Mins_Secs_Close[1]);
   CloseSec = StringToInteger(Hours_Mins_Secs_Close[2]);

  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetValuesOfTime()
  {
   string Open_Close[];
   ushort u_charB;
   u_charB = StringGetCharacter("-",0);
   StringSplit(TimePeriodToLetEaWork,u_charB,Open_Close);

   string Hours_Mins_Secs_Start[],Hours_Mins_Secs_Stop[];
   ushort u_charS;
   u_charS = StringGetCharacter(":",0);
   StringSplit(Open_Close[0],u_charS,Hours_Mins_Secs_Start);
   StringSplit(Open_Close[1],u_charS,Hours_Mins_Secs_Stop);

   StartHour = StringToInteger(Hours_Mins_Secs_Start[0]);
   StartMin = StringToInteger(Hours_Mins_Secs_Start[1]);
   StartSec = StringToInteger(Hours_Mins_Secs_Start[2]);

   StopHour = StringToInteger(Hours_Mins_Secs_Stop[0]);
   StopMin = StringToInteger(Hours_Mins_Secs_Stop[1]);
   StopSec = StringToInteger(Hours_Mins_Secs_Stop[2]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ToNearestTick(double price)
  {
   return TickSize() * (int)MathRound(price / TickSize());
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double TickSize()
  {
   return SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ToValidVolume(double freeVolume)
  {
   double _minlot    = MarketInfo(_Symbol, MODE_MINLOT);
   double _maxlot    = MarketInfo(_Symbol, MODE_MAXLOT);
   double _lotstep   = MarketInfo(_Symbol, MODE_LOTSTEP);

   double _lot = MathMin(_maxlot, MathMax(_minlot, MathRound(freeVolume / _lotstep) * _lotstep));

   return _lot;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderData CopySelected()
  {
   OrderData result;

   result.Ticket = OrderTicket();
   result.Type = OrderType();
   result.Volume = OrderLots();
   result.OpenPrice = OrderOpenPrice();
   result.Magic = OrderMagicNumber();
   result.Sl = OrderStopLoss();
   result.Comment = OrderComment();

   return result;
  }
//+------------------------------------------------------------------+
Snapshot SelectOpenOrders(long magic)
  {
   Snapshot result;

   int total = OrdersTotal();

   ArrayResize(result.Orders, total);

   int n = 0;

   for(int i = 0; i < total; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == _Symbol && OrderMagicNumber() == magic)
        {
         int ticket = OrderTicket();

         int k = n;

         if(n != 0 && ticket < result.Orders[n - 1].Ticket)
           {
            result.Orders[n - 1] = result.Orders[n];

            k = n - 1;
           }

         result.Orders[k] = CopySelected();

         n++;
        }
     }
   ArrayResize(result.Orders, n);

   return result;
  }

//+------------------------------------------------------------------+
string ToComment(int step)
  {
   string letter
      = step <= Max_A_ordersCount                     ? "A"
        : step <= Max_A_ordersCount + Max_B_ordersCount ? "B"
        : "C";

   int number
      = step <= Max_A_ordersCount                     ? step
        : step <= Max_A_ordersCount + Max_B_ordersCount ? step - Max_A_ordersCount
        : step - Max_A_ordersCount - Max_B_ordersCount;

   return Comment + " " + letter + IntegerToString(number);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SendInitialMarketOrder(ENUM_ORDER_TYPE type,long magic)
  {
   RefreshRates();

   int ticket = -1;

   if(!is_allowed())
      return false;

   if(type == ORDER_TYPE_BUY)
     {
      ticket = OrderSend(_Symbol, ORDER_TYPE_BUY, SelectVolume(1), Ask, SlippagePips, ToNearestTick(Bid-TargetPoints * _Point), 0, ToComment(1), magic, 0, clrGreen);
     }
   else
     {
      ticket = OrderSend(_Symbol, ORDER_TYPE_SELL, SelectVolume(1), Bid, SlippagePips, ToNearestTick(Ask + TargetPoints * _Point), 0, ToComment(1), magic, 0, clrRed);
     }
   return ticket > 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SelectDistance(int currentStep)
  {
   return
      currentStep < Max_A_ordersCount                     ? Average_A_StepPoints
      : currentStep < Max_A_ordersCount + Max_B_ordersCount ? Average_B_StepPoints
      : Average_C_StepPoints;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SelectVolume(int sendingStep)
  {
   double freeVolume
      = sendingStep <= Max_A_ordersCount                       ? A_Lots_Size * A_Lots_Multiplyer
        : sendingStep <= Max_A_ordersCount + Max_B_ordersCount   ? B_Lots_Size * B_Lots_Multiplyer
        : C_Lots_Size * C_Lots_Multiplyer;

   return ToValidVolume(freeVolume);
  }

//+------------------------------------------------------------------+

//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK||
void CleanUp()
  {
   ObjectDelete("Profit");
   ObjectDelete("Equity");
   ObjectDelete("Balance");
   ObjectDelete("S/L");
   ObjectDelete("P/L");
   ObjectDelete("TimeCO");
   ObjectDelete("expiredlabel");
   ObjectDelete("Contact_Me");

   return;
  }
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK||
int string_window(string n, int xoff, int yoff, int WindowToUse)
  {
   ObjectCreate(n, OBJ_LABEL, WindowToUse, 0, 0);
   ObjectSet(n, OBJPROP_XDISTANCE, xoff);
   ObjectSet(n, OBJPROP_YDISTANCE, yoff);
   ObjectSet(n, OBJPROP_BACK, true);
   return (0);
  }
//KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK||


//----------------------------------------------------------------------------------------||
int CloseOrder;
datetime Server_Time ;
string Time_Servs ;
void CloseALL()
  {
   for(cnt=OrdersTotal()-1; cnt>=0; cnt--)
     {
      Select= OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      //if (OrderSymbol()==Symbol() && OrderMagicNumber() == Magic_Number)
      //{
      if(OrderType()<2)
        {
         CloseOrder=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),1000,clrRed);
         Server_Time = TimeCurrent();
         Time_Servs =TimeToStr(Server_Time,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
         string_window("TimeCO", 5, 120, 0);
         ObjectSetText("TimeCO", "Close Time : " +TimeToString(Server_Time)
                       , text_size, "Impact", clrYellow);
         ObjectSet("TimeCO", OBJPROP_CORNER, text_corner);

        }

      if(OrderType()>=2)
        { CloseOrder=OrderDelete(OrderTicket(),clrRed); }

      //}
     }
  }
//----------------------------------------------------------------------------------------||
input ENUM_BASE_CORNER text_corner=1;
input int text_size=12;
input color color_text= clrWhite;
color clr_eq;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stop_autotrading()
  {
   int main = GetAncestor(WindowHandle(Symbol(), Period()), 2/*GA_ROOT*/);   // Uncomment This

   PostMessageA(main, WM_COMMAND,  MT4_WMCMD_EXPERTS, 0) ;   // Uncomment This
  }

//+------------------------------------------------------------------+
