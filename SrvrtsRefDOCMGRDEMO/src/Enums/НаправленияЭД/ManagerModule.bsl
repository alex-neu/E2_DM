
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений();
	ДанныеВыбора.Добавить(Новый Структура("Значение", Входящий));
	ДанныеВыбора.Добавить(Новый Структура("Значение", Исходящий));
	
КонецПроцедуры

#КонецЕсли
