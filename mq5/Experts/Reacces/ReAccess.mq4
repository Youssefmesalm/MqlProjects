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
#include  <YM\Execute\Execute.mqh>
#include  <YM\Position\Position.mqh>
#include  <YM\HistoryPosition\HistoryPosition.mqh>
#define Perfix "YM"
// Inputs
input long MagicNumber=2020;
input double volume=0.1;
input double Sl=10;
input double tp=20;
input int PipStep=5;
input int Min=5; // Numbers of minutes to restart Cycle

//variables
int tb=0,ts=0,tt=0;
int signal=0;
double buyPrice=0,sellPrice=0;
datetime StartTime=0;
datetime timeEndBuy=0,timeEndSell=0;
bool first=true;


int password_status = -1;
//objects
CExecute trade(Symbol(),MagicNumber);
CPosition Pos(Symbol(),MagicNumber,GROUP_POSITIONS_ALL);
CPosition BuyPos(Symbol(),MagicNumber,GROUP_POSITIONS_BUYS);
CPosition SellPos(Symbol(),MagicNumber,GROUP_POSITIONS_SELLS);
CHistoryPosition Hist(Symbol(),MagicNumber,GROUP_HISTORY_POSITIONS_ALL);
CUtilities tool;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   StartTime=TimeCurrent();



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
 
      checkClose(tt);
      if(tool.IsNewBar(PERIOD_CURRENT))
        {
         if(ObjectFind(0,Perfix+"- Arrow")>=0)
            ArrowMove(0,Perfix+"- Arrow",TimeCurrent()+2*PeriodSeconds(),tool.Bid());
        }
      if(Pos.GroupTotal()==0&&((TimeCurrent()>timeEndBuy&&TimeCurrent()>timeEndSell)||(first)))
        {
         trade.Position(TYPE_POSITION_BUY,volume,Sl,tp,SLTP_PIPS,30);
         trade.Position(TYPE_POSITION_SELL,volume,Sl,tp,SLTP_PIPS,30);
         tt=Pos.GroupTotal();
         buyPrice=0;
         sellPrice=0;
         first=false;
         timeEndBuy=0;
         timeEndSell=0;
        }

  
  }



//+------------------------------------------------------------------+
void checkClose(int & t)
  {
   int total=Pos.GroupTotal();
   datetime time=0;
   long ticket=-1;
   if(buyPrice>0&&tool.Ask()>=buyPrice)
     {
      trade.Position(TYPE_POSITION_BUY,volume,Sl,tp,SLTP_PIPS,30);
      buyPrice=0;
      timeEndBuy=0;

      t=Pos.GroupTotal();
     }
   if(sellPrice>0&&tool.Bid()<=sellPrice)
     {
      trade.Position(TYPE_POSITION_SELL,volume,Sl,tp,SLTP_PIPS,30);
      t=Pos.GroupTotal();
      timeEndSell=0;
      sellPrice=0;
     }
//some order closed
   if(total!=t&&total>0)
     {
      Hist.SetHistoryRange(StartTime,TimeCurrent());
      int HistTotal=Hist.GroupTotal();
      for(int i= 0; i<HistTotal; i++)
        {
         datetime timeClose=Hist[i].GetTimeClose();
         if(timeClose>time)
           {
            time=timeClose;
            ticket=Hist[i].GetTicket();
           }
        }
      double Profit=Hist[ticket].GetProfit();
      int type=Hist[ticket].GetType();
      double closePrice=Hist[ticket].GetPriceClose();


      if(Profit<0&&type==0)
        {
         if(PipStep==0)
            trade.Position(TYPE_POSITION_SELL,volume,Sl,tp,SLTP_PIPS,30);
         if(PipStep>0)
           {
            sellPrice=tool.Bid()-PipStep*tool.Pip();
            timeEndSell=TimeCurrent()+Min*60;
            Comment(timeEndSell);
           }
         if(ObjectFind(0,Perfix+"- Arrow")>=0)
            ObjectDelete(0,Perfix+"- Arrow");

        }
      else
         if(Profit<0&&type==1)
           {
            if(PipStep==0)
               trade.Position(TYPE_POSITION_BUY,volume,Sl,tp,SLTP_PIPS,30);
            if(PipStep>0)
              {
               buyPrice=tool.Ask()+PipStep*tool.Pip();
               timeEndBuy=TimeCurrent()+Min*60;
               Comment(timeEndBuy);

              }
            if(ObjectFind(0,Perfix+"- Arrow")>=0)
               ObjectDelete(0,Perfix+"- Arrow");
           }
         else
            if(Profit>0&&type==0)
              {
               trade.Position(TYPE_POSITION_BUY,volume,Sl,tp,SLTP_PIPS,30);
               if(ObjectFind(0,Perfix+"- Arrow")>=0)
                  ObjectDelete(0,Perfix+"- Arrow");
               ArrowCreate(0,Perfix+"- Arrow",0,TimeCurrent()+2*PeriodSeconds(),tool.Bid(),233,ANCHOR_BOTTOM,clrLime,STYLE_SOLID,3,false,false);
               signal=1;
              }
            else
               if(Profit>0&&type==1)
                 {
                  trade.Position(TYPE_POSITION_SELL,volume,Sl,tp,SLTP_PIPS,30);
                  if(ObjectFind(0,Perfix+"- Arrow")>=0)
                     ObjectDelete(0,Perfix+"- Arrow");
                  ArrowCreate(0,Perfix+"- Arrow",0,TimeCurrent()+2*PeriodSeconds(),tool.Bid(),234,ANCHOR_BOTTOM,clrRed,STYLE_SOLID,3,false,false);
                  signal=-1;
                 }
      t=Pos.GroupTotal();
     }
  }
//+------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // chart's ID
                 const string            name="Arrow",         // arrow name
                 const int               sub_window=0,         // subwindow index
                 datetime                time=0,               // anchor point time
                 double                  price=0,              // anchor point price
                 const uchar             arrow_code=252,       // arrow code
                 const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor point position
                 const color             clr=clrRed,           // arrow color
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style
                 const int               width=3,              // arrow size
                 const bool              back=false,           // in the background
                 const bool              selection=true,       // highlight to move
                 const bool              hidden=true,          // hidden in the object list
                 const long              z_order=0)            // priority for mouse click
  {
//--- set anchor point coordinates if they are not set
   ChangeArrowEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create an arrow
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return(false);
     }
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the arrow by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//| Move the anchor point                                            |
//+------------------------------------------------------------------+
bool ArrowMove(const long   chart_ID=0,   // chart's ID
               const string name="Arrow", // object name
               datetime     time=0,       // anchor point time coordinate
               double       price=0)      // anchor point price coordinate
  {
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,0,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the arrow code                                            |
//+------------------------------------------------------------------+
bool ArrowCodeChange(const long   chart_ID=0,   // chart's ID
                     const string name="Arrow", // object name
                     const uchar  code=252)     // arrow code
  {
//--- reset the error value
   ResetLastError();
//--- change the arrow code
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,code))
     {
      Print(__FUNCTION__,
            ": failed to change the arrow code! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change anchor type                                               |
//+------------------------------------------------------------------+
bool ArrowAnchorChange(const long              chart_ID=0,        // chart's ID
                       const string            name="Arrow",      // object name
                       const ENUM_ARROW_ANCHOR anchor=ANCHOR_TOP) // anchor type
  {
//--- reset the error value
   ResetLastError();
//--- change anchor type
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor))
     {
      Print(__FUNCTION__,
            ": failed to change anchor type! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
