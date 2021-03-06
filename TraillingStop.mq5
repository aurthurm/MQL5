//+------------------------------------------------------------------+
//|                                                TraillingStop.mq5 |
//|                                   Copyright 2019,Junior Domingos |
//|                                      juniordomingos738@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019,Junior Domingos"
#property link      "juniordomingos738@gmail.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
CTrade trade;

input double											stop = 100;//Stop loss
input int 												numero_magico = 123;

input string											campo2;//>               Trailling Stop
input bool												stop_movel = false;//TraillinStop?
input double											distancia_stop = 20;//How many points to activate
input double											pontos = 5;//How many on how many points
int OnInit()
  {
//---
   	trade.SetExpertMagicNumber(numero_magico);
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
   
  }
//+------------------------------------------------------------------+
//Realiza o Stop Movel
void TraillingStop()
{
	for(int i=0;i<PositionsTotal();i++)
	{
		PositionSelectByTicket(PositionGetTicket(i));
		//magic number and symbol
		if(PositionGetInteger(POSITION_MAGIC)==numero_magico && PositionGetString(POSITION_SYMBOL)==_Symbol)
		{
			//Type buy
			if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
			{
				if(UltimoTick() > PositionGetDouble(POSITION_PRICE_OPEN)+NormalizePrice(distancia_stop))
				{
					if(UltimoTick() > (PositionGetDouble(POSITION_SL)+NormalizePrice(stop))+NormalizePrice(pontos))
					{
						if(trade.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_SL)+NormalizePrice(pontos),PositionGetDouble(POSITION_TP)))
						{
						
						}
						else
							Print("Error executing trailling stop",GetLastError());
					}
				}
			}
			//Type sell
			else if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
			{
				if(UltimoTick() < PositionGetDouble(POSITION_PRICE_OPEN)-NormalizePrice(distancia_stop))
				{
					if(UltimoTick() < (PositionGetDouble(POSITION_SL)-NormalizePrice(stop))-NormalizePrice(pontos))
					{
						if(trade.PositionModify(PositionGetTicket(i),PositionGetDouble(POSITION_SL)-NormalizePrice(pontos),PositionGetDouble(POSITION_TP)))
						{
						
						}
						else
							Print("Error executing trailling stop ",GetLastError());
					}
				}
			}
		}
	}
}
//---
//---Normaliza o preço
double NormalizePrice(double price, string symbol=NULL, double tick=0)
{
   static const double _tick = tick ? tick : SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   return round(price / _tick) * _tick;
}
//---
double UltimoTick()//Last tick
{
	return SymbolInfoDouble(_Symbol,SYMBOL_LAST);
}