
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЭтоГруппа Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
		Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры
