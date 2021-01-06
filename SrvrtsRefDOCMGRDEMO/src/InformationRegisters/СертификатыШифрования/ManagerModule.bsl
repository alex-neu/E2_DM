
Процедура СкопироватьСертификатыШифрования(Источник, Приемник) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений["СертификатыШифрования"].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ЗашифрованныйОбъект.Установить(Источник);
	НаборЗаписей.Прочитать();
	
	НаборЗаписей.Отбор.ЗашифрованныйОбъект.Установить(Приемник);
	Для Каждого Стр Из НаборЗаписей Цикл
		Стр.ЗашифрованныйОбъект = Приемник;
	КонецЦикла;	
	НаборЗаписей.Записать();
	

КонецПроцедуры
