Процедура ОтправитьСообщение(ТранспортСсылка, Сообщение) Экспорт
	
	НастройкаТранспорта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТранспортСсылка, "Настройка");
	МенеджерНастройки = ОбщегоНазначения.МенеджерОбъектаПоСсылке(НастройкаТранспорта);
	
	МенеджерНастройки.ОтправитьСообщение(НастройкаТранспорта, Сообщение);
	
КонецПроцедуры