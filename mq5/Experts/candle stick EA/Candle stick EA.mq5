//+------------------------------------------------------------------+
//|                                              Candle stick EA.mq5 |
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
#define  OBJPERFIX  "YM - "

//includes
#include <YM\Utilities\Utilities.mqh>
#include <YM\EXecute\EXecute.mqh>
#include <YM\Position\Position.mqh>
input double xpip             =200;
input double sl               =100;
input double  tp              =100;
input double lot              =0.2;
input long MagicNumber        =2020;
input string comment          ="Yousuf Mesalm";
bool input Use_BreakEven = true;
int input BreakEventPoint = 50;
bool input Use_Trailing = true;
int input TrailingStopPoint = 50;
input int Max_orders=1;

//variable
double startPrice=0;
double buy=0;
double sell=0;
//Objects
CUtilities tool;
CExecute trade(Symbol(),MagicNumber);
CPosition Pos(Symbol(),MagicNumber,GROUP_POSITIONS_ALL);
CPosition BuyPos(Symbol(),MagicNumber,GROUP_POSITIONS_BUYS);
CPosition SellPos(Symbol(),MagicNumber,GROUP_POSITIONS_SELLS);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   startPrice=tool.Bid();
   buy=startPrice+xpip*tool.Pip();
   sell=startPrice-xpip*tool.Pip();
   HLineCreate(0,OBJPERFIX+"buy",0,buy,clrLimeGreen,STYLE_SOLID,2);
   TextCreate(0,OBJPERFIX+"entrybuy",0,TimeCurrent(),buy,"Buy","Arial",10,clrLimeGreen);
   HLineCreate(0,OBJPERFIX+"sell",0,sell,clrRed,STYLE_SOLID,2);
   TextCreate(0,OBJPERFIX+"entrysell",0,TimeCurrent(),sell,"Sell","Arial",10,clrRed);
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
   if(tool.Bid()>=buy)
     {
      if(Pos.GroupTotal()<Max_orders)
         trade.Position(TYPE_POSITION_BUY,lot,sl,tp,SLTP_PIPS,30,comment);
      ObjectDelete(0,OBJPERFIX+"buy");
      ObjectDelete(0,OBJPERFIX+"sell");
      ObjectDelete(0,OBJPERFIX+"entrybuy");
      ObjectDelete(0,OBJPERFIX+"entrysell");
      startPrice=tool.Bid();
      buy=startPrice+xpip*tool.Pip();
      sell=startPrice-xpip*tool.Pip();
      HLineCreate(0,OBJPERFIX+"buy",0,buy,clrLimeGreen,STYLE_SOLID,2);
      TextCreate(0,OBJPERFIX+"entrybuy",0,TimeCurrent(),buy,"Buy","Arial",10,clrLimeGreen);
      HLineCreate(0,OBJPERFIX+"sell",0,sell,clrRed,STYLE_SOLID,2);
      TextCreate(0,OBJPERFIX+"entrysell",0,TimeCurrent(),sell,"Sell","Arial",10,clrRed);

     }
   if(tool.Bid()<=sell)
     {
      if(Pos.GroupTotal()<Max_orders)
         trade.Position(TYPE_POSITION_SELL,lot,sl,tp,SLTP_PIPS,30,comment);
      ObjectDelete(0,OBJPERFIX+"buy");
      ObjectDelete(0,OBJPERFIX+"sell");
      ObjectDelete(0,OBJPERFIX+"entrybuy");
      ObjectDelete(0,OBJPERFIX+"entrysell");
      startPrice=tool.Bid();
      buy=startPrice+xpip*tool.Pip();
      sell=startPrice-xpip*tool.Pip();
      HLineCreate(0,OBJPERFIX+"buy",0,buy,clrLimeGreen,STYLE_SOLID,2);
      TextCreate(0,OBJPERFIX+"entrybuy",0,TimeCurrent(),buy,"Buy","Arial",10,clrLimeGreen);
      HLineCreate(0,OBJPERFIX+"sell",0,sell,clrRed,STYLE_SOLID,2);
      TextCreate(0,OBJPERFIX+"entrysell",0,TimeCurrent(),sell,"Sell","Arial",10,clrRed);

     }
   Traliling();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Create the horizontal line                                       |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="HLine",      // line name
                 const int             sub_window=0,      // subwindow index
                 double                price=0,           // line price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- create a horizontal line
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
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
//+------------------------------------------------------------------+
//| Creating Text object                                             |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // chart's ID
                const string            name="Text",              // object name
                const int               sub_window=0,             // subwindow index
                datetime                time=0,                   // anchor point time
                double                  price=0,                  // anchor point price
                const string            text="Text",              // the text itself
                const string            font="Arial",             // font
                const int               font_size=10,             // font size
                const color             clr=clrRed,               // color
                const double            angle=0.0,                // text slope
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                const bool              back=false,               // in the background
                const bool              selection=false,          // highlight to move
                const bool              hidden=true,              // hidden in the object list
                const long              z_order=0)                // priority for mouse click
  {

//--- reset the error value
   ResetLastError();
//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the object by mouse
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
//+------------------------------------------------------------------+
void Traliling()
  {
   int sell_total = SellPos.GroupTotal();

   int buy_total = BuyPos.GroupTotal();
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < buy_total; i++)
        {
         if(BuyPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((BuyPos.GetStopLoss() < BuyPos.GetPriceOpen() || BuyPos.GetStopLoss() == 0)
                  && tool.Bid() >= (BuyPos.GetPriceOpen() + BreakEventPoint * tool.Pip()))
                 {
                  BuyPos.Modify(BuyPos.GetPriceOpen(), BuyPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing)
              {
               if(tool.Bid() - BuyPos.GetPriceOpen() > tool.Pip() * TrailingStopPoint)
                 {
                  if(BuyPos.GetStopLoss() < tool.Bid() - tool.Pip() * TrailingStopPoint)
                    {
                     double ModfiedSl = tool.Bid() - (tool.Pip() * TrailingStopPoint);
                     BuyPos.Modify(ModfiedSl, BuyPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }

           }
        }
     }
   if(Use_Trailing || Use_BreakEven)
     {
      for(int i = 0; i < sell_total; i++)
        {
         if(SellPos.SelectByIndex(i))
           {

            if(Use_BreakEven)
              {
               if((SellPos.GetStopLoss() > SellPos.GetPriceOpen() || SellPos.GetStopLoss() == 0)
                  && tool.Ask() <= (SellPos.GetPriceOpen() - BreakEventPoint * tool.Pip()))
                 {
                  SellPos.Modify(SellPos.GetPriceOpen(), SellPos.GetTakeProfit(), SLTP_PRICE);
                 }
              }

            if(Use_Trailing)
              {
               if(SellPos.GetPriceOpen() - tool.Ask() > tool.Pip() * TrailingStopPoint)
                 {
                  if(SellPos.GetStopLoss() > tool.Ask() + tool.Pip() * TrailingStopPoint)
                    {
                     double ModfiedSl = tool.Ask() + tool.Pip() * TrailingStopPoint;
                     SellPos.Modify(ModfiedSl, SellPos.GetTakeProfit(), SLTP_PRICE);
                    }
                 }
              }
           }

        }
     }
  }
//+------------------------------------------------------------------+
