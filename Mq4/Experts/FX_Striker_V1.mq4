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
#define R3_NAME "Daily R3"
#define R2_NAME "Daily R2"
#define R1_NAME "Daily R1"
#define PIVOT_NAME "Daily PP"
#define S1_NAME "Daily S1"
#define S2_NAME "Daily S2"
#define S3_NAME "Daily S3"
enum tpmode{
TPMode1,//Res/Sup1
TPMode2,//Res/Sup2
TPMode3,//Res/Sup3
FixTP//Fix Take Profit
};
enum sellsl{
SPointSL,//Fix Stop Loss
ResLevel1,//Resistance1
ResLevel2,//Resistance2
ResLevel3//Resistance3
};
enum buysl{
BPointSL,//Fix Stop Loss
SupLevel1,//Support1
SupLevel2,//Support2
SupLevel3//Support3
};
enum lpmode{
Strategy1,
Strategy2,
Strategy3
};
extern string Set0 = "-------General Setting------";//General Setting
extern bool   Allow_Multi_Trade = false;//Allow Multiple Trade
extern buysl  Buy_SL_Mode  = SupLevel3;//Buy SL Mode
extern sellsl Sell_SL_Mode = ResLevel3;//Sell SL Mode
extern int    StopLoss   = 0;//Fix Stop Loss(0 means disable)
extern int    TakeProfit = 100;//Fix Take Profit(0 means disable)
extern lpmode StrategyType    = Strategy3;//Strategy Type
extern double LotSize1 = 0.01;//1st Trade Lot Size
extern tpmode TakeProfitMode1 = TPMode1;//1st Trade Take Profit
//...
extern double LotSize2 = 0.01;//2nd Trade Lot Size
extern tpmode TakeProfitMode2 = TPMode2;//2nd Trade Take Profit
//...
extern double LotSize3 = 0.01;//3th Trade Lot Size
extern tpmode TakeProfitMode3 = TPMode3;//3th Trade Take Profit
//...
extern bool   TrailEnable     = true;//Trail Base On Levels
extern int    TrailPercent    = 70;//Trail % For 3th level
extern int    MagicNumber = 123;//Magic Number
extern bool   Close_By_Reverse_Signal = false;//Close By Reverse Signal
extern string MSet = "-----Moving Setting------";
extern int    MAPeriod1             = 8;//Moving Period1
extern ENUM_APPLIED_PRICE MAPrice1  = PRICE_CLOSE;//Applied Price1
extern ENUM_MA_METHOD     MAMethod1 = MODE_SMA;//MA Method1
//...
extern int    MAPeriod2             = 39;//Moving Period2
extern ENUM_APPLIED_PRICE MAPrice2  = PRICE_CLOSE;//Applied Price2
extern ENUM_MA_METHOD     MAMethod2 = MODE_SMA;//MA Method2
extern string PSet = "-----Pivot Setting------";
extern int ShiftHrs = 5;   // Pivot day shift
extern bool  ShowLine        = true;
extern bool  ShowText        = true;
extern int   FontSize        = 8;
extern color SupportColor    = clrGreen;//Support Level Color
extern color ResistanceColor = clrRed;//Resistance Level Color
extern color PivotColor      = clrGray;//Pivot Level Color
extern color FontColor       = clrGray;
enum ptype{BUYSTOP,BUYLIMIT,SELLSTOP,SELLLIMIT};
string Dash_Set         = "GUI Setting";//GUI Setting
int    Graphic_HPos     = 20;//Graphic Horizental Position
int    Graphic_VPos     = 20;//Graphic Vertical Position
int    Graphic_HSize    = 200;//Graphic Horizental Size
int    Graphic_VSize    = 170;//Graphic Vertical Size
color  DDBGColor        = clrWhiteSmoke;//Drop Down BG Color
string Font             = "Arial Bold";//Font
color  PanelBGColor     = clrLavender;//Panel BG Color
int    row              = 25;//Row Distance
string   datainfo[5];
double FirstTP = 0;
//+----------------------Local variable------------------------------+
//Hello this is new change
datetime LastTime;
int      Trend=2;
//+------------------------------------------------------------------+
// Input(s)
                           // positive value moves pivot day earlier

// Buffers for levels
double Res3[],Res2[],Res1[],Pivot[],Sup1[],Sup2[],Sup3[];

double PDayHigh,PDayLow;
string ThisSymbol;
datetime BarTime,PivotDayStartTime;
int VisibleBars,DayStartBar,LeftMostBar,RightMostBar;
double BuyFirstTP  = 0;
double BuySecondTP = 0;
double BuyThirdTP  = 0;
//...
double SellFirstTP  = 0;
double SellSecondTP = 0;

double SellThirdTP  = 0;
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int OnInit()
  {
//---
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
 Comment("");
//---
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      if(LastTime!=Time[1])
       {
         Trend=2;
         LastTime=Time[1];
         DoPivot();
         CheckSignal(Symbol());
         //Comment("Buy first : "+BuyFirstTP+" | Buy second : "+BuySecondTP);
         GetOrder(Symbol(),LotSize1);                     
       }    
      DoTrail();       
//---
  }
//+------------------------------------------------------------------+
int GetOrder(string sym,double lot)
  {
      double SL=0;
      double TP=0;
      int    Ticket=0;
      int    TT = TotalOrder(0,sym)+TotalOrder(1,sym);
      if(Trend==0 && (TT==0 || Allow_Multi_Trade==true))
      if(Ask<BuySecondTP)
       {
         if(Buy_SL_Mode==BPointSL)
         if(StopLoss>0)
          SL = Ask-StopLoss*_Point;  
         //...
         if(Buy_SL_Mode==SupLevel1)
          SL = SellFirstTP;
         if(Buy_SL_Mode==SupLevel2)
          SL = SellSecondTP;
         if(Buy_SL_Mode==SupLevel3)
          SL = SellThirdTP;                    
         //...
         if(TakeProfit>0)
          TP=Ask+TakeProfit*_Point;  
         //...
         //TP = BuyFirstTP;
         double TP1=0;
         double TP2=0;
         double TP3=0;
         //...
         if(TakeProfitMode1==TPMode1) 
          {        
            TP1 = BuyFirstTP;
          }
         if(TakeProfitMode2==TPMode2)         
          TP2 = BuySecondTP;
         if(TakeProfitMode3==TPMode3)         
          TP3 = BuyThirdTP;     
         //...
         if(TakeProfitMode1==FixTP)
          TP1 = TP;    
         if(TakeProfitMode2==FixTP)
          TP2 = TP;    
         if(TakeProfitMode3==FixTP)
          TP3 = TP;                        
         //...
         if(TP1>200000)
          TP1 = TP;
         if(TP2>200000)
          TP2 = TP;
         if(TP3>200000)
          TP3 = TP;                    
         //...           
         if(Validity(sym,LotValidity(sym,lot),OP_BUY,Ask,SL,TP)==true)
          {
            if(StrategyType==Strategy1)
             {
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize1),Ask,0,SL,TP1,"_1st",MagicNumber,0,clrBlue);          
             }
            if(StrategyType==Strategy2)
             {
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize1),Ask,0,SL,TP1,"_2nd",MagicNumber,0,clrBlue);
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize2),Ask,0,SL,TP2,"_3th",MagicNumber,0,clrBlue);                              
             }
            if(StrategyType==Strategy3)
             {
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize1),Ask,0,SL,TP1,"_1st",MagicNumber,0,clrBlue);                         
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize2),Ask,0,SL,TP2,"_2nd",MagicNumber,0,clrBlue);
               Ticket=OrderSend(sym,OP_BUY,LotValidity(sym,LotSize3),Ask,0,SL,TP3,"_3th",MagicNumber,0,clrBlue);                              
             }
          }
       }
      //...
      if(Trend==1 && (TT==0 || Allow_Multi_Trade==true))
      if(Bid>SellSecondTP)      
       {
         if(Sell_SL_Mode==SPointSL)
         if(StopLoss>0)
          SL=Bid+StopLoss*_Point;  
         //...
         if(Sell_SL_Mode==ResLevel1)
          SL = BuyFirstTP;
         if(Sell_SL_Mode==ResLevel2)
          SL = BuySecondTP;
         if(Sell_SL_Mode==ResLevel3)
          SL = BuyThirdTP;                    
         //...         
         if(TakeProfit>0)
          TP=Bid-TakeProfit*_Point;
         //...
         //TP = SellFirstTP;
         double TP1=0;
         double TP2=0;
         double TP3=0;
         if(TakeProfitMode1==TPMode1)         
          TP1 = SellFirstTP;
         if(TakeProfitMode2==TPMode2)         
          TP2 = SellSecondTP;
         if(TakeProfitMode3==TPMode3)         
          TP3 = SellThirdTP;     
         //... 
         if(TakeProfitMode1==FixTP)
          TP1 = TP;    
         if(TakeProfitMode2==FixTP)
          TP2 = TP;    
         if(TakeProfitMode3==FixTP)
          TP3 = TP;                        
         //...     
         if(TP1>200000)
          TP1 = TP;
         if(TP2>200000)
          TP2 = TP;
         if(TP3>200000)
          TP3 = TP;                    
         //...                        
         if(Validity(sym,LotValidity(sym,lot),OP_SELL,Bid,SL,TP)==true)         
          {
            if(StrategyType==Strategy1)          
             Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize1),Bid,0,SL,TP1,"_1st",MagicNumber,0,clrRed);  
            if(StrategyType==Strategy2)
             {
                Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize1),Bid,0,SL,TP1,"_2nd",MagicNumber,0,clrRed);  
                Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize2),Bid,0,SL,TP2,"_3th",MagicNumber,0,clrRed);                            
             }
            if(StrategyType==Strategy3)            
             {
               Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize1),Bid,0,SL,TP1,"_1st",MagicNumber,0,clrRed);               
               Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize2),Bid,0,SL,TP2,"_2nd",MagicNumber,0,clrRed);               
               Ticket=OrderSend(sym,OP_SELL,LotValidity(sym,LotSize3),Bid,0,SL,TP3,"_3th",MagicNumber,0,clrRed);                                             
             }
          }
       }
      return(Ticket);
  }
//+------------------------------------------------------------------+
double LotValidity(string sym,double L)
  {
      if(L>MarketInfo(sym,MODE_MAXLOT))
       L = MarketInfo(sym,MODE_MAXLOT);
      if(L<MarketInfo(sym,MODE_MINLOT))
       L = MarketInfo(sym,MODE_MINLOT);       
      return(L);      
  }
//+------------------------------------------------------------------+
int TotalOrder(int T, string sym)
  {
   int C=0;
   for(int i=0; i<=OrdersTotal(); i++)
    if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
     if((OrderType()==T|| T==6) && OrderMagicNumber()==MagicNumber && OrderSymbol()==sym)
      C++;
    return(C);
  }
//+------------------------------------------------------------------+
void CloseAll(int T, string sym)
  {
      bool Check=false;
      for(int j=0; j<=3; j++)
       for(int i=0; i<=OrdersTotal(); i++)
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if((OrderType()==T|| T==6) && OrderMagicNumber()==MagicNumber && OrderSymbol()==sym)
          Check=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),5,clrGold);
  }
//+------------------------------------------------------------------+
void DeleteAll(int T, string sym)
  {
      bool Check=false;
      for(int j=0; j<=3; j++)
       for(int i=0; i<=OrdersTotal(); i++)
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if((OrderType()==T|| T==6) && OrderMagicNumber()==MagicNumber && OrderSymbol()==sym)
          Check=OrderDelete(OrderTicket(),clrGreen);
  }
//+------------------------------------------------------------------+
double TotalProfit(string sym)
   {
      double P=0;
      for(int i=0; i<=OrdersTotal(); i++)
       if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        if(OrderType()<=1 && OrderMagicNumber()==MagicNumber && OrderSymbol()==sym)
         P+=OrderProfit()+OrderCommission()+OrderSwap();
      //---
      return(P);
   }
//+------------------------------------------------------------------+
bool Validity(string sym, double lot, int type, double entry, double sl, double tp)
  {
//---
      if(AccountFreeMarginCheck(sym,type,lot)<0)
       {
         Print("Not Enough Free Margin!");
         return(false);
       }
//---
      if(lot<MarketInfo(sym,MODE_MINLOT) || lot>MarketInfo(sym,MODE_MAXLOT))  
       {
         Print("Lot Size is not in range");
         return(false);
       }
//---
      int SLDiss = int(MathAbs((entry-sl)*MathPow(10,int(MarketInfo(sym,MODE_DIGITS)))));
      int TPDiss = int(MathAbs((entry-tp)*MathPow(10,int(MarketInfo(sym,MODE_DIGITS)))));      
      if(SLDiss<MarketInfo(sym,MODE_STOPLEVEL) || TPDiss<MarketInfo(sym,MODE_STOPLEVEL))
       {
         Print("SL Or TP is closer than valid stop level");
         return(false);
       }
//---
      if(IsConnected()==false && IsTesting()==false)
       {
         Print("Termianl Connection Error");
         return(false);
       }
//---
      if(IsTradeAllowed()==false && IsTesting()==false)
       {
         Print("Automatic Trading Permission Error");
         return(false);       
       }
//---
      if(IsTradeContextBusy()==true && IsTesting()==false)
       {
         Print("Broker Is Busy");
         return(false);       
       }
//---
      return(true);
  }
//+------------------------------------------------------------------+  
int PlacePending(string sym, int type, double price,double lot)
  {
//---
      price = NormalizeDouble(price,int(MarketInfo(sym,MODE_DIGITS)));      
      double sl = 0;
      double tp = 0;
      double point = MarketInfo(sym,MODE_POINT);
      color  cl = clrBlue;
      if(type==0 || type==2 || type==4)
       {
         cl = clrBlue;
         if(StopLoss>0)
          sl = price-StopLoss*point;
         if(TakeProfit>0)
          tp = price+TakeProfit*point;          
       }
//---  
      if(type==1 || type==3 || type==5)
       {
         cl = clrRed;       
         if(StopLoss>0)
          sl = price+StopLoss*point;
         if(TakeProfit>0)
          tp = price-TakeProfit*point;          
       }
//---
      int Ticket = -1;
      Ticket = OrderSend(sym,type,LotValidity(sym,lot),price,0,sl,tp,"Pending",MagicNumber,0,cl);
//---
      return(Ticket);
  }
//+------------------------------------------------------------------+ 
bool StopLevelValidity(string sym, double entry, double sl, double tp)
  {
//---
      RefreshRates();
      double bid = MarketInfo(sym,MODE_BID);
      double ask = MarketInfo(sym,MODE_ASK);
      double stoplevel = MarketInfo(sym,MODE_STOPLEVEL);
      double spread = MarketInfo(sym,MODE_SPREAD);
      if(DiffPrice(bid,entry,sym)<spread || DiffPrice(bid,entry,sym)<stoplevel)
       return(false);
      if(sl>0)      
      if(DiffPrice(bid,sl,sym)<spread || DiffPrice(bid,sl,sym)<stoplevel)
       return(false);
      if(tp>0)       
      if(DiffPrice(bid,tp,sym)<spread || DiffPrice(bid,tp,sym)<stoplevel)
       return(false);              
//---  
      return(true);
  }
//+------------------------------------------------------------------+
double DiffPrice(double price1, double price2, string sym)
  {
//---
      double diff = MathAbs((price1-price2)*MathPow(10,MarketInfo(sym,MODE_DIGITS)));
//---  
      return(diff);
  }
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
void MakePanel()
  {
//---
       UpgradeDataInfo();
       string lablestext[5]  = {"...","...","...","...","..."};       
       color  lablecolors[5] = {clrRed,clrBlue,clrGreen,clrYellow,clrOrange};
       MakeBackGround("BG",Graphic_HPos,Graphic_VPos,Graphic_HSize,Graphic_VSize,PanelBGColor,0,true);
       MakeGroupLable(lablestext,lablecolors,CORNER_LEFT_UPPER,Graphic_HPos,Graphic_VPos,"");
       UpgradeDataInfo();       
//---  
  }
//+------------------------------------------------------------------+
void MakeBackGround(string name, int hpos, int vpos, int hsize, int vsize, color cl, int zorder, bool select)
  {
//---
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_RECTANGLE_LABEL,0,0,0);
      ObjectSet(name,OBJPROP_XDISTANCE,hpos);
      ObjectSet(name,OBJPROP_YDISTANCE,vpos);
      ObjectSet(name,OBJPROP_XSIZE,hsize);
      ObjectSet(name,OBJPROP_YSIZE,vsize);
      ObjectSet(name,OBJPROP_BGCOLOR,cl);
      ObjectSet(name,OBJPROP_SELECTABLE,select);
      ObjectSet(name,OBJPROP_BORDER_COLOR,clrBlack);
      ObjectSet(name,OBJPROP_BORDER_TYPE,BORDER_SUNKEN);
//---  
  }
//+------------------------------------------------------------------+
void MakeButton(string name, string text, int fontsize, int hpos, int vpos, int hsize, int vsize, color cl, color fontcl, bool select, string font)
  {
//---
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_BUTTON,0,0,0);
      ObjectSet(name,OBJPROP_XDISTANCE,hpos);
      ObjectSet(name,OBJPROP_YDISTANCE,vpos);
      ObjectSet(name,OBJPROP_XSIZE,hsize);
      ObjectSet(name,OBJPROP_YSIZE,vsize);
      ObjectSet(name,OBJPROP_BGCOLOR,cl);      
      TextSetFont(name,fontsize,FONT_STRIKEOUT,FW_BLACK);
      ObjectSetText(name,text,fontsize,font,fontcl);            
      ObjectSet(name,OBJPROP_COLOR,fontcl);
      ObjectSet(name,OBJPROP_SELECTABLE,select);
//---  
  }
//+------------------------------------------------------------------+
void MakeDropDown(string name, string text, string &item[], color cl, int hpos, int vpos, int hsize, int vsize, bool DDStatus)
  {
//---
      int i = 0;
      MakeButton(name,text,10,hpos,vpos,hsize,22,cl,clrBlack,false,Font);
      MakeLable(name+"arrow",CharToString(218),"WingDings",10,hpos+hsize-15,vpos+2,clrBlack,CORNER_LEFT_UPPER);
      if(DDStatus==true)
       {
         MakeBackGround(name+"List",hpos+2,vpos+20,hsize-1,row*ArraySize(item)+5,cl,1,false);
         for(i=0; i<ArraySize(item); i++)
          MakeLable(name+"Lable"+IntegerToString(i),item[i],Font,8,hpos+5,(vpos+5)+((i+1)*row),clrBlack,CORNER_LEFT_UPPER);
       }
      else
       {
         ObjectDelete(ChartID(),name+"List");
         for(i=0; i<ArraySize(item); i++)
          ObjectDelete(ChartID(),name+"Lable"+IntegerToString(i));         
       }
//---  
  }
//+------------------------------------------------------------------+
void MakeLable(string name, string text, string font, int fontsize, int hpos, int vpos, color cl, ENUM_BASE_CORNER corner)
  {
//---
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_LABEL,0,0,0);
      ObjectSetText(name,text,fontsize,font,cl);              
      ObjectSet(name,OBJPROP_XDISTANCE,hpos);
      ObjectSet(name,OBJPROP_YDISTANCE,vpos);
      ObjectSet(name,OBJPROP_COLOR,cl);      
      ObjectSet(name,OBJPROP_CORNER,corner);
      ObjectSet(name,OBJPROP_SELECTABLE,false);
      TextSetFont(name,fontsize,FONT_STRIKEOUT,FW_BLACK);
//---  
  }
//+------------------------------------------------------------------+
void DrawVLine(string name, datetime time, color cl)
  {
//---
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_VLINE,0,time,0);
      ObjectSet(name,OBJPROP_COLOR,cl);      
//---  
  }
//+------------------------------------------------------------------+
void MakeEditBox(string name, string lable, string value, int hpos, int vpos, int hsize, int vsize, int fontsize, string font, color cl)
  {
//---
      ObjectCreate(ChartID(),name,OBJ_EDIT,0,0,0);
      ObjectSet(name,OBJPROP_XDISTANCE,hpos);
      ObjectSet(name,OBJPROP_YDISTANCE,vpos);
      ObjectSet(name,OBJPROP_XSIZE,hsize);
      ObjectSet(name,OBJPROP_YSIZE,vsize);
      ObjectSet(name,OBJPROP_BGCOLOR,clrWhite);
      ObjectSet(name,OBJPROP_COLOR,cl);
      ObjectSet(name,OBJPROP_ALIGN,ALIGN_CENTER);
      ObjectSetText(name,value,fontsize,font,cl);
//---
      if(StringLen(value)>0)
       {
         MakeButton(name+"btnup","",10,hpos+hsize+1,vpos-2,15,12,clrWhiteSmoke,clrBlack,false,Font);         
         MakeButton(name+"btndn","",10,hpos+hsize+1,vpos+10,15,12,clrWhiteSmoke,clrBlack,false,Font);
         MakeLable(name+"up",CharToString(217),"WingDings",10,hpos+hsize+1,vpos-3,clrBlack,CORNER_LEFT_UPPER);       
         MakeLable(name+"dn",CharToString(218),"WingDings",10,hpos+hsize+1,vpos+6,clrBlack,CORNER_LEFT_UPPER);  
       }
      if(StringLen(lable)>0)
       MakeLable(name+"lable",lable,Font,10,hpos-35,vpos,clrBlack,CORNER_LEFT_UPPER);
//---  
  }
//+------------------------------------------------------------------+    
void UpDownAction(string editname, bool flag, double step, int dg)
  {
//---
      double value = double(StringToDouble(ObjectGetString(ChartID(),editname,OBJPROP_TEXT)));      
      if(flag==true)
       value = value + step;
      if(flag==false)       
       value = value - step;                    
      ObjectSetString(ChartID(),editname,OBJPROP_TEXT,DoubleToString(NormalizeDouble(value,dg),dg));      
//---  
  }
//+------------------------------------------------------------------+
int GetArrayIndex(string text, string &array[])
  {
//---
      for(int i=0; i<ArraySize(array); i++)
      if(text==array[i])
       return(i);       
//---
     return(0);  
  }
//+------------------------------------------------------------------+
void DisableDropDown(string name,string &item[])
  {
//---
         int hpos    = int(ObjectGetInteger(ChartID(),name,OBJPROP_XDISTANCE)); 
         int vpos    = int(ObjectGetInteger(ChartID(),name,OBJPROP_YDISTANCE));
         int hsize   = int(ObjectGetInteger(ChartID(),name,OBJPROP_XSIZE));
         int vsize   = int(ObjectGetInteger(ChartID(),name,OBJPROP_YSIZE));
         string text = ObjectGetString(ChartID(),name,OBJPROP_TEXT);
         MakeDropDown(name,text,item,DDBGColor,hpos,vpos,hsize,vsize,false);
//---  
  }
//+------------------------------------------------------------------+  
void CheckDropDownEvent(string &darray[], string sparam, string ddname, string disablename1, string disablename2)//, string text)
  {
             int hpos    = int(ObjectGetInteger(ChartID(),ddname,OBJPROP_XDISTANCE)); 
             int vpos    = int(ObjectGetInteger(ChartID(),ddname,OBJPROP_YDISTANCE));
             int hsize   = int(ObjectGetInteger(ChartID(),ddname,OBJPROP_XSIZE));
             int vsize   = int(ObjectGetInteger(ChartID(),ddname,OBJPROP_YSIZE));  
             string text = ObjectGetString(ChartID(),ddname,OBJPROP_TEXT);
             if(sparam==ddname || sparam==ddname+"arrow")
              {
                  //---                     
                     if(ObjectFind(ChartID(),ddname+"List")>=0)
                      {
                        MakeDropDown(ddname,text,darray,DDBGColor,hpos,vpos,hsize,vsize,false);
                      }
                     else
                      {
                        DisableAllDropDown();
                        MakeDropDown(ddname,text,darray,DDBGColor,hpos,vpos,hsize,vsize,true);                      
                      }
                  //---                  
              }
             for(int i=0; i<ArraySize(darray); i++)
              {
                  string name = ddname+"Lable"+IntegerToString(i);
                  if(sparam==name)
                   {                   
                     MakeDropDown(ddname,darray[i],darray,DDBGColor,hpos,vpos,hsize,vsize,false);                      
                   }
              }  
   }
//+------------------------------------------------------------------+
void DisableAllDropDown()
  {
//---
      //All Drop Down Box can be diable one by one here
      //++++++++++++Example Code Is Here+++++++++++++++
//---  
  }
//+------------------------------------------------------------------+  
void OnChartEvent(const int id,         // Event ID 
                  const long& lparam,   // Parameter of type long event 
                  const double& dparam, // Parameter of type double event 
                  const string& sparam  // Parameter of type string events 
  )
  {
//---
         //All Chart Events can ve detect here
         //++++++++++++Here Is An Example Code+++++++++++++         
         if(id==CHARTEVENT_OBJECT_CLICK)
          { 
          } 
         if(id==CHARTEVENT_CLICK)
          {
          }
         //++++++++++++++++++++++++++++++++++++++++++++//        
   }
//+------------------------------------------------------------------+
void Update()
 {
      UpgradeDataInfo();
      for(int i=0; i<ArraySize(datainfo); i++)
       {
             ObjectSetString(ChartID(),"Lable_"+IntegerToString(i),OBJPROP_TEXT,datainfo[i]);
       }
 }     
//+------------------------------------------------------------------+
void UpgradeDataInfo()
  {
      datainfo[0] = "Total Buy : ";
      datainfo[1] = "Total Sell : ";
      datainfo[2] = "Equity : "+DoubleToString(AccountEquity(),2)+"$";
      datainfo[3] = "Time : "+TimeToString(TimeCurrent(),TIME_SECONDS);
      datainfo[4] = "Profit : "+DoubleToString(MathAbs(AccountEquity()-AccountBalance()),2)+"$";
  }
//+-------------------------------------------------------
void MakeGroupButton(int number, string &text[], color &cl[], ENUM_BASE_CORNER corner, int hposoffset, int vposoffset, string extraname)
  {
//---
      for(int i=0; i<MathMin(ArraySize(text),ArraySize(cl)); i++)
       {
         string name = "But_"+IntegerToString(i)+extraname;
         int hsize = 100;//Button Width
         int vsize = 40;//Button Height
         int hpos  = hposoffset+20;//Button Horizental Position
         int vpos  = i * (vsize+5)+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_LEFT_UPPER)
          vpos  = i * (vsize+5)+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_LEFT_LOWER)
          vpos  = i * (vsize+5)+vsize+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_RIGHT_UPPER)
          hpos  = hposoffset+hpos+hsize;//Button Horizental Position          
         if(corner==CORNER_RIGHT_LOWER)
          {
            vpos  = i * (vsize+5)+vsize+vposoffset+20;//Button Vertical Position                    
            hpos  = hposoffset+hpos+hsize;//Button Horizental Position          
          }
         MakeButton(name,text[i],FontSize,hpos,vpos,hsize,vsize,cl[i],FontColor,true,Font);                  
       }
//---  
  }
//+------------------------------------------------------------------+
void MakeGroupLable(string &text[], color &cl[], ENUM_BASE_CORNER corner, int hposoffset, int vposoffset, string extraname)
  {
//---
      for(int i=0; i<MathMin(ArraySize(text),ArraySize(cl)); i++)
       {
         string name = "Lable_"+IntegerToString(i)+extraname;
         int hsize = 100;//Lable Width
         int vsize = 15;//Lable Height
         int hpos  = hposoffset+5;//Button Horizental Position
         int vpos  = i * (vsize+5)+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_LEFT_UPPER)
          vpos  = i * (vsize+5)+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_LEFT_LOWER)
          vpos  = i * (vsize+5)+vposoffset+20;//Button Vertical Position
         if(corner==CORNER_RIGHT_UPPER)
          hpos  = hpos;//Button Horizental Position          
         if(corner==CORNER_RIGHT_LOWER)
          {
            vpos  = i * (vsize+5)+20;//Button Vertical Posi3tion                    
            hpos  = hpos;//Button Horizental Position          
          }
         MakeLable(name,text[i],Font,FontSize,hpos,vpos,FontColor,corner);
       }
//---  
  }
//+------------------------------------------------------------------+
void MakeTableLable(int number, string &text[], color &cl[], ENUM_BASE_CORNER corner)
  {
//---
      for(int i=0; i<MathMin(ArraySize(text),ArraySize(cl)); i++)
       {
         string name = "Lable_"+IntegerToString(i);
         int hsize = 100;//Button Width
         int vsize = 40;//Button Height
         int hpos  = 20;//Button Horizental Position
         int vpos  = i * (vsize+5)+20;//Button Vertical Position
         if(corner==CORNER_LEFT_UPPER)
          vpos  = i * (vsize+5)+20;//Button Vertical Position
         if(corner==CORNER_LEFT_LOWER)
          vpos  = i * (vsize+5)+20;//Button Vertical Position
         if(corner==CORNER_RIGHT_UPPER)
          hpos  = hpos;//Button Horizental Position          
         if(corner==CORNER_RIGHT_LOWER)
          {
            vpos  = i * (vsize+5)+20;//Button Vertical Posi3tion                    
            hpos  = hpos;//Button Horizental Position          
          }
         MakeLable(name,text[i],Font,FontSize,hpos,vpos,cl[i],corner);
       }
//---  
  }
//+------------------------------------------------------------------+
void MakeTableButton(int rownum, int colnum, string &text[][], color &cl[], ENUM_BASE_CORNER corner)
  {
//---
      for(int j=0; j<colnum; j++)
      for(int i=0; i<MathMin(rownum,colnum); i++)
       {
         string name = "But_"+IntegerToString(i)+"_"+IntegerToString(j);
         int hsize   = int((ChartGetInteger(ChartID(),CHART_WIDTH_IN_PIXELS,0)/2)/colnum);//Button Width
         int vsize   = int((ChartGetInteger(ChartID(),CHART_HEIGHT_IN_PIXELS,0)-50)/rownum);//Button Height
         int hpos    = (j*hsize+5)+20;//Button Horizental Position
         int vpos    = i * (vsize+5)+20;//Button Vertical Position
         if(corner==CORNER_LEFT_UPPER)
          vpos  = i * (vsize+5)+20;//Button Vertical Position
         if(corner==CORNER_LEFT_LOWER)
          vpos  = i * (vsize+5)+vsize+20;//Button Vertical Position
         if(corner==CORNER_RIGHT_UPPER)
          hpos  = hpos+hsize;//Button Horizental Position          
         if(corner==CORNER_RIGHT_LOWER)
          {
            vpos  = i * (vsize+5)+vsize+20;//Button Vertical Position                    
            hpos  = hpos+hsize;//Button Horizental Position          
          }
         MakeButton(name,"",FontSize,hpos,vpos,hsize,vsize,cl[i],FontColor,true,Font);
         string lable[4] = {"1","2","3","4"};                    
         MakeGroupLable(lable,cl,CORNER_LEFT_UPPER,hpos,vpos,"_"+IntegerToString(j)+"_"+IntegerToString(i));
       }
//---  
  }
//+------------------------------------------------------------------+
void ButtonAction(string name)
  {
//---
         int hpos    = int(ObjectGetInteger(ChartID(),name,OBJPROP_XDISTANCE)); 
         int vpos    = int(ObjectGetInteger(ChartID(),name,OBJPROP_YDISTANCE));
         int hsize   = int(ObjectGetInteger(ChartID(),name,OBJPROP_XSIZE));
         int vsize   = int(ObjectGetInteger(ChartID(),name,OBJPROP_YSIZE));
         color cl    = color(ObjectGetInteger(ChartID(),name,OBJPROP_BGCOLOR));
         string text = ObjectGetString(ChartID(),name,OBJPROP_TEXT);
         ObjectDelete(ChartID(),name);
         Sleep(200);
         MakeButton(name,text,FontSize,hpos,vpos,hsize,vsize,cl,FontColor,true,"Arial");
//---  
  }
//+------------------------------------------------------------------+
void CheckSignal(string sym){
//---Write your main logic here
double MA11 = iMA(Symbol(),PERIOD_CURRENT,MAPeriod1,0,MAMethod1,MAPrice1,1);
double MA12 = iMA(Symbol(),PERIOD_CURRENT,MAPeriod1,0,MAMethod1,MAPrice1,2);
double MA21 = iMA(Symbol(),PERIOD_CURRENT,MAPeriod2,0,MAMethod2,MAPrice2,1);
double MA22 = iMA(Symbol(),PERIOD_CURRENT,MAPeriod2,0,MAMethod2,MAPrice2,2);
//---
if(MA11>MA21 && MA12<MA22)
 {
   Trend = 0;
 }
if(MA11<MA21 && MA12>MA22)
 {
   Trend = 1; 
 }
//---
if(Close_By_Reverse_Signal==true) 
{
if(Trend==0)
CloseAll(1,sym);
if(Trend==1)
CloseAll(0,sym);
}
//---
}
//+------------------------------------------------------------------+
void DoTrail()
  {
//---
         bool check   = false;
         double newsl = 0;
         int  ThirdLevelDistance = 0;
         if(TrailEnable==true)
         for(int j=0; j<=OrdersTotal(); j++)
         if(OrderSelect(j,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderMagicNumber()==MagicNumber && OrderSymbol()==Symbol())
          {
            newsl = 0;
            ThirdLevelDistance = int(DiffPrice(BuyThirdTP,OrderOpenPrice(),Symbol()));   
            ThirdLevelDistance = int((ThirdLevelDistance*TrailPercent)/100);         
            if(OrderType()==OP_BUY)            
             {
               if(Bid>=BuyFirstTP && Bid<BuySecondTP)
               if(BuyFirstTP>OrderOpenPrice())
                newsl = OrderOpenPrice();
               //...
               if(Bid>=BuySecondTP && Bid<BuyThirdTP)                
                newsl = BuyFirstTP; 
               //...               
               if(Bid>=OrderOpenPrice()+ThirdLevelDistance*_Point)
                newsl = BuySecondTP; 
               //...
               if(Bid>OrderOpenPrice() && newsl>0)
               if(newsl>OrderStopLoss() || OrderStopLoss()==0)
                check = OrderModify(OrderTicket(),OrderOpenPrice(),newsl,OrderTakeProfit(),OrderExpiration(),clrBlue);                                 
               //...
             }
            if(OrderType()==OP_SELL)
             {
               ThirdLevelDistance = int(DiffPrice(SellThirdTP,OrderOpenPrice(),Symbol()));   
               ThirdLevelDistance = int((ThirdLevelDistance*TrailPercent)/100);                     
               if(Bid<=SellFirstTP && Bid>SellSecondTP)
               if(SellFirstTP<OrderOpenPrice())               
                newsl = OrderOpenPrice();
               //...
               if(Bid<=SellSecondTP && Bid>SellThirdTP)
                newsl = SellFirstTP;
               //...
               if(Bid<=OrderOpenPrice()-ThirdLevelDistance*_Point)
                newsl = SellSecondTP;
               //...
               if(Bid<OrderOpenPrice() && newsl>0)
               if(newsl<OrderStopLoss() || OrderStopLoss()==0)
                check = OrderModify(OrderTicket(),OrderOpenPrice(),newsl,OrderTakeProfit(),OrderExpiration(),clrRed);                 
               //...
             }             
          }
//---  
  }
//+------------------------------------------------------------------+  
void DoPivot()
  {
//---
   int Count;
   double Range;
   bool check = false;
   double newsl = 0;
//i = Bars - IndicatorCounted() - 1;
   int i=iBars(Symbol(),PERIOD_CURRENT)-10;
   ArrayResize(Res1,i+2);
   ArrayResize(Res2,i+2);
   ArrayResize(Res3,i+2);      
   ArrayResize(Sup1,i+2);
   ArrayResize(Sup2,i+2);
   ArrayResize(Sup3,i+2);   
   ArrayResize(Pivot,i+2);            
   while(i>=0)
     {
      // If the pivot day changes...
      if(PivotDay(Time[i+1],ShiftHrs)!=PivotDay(Time[i],ShiftHrs))
        {
         // Determine High & Low for the previous Pivot Day
         Count = iBarShift( NULL, 0, PivotDayStartTime ) - i;           // number of bars in the day
         PDayHigh = High[ iHighest( NULL, 0, MODE_HIGH, Count, i+1 ) ]; // Pivot Day high
         PDayLow = Low[ iLowest( NULL, 0, MODE_LOW, Count, i+1 ) ];     // Pivot Day low

                                                                        // Pivot calculations
         Pivot[i]=(PDayHigh+PDayLow+Close[i+1])/3;    // Pivot point
         Range=PDayHigh-PDayLow;
         Res1[i] = 2 * Pivot[i] - PDayLow;                     // R1
         Res2[i] = Pivot[i] + Range;                           // R2
         Res3[i] = Res1[i] + Range;                            // R3
         Sup1[i] = 2 * Pivot[i] - PDayHigh;                    // S1
         Sup2[i] = Pivot[i] - Range;                           // S2
         Sup3[i] = Sup1[i] - Range;                            // S3

                                                               // Don't draw the transition between levels
         Res3[i+1] = EMPTY_VALUE;
         Res2[i+1] = EMPTY_VALUE;
         Res1[i+1] = EMPTY_VALUE;
         Pivot[i+1]= EMPTY_VALUE;
         Sup1[i+1] = EMPTY_VALUE;
         Sup2[i+1] = EMPTY_VALUE;
         Sup3[i+1] = EMPTY_VALUE;

         // Remember when the Day changed over
         PivotDayStartTime=Time[i];
        }
      else     // no change to pivot levels
        {
         Res3[i] = Res3[i+1];
         Res2[i] = Res2[i+1];
         Res1[i] = Res1[i+1];
         Pivot[i]= Pivot[i+1];
         Sup1[i] = Sup1[i+1];
         Sup2[i] = Sup2[i+1];
         Sup3[i] = Sup3[i+1];
        }

      // Move the labels to sensible places
      // If this is the last bar and (it's a new bar or time scale has changed)...
      if(i==0 && (BarTime!=Time[i] || VisibleBars!=WindowBarsPerChart()))
        {
         DayStartBar = iBarShift( ThisSymbol, Period(), PivotDayStartTime );
         LeftMostBar = WindowFirstVisibleBar()-7;
         RightMostBar= 15;
         if(DayStartBar<RightMostBar) // label too close to the right
           {
            ObjectMove(R3_NAME,0,Time[RightMostBar],Res3[i]);
            ObjectMove(R2_NAME,0,Time[RightMostBar],Res2[i]);
            ObjectMove(R1_NAME,0,Time[RightMostBar],Res1[i]);
            ObjectMove(PIVOT_NAME,0,Time[RightMostBar],Pivot[i]);
            ObjectMove(S1_NAME,0,Time[RightMostBar],Sup1[i]);
            ObjectMove(S2_NAME,0,Time[RightMostBar],Sup2[i]);
            ObjectMove(S3_NAME,0,Time[RightMostBar],Sup3[i]);
           }
         else if(DayStartBar>LeftMostBar) // label too close to the left
           {
            ObjectMove(R3_NAME,0,Time[LeftMostBar],Res3[i]);
            ObjectMove(R2_NAME,0,Time[LeftMostBar],Res2[i]);
            ObjectMove(R1_NAME,0,Time[LeftMostBar],Res1[i]);
            ObjectMove(PIVOT_NAME,0,Time[LeftMostBar],Pivot[i]);
            ObjectMove(S1_NAME,0,Time[LeftMostBar],Sup1[i]);
            ObjectMove(S2_NAME,0,Time[LeftMostBar],Sup2[i]);
            ObjectMove(S3_NAME,0,Time[LeftMostBar],Sup3[i]);
           }
         else                                      // move it with the bars
           {
            ObjectMove(R3_NAME,0,PivotDayStartTime,Res3[i]);
            ObjectMove(R2_NAME,0,PivotDayStartTime,Res2[i]);
            ObjectMove(R1_NAME,0,PivotDayStartTime,Res1[i]);
            ObjectMove(PIVOT_NAME,0,PivotDayStartTime,Pivot[i]);
            ObjectMove(S1_NAME,0,PivotDayStartTime,Sup1[i]);
            ObjectMove(S2_NAME,0,PivotDayStartTime,Sup2[i]);
            ObjectMove(S3_NAME,0,PivotDayStartTime,Sup3[i]);
           }
        }

      VisibleBars=WindowBarsPerChart();
      BarTime=Time[i];
      i--;
     }
         if(TotalOrder(6,Symbol())==0)
          {
            BuyFirstTP  = Res1[1];
            SellFirstTP = Sup1[1];
            //...
            BuySecondTP  = Res2[1];
            SellSecondTP = Sup2[1];
            //...         
            BuyThirdTP  = Res3[1];
            SellThirdTP = Sup3[1];
            //...  
          }
         /*string text = "";
         text += "Buy TP1 :"+DoubleToString(BuyFirstTP,_Digits);
         text += "\nBuy TP2 : "+DoubleToString(BuySecondTP,_Digits);
         text += "\nBuy TP3 : "+DoubleToString(BuyThirdTP,_Digits);
         text += "\nSell TP1 : "+DoubleToString(SellFirstTP,_Digits);
         text += "\nSell TP2 : "+DoubleToString(SellSecondTP,_Digits);
         text += "\nSell TP3 : "+DoubleToString(SellThirdTP,_Digits);                  
         Comment(text);*/          
     //...
     int daycounter = 0;
     for(int d=1; d<ArraySize(Res1)-1; d++)         
      {
        if(TimeDayOfYear(Time[d])!=TimeDayOfYear(Time[d+1]))
         {
           daycounter++;
           datetime startt = Time[d];
           datetime stopt  = startt+(1440*60);   
           datetime middle = datetime((startt+stopt)/2);     
           DrawTLine("Res1_"+TimeToString(Time[d]),startt,Res1[d],stopt,Res1[d],ResistanceColor);
           DrawText("Res1Text_"+TimeToString(Time[d]),middle,Res1[d],"Res1 : "+DoubleToString(Res1[d],_Digits),FontColor);
           DrawTLine("Res2_"+TimeToString(Time[d]),startt,Res2[d],stopt,Res2[d],ResistanceColor);
           DrawText("Res2Text_"+TimeToString(Time[d]),middle,Res2[d],"Res2 : "+DoubleToString(Res2[d],_Digits),FontColor);
           DrawTLine("Res3_"+TimeToString(Time[d]),startt,Res3[d],stopt,Res3[d],ResistanceColor);                         
           DrawText("Res3Text_"+TimeToString(Time[d]),middle,Res3[d],"Res3 : "+DoubleToString(Res3[d],_Digits),FontColor); 
           DrawTLine("Pivot_"+TimeToString(Time[d]),startt,Pivot[d],stopt,Pivot[d],PivotColor);                          
           DrawText("PivotText_"+TimeToString(Time[d]),middle,Pivot[d],"Pivot : "+DoubleToString(Pivot[d],_Digits),FontColor);
           //...
           DrawTLine("Sup1_"+TimeToString(Time[d]),startt,Sup1[d],stopt,Sup1[d],SupportColor);
           DrawText("Sup1Text_"+TimeToString(Time[d]),middle,Sup1[d],"Sup1 : "+DoubleToString(Sup1[d],_Digits),FontColor);
           DrawTLine("Sup2_"+TimeToString(Time[d]),startt,Sup2[d],stopt,Sup2[d],SupportColor);
           DrawText("Sup2Text_"+TimeToString(Time[d]),middle,Sup2[d],"Sup2 : "+DoubleToString(Sup2[d],_Digits),FontColor);
           DrawTLine("Sup3_"+TimeToString(Time[d]),startt,Sup3[d],stopt,Sup3[d],SupportColor);        
           DrawText("Sup3Text_"+TimeToString(Time[d]),middle,Sup3[d],"Sup3 : "+DoubleToString(Sup3[d],_Digits),FontColor);
           //...        
         }
        if(daycounter>10)
         break;
      }
     //Comment("Res1 : "+Res1[1]+"\nRes2 : "+Res2[1]+"\nRes3 : "+Res3[1]+"\nSup1 : "+Sup1[1]+"\nSup2 : "+Sup2[1]+"\nSup3 : "+Sup3[1]);
//---  
  }
//+------------------------------------------------------------------+ 
void DrawText(string name,datetime t1, double p1, string text, color cl)
  {
//---
      if(ShowText==false)
       return;
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_TEXT,0,t1,p1);
      ObjectSet(name,OBJPROP_COLOR,cl);
      ObjectSetText(name,text,FontSize,"Arial Black",cl);      
//---  
  }
//+------------------------------------------------------------------+   
void DrawTLine(string name,datetime t1, double p1, datetime t2, double p2, color cl)
  {
//---
      if(ShowLine==false)
       return;
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_TREND,0,t1,p1,t2,p2);
      ObjectSet(name,OBJPROP_COLOR,cl);
      ObjectSet(name,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(name,OBJPROP_RAY,false);
//---  
  }
//+------------------------------------------------------------------+    
void DrawHLine(string name, double price, color cl)
  {
//---
      ObjectDelete(ChartID(),name);
      ObjectCreate(ChartID(),name,OBJ_HLINE,0,0,price);
      ObjectSet(name,OBJPROP_COLOR,cl);
      ObjectSet(name,OBJPROP_STYLE,STYLE_DASH);      
//---  
  }
//+------------------------------------------------------------------+    
int PivotDay(datetime Bar_Time,datetime Shift_Hrs)
  {
   int PDay=TimeDayOfWeek(Bar_Time+Shift_Hrs*3600);

   if( PDay == 0 ) PDay = 1;      // Count Sunday as Monday
   if( PDay == 6 ) PDay = 5;      // Count Saturday as Friday

   return( PDay );
  }
//+------------------------------------------------------------------+
