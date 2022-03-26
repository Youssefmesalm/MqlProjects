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
#include  <YM\Order\Order.mqh>
#include <Arrays\ArrayDouble.mqh>
enum close
  {
   buy,
   sell,
   buyAndsell,
   None,
  };
// inputs
sinput string set1 = "<-------------- Currency Pairs Settings-------------->";
input string Suffix="";
input string Perfix="";
input string CustomPairs = "EURUSD,USDCHF,USDCAD,USDJPY,GBPUSD";
sinput string set2 = "<----------------Trading Settings-------------------->";
input double lotStarter = 0.1;
input double LotMultiplier=1.6;
input int TradingLevelsNumbers=11;
input int GapBetweenLevels=100;
input bool CloseWith_Points=false;
input int ProfitPointsToCloseLossTrades=10;// Close Loss Trades with Profit in Points
input bool CloseWith_Dollar=true;
input double ProfitUSDToCloseLossTrades=10; // Close Loss Trades with Profit in Dollar
input double trailingStop=50;  //trailing stop for Profit trades
input long magic_Number = 2020;

//global variables
int TB=0,TS=0,TT=0;
int Total[],TotalSell[],TotalBuy[];
close WhichClos[];
int Highest[],lowest[];

// Arrays
string Symbols[];
double lots[];
// Class object
CExecute *trades[];
CPosition *Positions[];
CPosition *SellPositions[];
CPosition *BuyPositions[];
COrder *Pendings[];
COrder *SellPendings[];
COrder *BuyPendings[];
CUtilities *tools[];
int openDirection[];
CArrayDouble *Levelprices[];
//arrays
double upPrice[];
double dnPrice[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   StringSplit(CustomPairs, StringGetCharacter(",", 0), Symbols);
   int size= ArraySize(Symbols);
   ArrayResize(trades,size,size);
   ArrayResize(Positions,size,size);
   ArrayResize(SellPositions,size,size);
   ArrayResize(BuyPositions,size,size);
   ArrayResize(Pendings,size,size);
   ArrayResize(BuyPendings,size,size);
   ArrayResize(SellPendings,size,size);
   ArrayResize(tools,size,size);
   ArrayResize(upPrice,size,size);
   ArrayResize(dnPrice,size,size);
   ArrayResize(Levelprices,size,size);
   ArrayResize(WhichClos,size,size);
   ArrayResize(Total,size,size);
   ArrayResize(TotalBuy,size,size);
   ArrayResize(TotalSell,size,size);
   ArrayResize(openDirection,size,size);
   ArrayResize(Highest,size,size);
   ArrayResize(lowest,size,size);
   ArrayResize(lots,TradingLevelsNumbers,TradingLevelsNumbers);
   for(int i=0; i<size; i++)
     {
      Symbols[i]=Perfix+Symbols[i]+Suffix;
      if(SymbolSelect(Symbols[i],true))
        {
         Print(Symbols[i]+" added to Market watch");
        }
      else
        {
         Print(Symbols[i]+" does't Exist");
        }

      trades[i] = new CExecute(Symbols[i], magic_Number);
      BuyPositions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_BUYS);
      SellPositions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_SELLS);
      Positions[i] = new CPosition(Symbols[i], magic_Number, GROUP_POSITIONS_ALL);
      Pendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_ALL);
      BuyPendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_BUY_STOP);
      SellPendings[i]=new COrder(Symbols[i],magic_Number,GROUP_ORDERS_SELL_STOP);
      tools[i] = new CUtilities(Symbols[i]);
      Levelprices[i]= new CArrayDouble;
      Levelprices[i].Resize((1+TradingLevelsNumbers)*2);

      WhichClos[i]=None;
      Total[i]=0;
      TotalBuy[i]=0;
      TotalSell[i]=0;
      openDirection[i]=0;
      Highest[i]=0;
      lowest[i]=0;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   int size= ArraySize(Symbols);
   for(int i=0; i<size; i++)
     {
      delete(trades[i]);
      delete(BuyPositions[i]);
      delete(SellPositions[i]);
      delete(Positions[i]);
      delete(Pendings[i]);
      delete(tools[i]);
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   int size= ArraySize(Symbols);
   for(int i=0; i<size; i++)
     {
      int TotalPositions=Positions[i].GroupTotal();
      int TotalPendings=Pendings[i].GroupTotal();
      if(TotalPendings==0&&TotalPositions==0)
        {
         Levelprices[i].Clear();
         Total[i]=0;
         TotalBuy[i]=0;
         TotalSell[i]=0;
         Highest[i]=0;
         lowest[i]=0;
         openDirection[i]=0;
         WhichClos[i]=None;
         upPrice[i]=tools[i].Bid();
         dnPrice[i]=tools[i].Bid();
         double ssl=tools[i].Bid()+(GapBetweenLevels*(TradingLevelsNumbers+0.5)*tools[i].Pip());
         double bsl=tools[i].Ask()-(GapBetweenLevels*(TradingLevelsNumbers+0.5)*tools[i].Pip());
         bool first=true;
         double lot=0;
         for(int x=0; x<TradingLevelsNumbers; x++)
           {
            lot=first?lotStarter:tools[i].NormalizeVolume(lot*LotMultiplier,ROUNDING_OFF);
            lots[x]=lot;
            upPrice[i] =first?(upPrice[i]+(GapBetweenLevels/2)*tools[i].Pip()):upPrice[i]+(GapBetweenLevels*tools[i].Pip());
            dnPrice[i] =first?(dnPrice[i]-(GapBetweenLevels/2)*tools[i].Pip()):dnPrice[i]-(GapBetweenLevels*tools[i].Pip());
            trades[i].Order(TYPE_ORDER_BUYSTOP,lot,upPrice[i],bsl,0,SLTP_PRICE,0,30,(string)x);
            trades[i].Order(TYPE_ORDER_SELLLIMIT,lot,upPrice[i],ssl,0,SLTP_PRICE,0,30,(string)x);
            trades[i].Order(TYPE_ORDER_BUYLIMIT,lot,dnPrice[i],bsl,0,SLTP_PRICE,0,30,"-"+(string)x);
            trades[i].Order(TYPE_ORDER_SELLSTOP,lot,dnPrice[i],ssl,0,SLTP_PRICE,0,30,"-"+(string)x);
            first=false;
            Levelprices[i].Add(dnPrice[i]);
            Levelprices[i].Add(upPrice[i]);

           }
         Levelprices[i].Add(bsl);
         Levelprices[i].Add(ssl);
         Levelprices[i].Sort(0);

        }

      CheckNewOpen(Positions[i],BuyPositions[i],SellPositions[i],Total[i],TotalBuy[i],TotalSell[i],openDirection[i],WhichClos[i]);
      if(openDirection[i]!=0)
        {
         UpdateLot(Positions[i],Pendings[i],trades[i],Highest[i],lowest[i],openDirection[i]);
        }
      Repending(Positions[i],BuyPositions[i],SellPositions[i],trades[i],tools[i],Pendings[i],BuyPendings[i],SellPendings[i],WhichClos[i],Levelprices[i],Total[i],TotalBuy[i],TotalSell[i]);
      Traliling(BuyPositions[i],SellPositions[i],tools[i],Levelprices[i]);
      Closing(BuyPositions[i],SellPositions[i],tools[i],Pendings[i],upPrice[i],dnPrice[i],Levelprices[i]);
      if(Positions[i].GroupTotal()==0&&Pendings[i].GroupTotal()<TradingLevelsNumbers*4)
        {
         Pendings[i].GroupCloseAll(20);
        }

     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateLot(CPosition & Pos,COrder & Pending,CExecute & open,int & H,int & L,int & D)
  {
   int size=Pos.GroupTotal();
   int direction=0;
   long tickets[];
   int lotindex=0;
   for(int i=0; i<size; i++)
     {
      int comment=(int)Pos[i].GetComment();
      if(comment==0)
        {
         if(Pos[i].GetComment()=="0")
            direction=1;
         else
            direction=-1;
        }
      if(comment>0&&comment>=H&&D>0)
        {
         H=comment;
         direction=1;
         lotindex=MathAbs(H);
        }
      if(comment<0&&comment<=L&&D<0)
        {
         L=comment;
         direction=-1;
         lotindex=MathAbs(L);
        }
     }
   int totalPending=Pending.GroupTotal();
   if(direction>0&&L==0&&H==0&&D>0)
     {
      for(int x=0; x<totalPending; x++)
        {
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();

         if(comment<=0&&c!="0")
           {
            long ticket=Pending[x].GetTicket();
            int tsize=ArraySize(tickets);
            ArrayResize(tickets,tsize+1);
            tickets[tsize]=ticket;

           }

        }
      int ttotal=ArraySize(tickets);
      for(int z=0; z<ttotal; z++)
        {
         long x=tickets[z];
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         double openPrice=Pending[x].GetPriceOpen();
         double sl=Pending[x].GetStopLoss();
         ENUM_TYPE_ORDER type=Pending[x].GetType()==ORDER_TYPE_SELL_STOP?TYPE_ORDER_SELLSTOP:TYPE_ORDER_BUYLIMIT;
         Pending[x].Close();
         if(MathAbs(comment)<TradingLevelsNumbers-1)
           {
            open.Order(type,lots[MathAbs(comment)+1],openPrice,sl,0,SLTP_PRICE,0,30,c);
            D=0;
           }
        }

     }
   if(direction<0&&L==0&&H==0&&D<0)
     {
      for(int x=0; x<totalPending; x++)
        {
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         if(comment>=0&&c!="-0")
           {
            long ticket=Pending[x].GetTicket();
            int tsize=ArraySize(tickets);
            ArrayResize(tickets,tsize+1);
            tickets[tsize]=ticket;
           }
        }
      int ttotal=ArraySize(tickets);
      for(int z=0; z<ttotal; z++)
        {
         long x=tickets[z];
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         double openPrice=Pending[x].GetPriceOpen();
         double sl=Pending[x].GetStopLoss();
         ENUM_TYPE_ORDER type=Pending[x].GetType()==ORDER_TYPE_BUY_STOP?TYPE_ORDER_BUYSTOP:TYPE_ORDER_SELLLIMIT;
         Pending[x].Close();
         if(MathAbs(comment)<TradingLevelsNumbers-1)
           {
            open.Order(type,lots[MathAbs(comment)+1],openPrice,sl,0,SLTP_PRICE,0,30,c);
            D=0;
           }
        }
     }


   if(direction<0&&L<0&&D<0)
     {
      for(int x=0; x<totalPending; x++)
        {
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         if(comment>=0&&c!="-0")
           {
            long ticket=Pending[x].GetTicket();
            int tsize=ArraySize(tickets);
            ArrayResize(tickets,tsize+1);
            tickets[tsize]=ticket;

           }
        }
      int ttotal=ArraySize(tickets);
      for(int z=0; z<ttotal; z++)
        {
         long x=tickets[z];
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         double openPrice=Pending[x].GetPriceOpen();
         double sl=Pending[x].GetStopLoss();
         ENUM_TYPE_ORDER type=Pending[x].GetType()==ORDER_TYPE_BUY_STOP?TYPE_ORDER_BUYSTOP:TYPE_ORDER_SELLLIMIT;
         Pending[x].Close();

         if(MathAbs(comment)<TradingLevelsNumbers-MathAbs(L)-1)
           {
            open.Order(type,lots[MathAbs(comment)+lotindex+1],openPrice,sl,0,SLTP_PRICE,0,30,c);
            D=0;
           }
        }
     }
   if(direction>0&&H>0&&D>0)
     {
      for(int x=0; x<totalPending; x++)
        {
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();

         if(comment<=0&&c!="0")
           {
            long ticket=Pending[x].GetTicket();
            int tsize=ArraySize(tickets);
            ArrayResize(tickets,tsize+1);
            tickets[tsize]=ticket;
           }
        }
      int ttotal=ArraySize(tickets);
      for(int z=0; z<ttotal; z++)
        {
         long x=tickets[z];
         int comment=(int)Pending[x].GetComment();
         string c=Pending[x].GetComment();
         double openPrice=Pending[x].GetPriceOpen();
         double sl=Pending[x].GetStopLoss();
         ENUM_TYPE_ORDER type=Pending[x].GetType()==ORDER_TYPE_SELL_STOP?TYPE_ORDER_SELLSTOP:TYPE_ORDER_BUYLIMIT;
         Pending[x].Close();
         if(MathAbs(comment)<TradingLevelsNumbers-lotindex-1)
           {
            open.Order(type,lots[MathAbs(comment)+lotindex+1],openPrice,sl,0,SLTP_PRICE,0,30,c);
            D=0;
           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void CheckNewOpen(CPosition & Pos, CPosition & BuyPos,CPosition & SellPos,int & T,int & B,int & S,int & direction,close & WhichClose)
  {
   int totalPos=Pos.GroupTotal();
   int totalSell=SellPos.GroupTotal();
   int totalbuy=BuyPos.GroupTotal();
   if(totalPos>T||(T==0&&totalPos>T))
     {
      T=totalPos;
     }
   if(totalSell>S||(S==0&&totalSell>S))
     {
      S=totalSell;
      direction=-1;
     }
   if(totalbuy>B||(B==0&&totalbuy>B))
     {
      B=totalbuy;
      direction=1;
     }
   if(totalPos<T)
     {
      totalSell=SellPos.GroupTotal();
      totalbuy=BuyPos.GroupTotal();
      if(totalSell<S&&WhichClose==None)
        {
         WhichClose=sell;
         S=totalSell;
         T=totalPos;
        }
      else
         if(totalbuy<B&&WhichClose==None)
           {
            WhichClose=buy;
            T=totalPos;
            B=totalbuy;
           }
         else
            if((totalbuy<B||totalSell<S)&&WhichClose!=buyAndsell&&WhichClose!=None)
              {
               WhichClose=buyAndsell;
               TT=totalPos;
               B=totalbuy;
               S=totalSell;
              }

     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Traliling(CPosition & BuyPos,CPosition & SellPos, CUtilities & tool,CArrayDouble & Levels)
  {
// Positions numbers
   int totalBuy = BuyPos.GroupTotal();
   int totalSell = SellPos.GroupTotal();
//
   if(TB>0&&totalBuy==0)
     {
      TB=0;
     }
   if(TS>0&&totalSell==0)
     {
      TS=0;
     }
//Buy trailing
   int TL=Levels.Total();
//   if(totalBuy==1&&tool.Bid()>Levels.At(TL-2)&&tool.Bid()<(Levels.At(TL-2)+tralilingStepAfterAllLevels*tool.Pip()))
//     {
//      double sl=Levels.At(TL-2)-(trailingStop*tool.Pip());
//      TB=totalBuy;
//      for(int i = 0; i < totalBuy; i++)
//        {
//         if(BuyPos.SelectByIndex(i))
//           {
//            BuyPos.Modify(sl,BuyPos.GetTakeProfit(),SLTP_PRICE);
//
//           }
//        }
//     }
//   else
   if(totalBuy>=2&&TB<totalBuy&&BuyPos.GroupTotalProfit()>0)
     {
      double buyPriceOpen=0;
      //Get High Buy PriceOpen
      for(int i = 0; i < totalBuy; i++)
        {
         if(BuyPos.SelectByIndex(i))
           {
            if(BuyPos[i].GetPriceOpen()>buyPriceOpen)
              {
               buyPriceOpen=BuyPos[i].GetPriceOpen();
              }
           }
        }

      if(tool.Bid()>=buyPriceOpen)
        {
         double sl=buyPriceOpen -(trailingStop*tool.Pip());
         TB=totalBuy;
         for(int i = 0; i < totalBuy; i++)
           {
            if(BuyPos.SelectByIndex(i))
              {
               BuyPos.Modify(sl,BuyPos.GetTakeProfit(),SLTP_PRICE);

              }
           }
        }
     }

//Sell Trailing
//   if(totalSell==1&&tool.Bid()<Levels.At(1)&&tool.Bid()>(Levels.At(1)-tralilingStepAfterAllLevels*tool.Pip()))
//     {
//      double sl=Levels.At(1) +(trailingStop*tool.Pip());
//      TS=totalSell;
//      for(int i = 0; i < totalSell; i++)
//        {
//         if(SellPos.SelectByIndex(i))
//           {
//            SellPos[i].Modify(sl,SellPos[i].GetTakeProfit(),SLTP_PRICE);
//
//           }
//        }
//     }
//   else
   if(totalSell>=2&&TS<totalSell&&SellPos.GroupTotalProfit()>0)
     {
      double sellPriceOpen=0;
      //Get low sell PriceOpen
      for(int i = 0; i < totalSell; i++)
        {
         if(SellPos.SelectByIndex(i))
           {
            if(sellPriceOpen==0)
              {
               sellPriceOpen=SellPos[i].GetPriceOpen();
              }

            if(SellPos[i].GetPriceOpen()<sellPriceOpen)
              {
               sellPriceOpen=SellPos[i].GetPriceOpen();
              }
           }
        }
      if(tool.Bid()<sellPriceOpen)
        {
         double sl=sellPriceOpen +(trailingStop*tool.Pip());
         TS=totalSell;
         for(int i = 0; i < totalSell; i++)
           {
            if(SellPos.SelectByIndex(i))
              {

               SellPos.Modify(sl,SellPos.GetTakeProfit(),SLTP_PRICE);

              }
           }
        }
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Closing(CPosition & BuyPos,CPosition & SellPos, CUtilities & tool,COrder & Pending,double up,double dn,CArrayDouble & Levels)
  {
// Positions numbers
   int totalBuy = BuyPos.GroupTotal();
   int totalSell = SellPos.GroupTotal();
   double profitpoint=0;
// logics

   if(CloseWith_Points)
     {
      if(totalSell>0&&totalBuy==0&&tool.Bid()>dn)
        {
         if(SellPos.GroupTotalProfit()>0)
           {

            for(int i=0; i<totalSell; i++)
              {

               profitpoint+=SellPos[i].GetPriceOpen()-tool.Bid();
              }

            if(profitpoint>=ProfitPointsToCloseLossTrades*tool.Pip())
              {
               SellPos.GroupCloseAll(20);
               Pending.GroupCloseAll(20);
              }

           }
        }
      else
         if(totalBuy>0&&totalSell==0&&tool.Ask()<up)
           {
            if(BuyPos.GroupTotalProfit()>0)
              {


               for(int i=0; i<totalBuy; i++)
                 {

                  profitpoint+=tool.Bid()-BuyPos[i].GetPriceOpen();
                 }

               if(profitpoint>=ProfitPointsToCloseLossTrades*tool.Pip())
                 {
                  BuyPos.GroupCloseAll(20);
                  Pending.GroupCloseAll(20);
                 }

              }
           }
     }
   if(CloseWith_Dollar)
     {
      if(SellPos.GroupTotalProfit()>=ProfitUSDToCloseLossTrades)
        {

         if(totalSell>0&&totalBuy==0&&tool.Bid()>dn)
           {


            SellPos.GroupCloseAll(20);
            Pending.GroupCloseAll(20);

           }
        }
      if(BuyPos.GroupTotalProfit()>=ProfitUSDToCloseLossTrades)
        {
         if(totalBuy>0&&totalSell==0&&tool.Ask()<up)
           {

            BuyPos.GroupCloseAll(20);
            Pending.GroupCloseAll(20);

           }
        }
     }
   int TL=Levels.Total();

   if(tool.Bid()>Levels.At(TL-1)+5*tool.Pip())
     {
      Pending.GroupCloseAll(20);
      SellPos.GroupCloseAll(30);
     }
   if(tool.Bid()<Levels.At(0)-5*tool.Pip())
     {
      Pending.GroupCloseAll(20);
      BuyPos.GroupCloseAll(30);
     }
  }
//+------------------------------------------------------------------+




//+------------------------------------------------------------------+
void Repending(CPosition & Pos, CPosition & BuyPos,CPosition & SellPos,CExecute & Place, CUtilities & tool,COrder & Pending,COrder & buyPend,COrder & sellPend,close & WhichClose, CArrayDouble & Levels,int & T,int & B,int & S)
  {
   int totalPos=Pos.GroupTotal();
   int totalSell=SellPos.GroupTotal();
   int totalbuy=BuyPos.GroupTotal();
   if(totalPos>T||(T==0&&totalPos>T))
     {
      T=totalPos;
     }
   if(totalSell>S||(S==0&&totalSell>S))
     {
      S=totalSell;
     }
   if(totalbuy>B||(B==0&&totalbuy>B))
     {
      B=totalbuy;
     }
   if(totalPos<T)
     {
      totalSell=SellPos.GroupTotal();
      totalbuy=BuyPos.GroupTotal();
      if(totalSell<S&&WhichClose==None)
        {
         WhichClose=sell;
         S=totalSell;
         T=totalPos;
        }
      else
         if(totalbuy<B&&WhichClose==None)
           {
            WhichClose=buy;
            T=totalPos;
            B=totalbuy;
           }
         else
            if((totalbuy<B||totalSell<S)&&WhichClose!=buyAndsell&&WhichClose!=None)
              {
               WhichClose=buyAndsell;
               TT=totalPos;
               B=totalbuy;
               S=totalSell;
              }

     }
   int levelsTotal=Levels.Total();
   if(WhichClose!=None)
     {

      for(int i=2; i<levelsTotal-3; i++)
        {

         if(Levels.At(i)<tool.Bid()&&tool.Bid()<Levels.At(i+1))
           {

            if(WhichClose==buyAndsell||WhichClose==buy)
              {
               bool buypendingfound=false;
               bool buyfound=false;
               totalbuy=BuyPos.GroupTotal();
               int totalbuypending=buyPend.GroupTotal();

               totalSell=SellPos.GroupTotal();
               int totalsellpending=sellPend.GroupTotal();

               double lot=0;
               string coment="";
               for(int x=0; x<totalbuy; x++)
                 {
                  if(BuyPos[x].GetPriceOpen()>Levels.At(i+1)+1*tool.Pip()&&BuyPos[x].GetPriceOpen()<Levels.At(i+3)-1*tool.Pip())
                    {
                     buyfound=true;
                    }
                 }
               for(int x=0; x<totalSell; x++)
                 {
                  if(SellPos[x].GetPriceOpen()>Levels.At(i+1)+1*tool.Pip()&&SellPos[x].GetPriceOpen()<Levels.At(i+3)-1*tool.Pip())
                    {
                     lot=SellPos[x].GetVolume();
                     coment=SellPos[x].GetComment();
                    }
                 }
               for(int z=0; z<totalbuypending; z++)
                 {
                  if(buyPend[z].GetPriceOpen()>Levels.At(i+1)+1*tool.Pip()&&buyPend[z].GetPriceOpen()<Levels.At(i+3)-1*tool.Pip())
                    {
                     buypendingfound=true;
                    }

                 }
               for(int z=0; z<totalsellpending; z++)
                 {
                  if(sellPend[z].GetPriceOpen()>Levels.At(i+1)+1*tool.Pip()&&sellPend[z].GetPriceOpen()<Levels.At(i+3)-1*tool.Pip())
                    {
                     lot=sellPend[z].GetVolume();
                     coment=sellPend[z].GetComment();
                    }

                 }

               if((!buypendingfound&&!buyfound))
                 {
                  Place.Order(TYPE_ORDER_BUYSTOP,lot,Levels.At(i+2),Levels.At(0),0,SLTP_PRICE,0,30,coment);
                 }



              }

            if(WhichClose==buyAndsell||WhichClose==sell)
              {
               bool sellpendingfound=false;
               bool sellfound=false;
               totalSell=SellPos.GroupTotal();
               totalbuy=BuyPos.GroupTotal();
               int totalbuypending=buyPend.GroupTotal();

               double lot=0;
               string coment="";
               for(int x=0; x<totalSell; x++)
                 {
                  if(SellPos[x].GetPriceOpen()<Levels.At(i)-1*tool.Pip()&&SellPos[x].GetPriceOpen()>Levels.At(i-2)+1*tool.Pip())
                    {
                     sellfound=true;
                    }
                 }
               for(int x=0; x<totalbuy; x++)
                 {
                  if(BuyPos[x].GetPriceOpen()<Levels.At(i)-1*tool.Pip()&&BuyPos[x].GetPriceOpen()>Levels.At(i-2)+1*tool.Pip())
                    {
                     lot=BuyPos[x].GetVolume();
                     coment=BuyPos[x].GetComment();
                    }
                 }
               int totalsellpending=sellPend.GroupTotal();
               for(int z=0; z<totalsellpending; z++)
                 {

                  if(sellPend[z].GetPriceOpen()<Levels.At(i)-1*tool.Pip()&&sellPend[z].GetPriceOpen()>Levels.At(i-2)+1*tool.Pip())
                    {
                     sellpendingfound=true;
                    }
                 }
               for(int z=0; z<totalbuypending; z++)
                 {

                  if(buyPend[z].GetPriceOpen()<Levels.At(i)-1*tool.Pip()&&buyPend[z].GetPriceOpen()>Levels.At(i-2)+1*tool.Pip())
                    {
                     lot=buyPend[z].GetVolume();
                     coment=buyPend[z].GetComment();
                    }
                 }
               if(!sellpendingfound&&!sellfound)
                 {
                  Place.Order(TYPE_ORDER_SELLSTOP,lot,Levels.At(i-1),Levels.At(levelsTotal-1),0,SLTP_PRICE,0,30,coment);
                 }


              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
