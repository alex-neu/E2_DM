
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПоказыватьИнформацию = Истина;
	ПоказыватьОшибки = Истина;
	ПоказыватьПредупреждения = Истина;
	СобытияКлиента = Истина;
	СобытияСервера = Истина;
	ПоказыватьСообщенияОПроблемахОтПользователей = Истина;

	Если Не РольДоступна("ПолныеПрава") Тогда
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		Элементы.Пользователь.Доступность = Ложь;
	КонецЕсли;

	ЗаполнитьСписокКлиентовИУстановитьПараметры();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Пользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)

	ЗаполнитьСписокКлиентовИУстановитьПараметры();

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриИзменении(Элемент)

	УстановитьПараметры();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметры()

	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьИнформацию", ПоказыватьИнформацию);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьОшибки", ПоказыватьОшибки);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПредупреждения", ПоказыватьПредупреждения);
	Список.Параметры.УстановитьЗначениеПараметра("СобытияКлиента", СобытияКлиента);
	Список.Параметры.УстановитьЗначениеПараметра("СобытияСервера", СобытияСервера);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаС", ДатаС);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаПо", ДатаПо);
	Список.Параметры.УстановитьЗначениеПараметра("МобильныйКлиент", МобильныйКлиент);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
	Список.Параметры.УстановитьЗначениеПараметра(
		"ПоказыватьСообщенияОПроблемахОтПользователей", ПоказыватьСообщенияОПроблемахОтПользователей);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКлиентов()

	МобильныйКлиент = ПланыОбмена.Мобильный.ПустаяСсылка();
	Узлы = ОбменСМобильнымиСерверПовтИсп.ПолучитьУзлыОбменаПоВладельцу(Пользователь);

	Элементы.МобильныйКлиент.СписокВыбора.Очистить();
	Элементы.МобильныйКлиент.КнопкаВыпадающегоСписка = Ложь;

	Для Каждого Узел Из Узлы Цикл

		Элементы.МобильныйКлиент.СписокВыбора.Добавить(Узел, Строка(Узел));
		Элементы.МобильныйКлиент.КнопкаВыпадающегоСписка = Истина;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКлиентовИУстановитьПараметры()

	ЗаполнитьСписокКлиентов();
	УстановитьПараметры();

КонецПроцедуры;

#КонецОбласти
